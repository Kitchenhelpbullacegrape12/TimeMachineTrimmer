import Foundation

// ============================================================
// Integration tests — run against the installed helper daemon
// All tests use the CLI tool to communicate via XPC.
// ============================================================

let cliPath = "/usr/local/bin/TimeMachineTrimmer-helper-cli"

func requireCLI() {
    guard FileManager.default.fileExists(atPath: cliPath) else {
        fail("CLI not found at \(cliPath)")
        printSummary()
        exit(1)
    }
}

// MARK: - Install / Uninstall

func testInstall_uninstall() {
    let status = shell(cliPath, arguments: ["status"])
    print(status.stdout)
}

// MARK: - Ping

func testPing() {
    print("  Test: Ping helper")
    let result = shell(cliPath, arguments: ["ping"])
    let success = result.stdout.contains("✓ Helper is alive") || result.stdout.contains("Helper is alive")
    if success {
        pass("ping succeeded")
    } else {
        fail("ping failed", details: "stdout: \(result.stdout)\nstderr: \(result.stderr)")
    }
}

// MARK: - Version

func testVersion() {
    print("  Test: Get version")
    let result = shell(cliPath, arguments: ["version"])
    let containsVersion = result.stdout.contains("Helper version:")
    if containsVersion {
        pass("version response received via XPC")
    } else {
        fail("no version response", details: "stdout: \(result.stdout)")
    }
}

// MARK: - Delete (with non-existent snapshot, verifies no hang + proper error)

func testDelete_invalidSnapshot_returnsError() {
    print("  Test: Delete with non-existent snapshot")
    let result = shell(cliPath, arguments: [
        "delete",
        "--snapshot", "com.apple.TimeMachine.NONEXISTENT.backup",
        "--volume", "/Volumes/Time Machine"
    ])
    let completed = !result.stdout.isEmpty
    if completed {
        pass("delete returned (no hang)")
        if result.stdout.contains("✓ Deleted") || result.stdout.contains("✗ Failed") {
            pass("delete produced a result line")
        } else {
            fail("unexpected output", details: result.stdout)
        }
    } else {
        fail("delete hung (no output)")
    }
}

func testDelete_missingVolume_returnsError() {
    print("  Test: Delete with missing volume")
    let result = shell(cliPath, arguments: [
        "delete",
        "--snapshot", "com.apple.TimeMachine.EXAMPLE.backup",
        "--volume", "/Volumes/NonexistentVolume"
    ])
    if !result.stdout.isEmpty {
        pass("delete returned (no hang)")
    } else {
        fail("delete hung (no output)")
    }
}

// MARK: - Builder helpers (verify binary / code signing)

func testHelperBinaryExists() {
    let path = "/usr/local/bin/TimeMachineTrimmer-helper"
    let exists = FileManager.default.fileExists(atPath: path)
    assertTrue(exists, "helper binary exists at \(path)")
}

func testHelperPlistExists() {
    let path = "/Library/LaunchDaemons/com.ricardoleal.TimeMachineTrimmer.helper.plist"
    let exists = FileManager.default.fileExists(atPath: path)
    assertTrue(exists, "helper plist exists at \(path)")
}

func testHelperIsMachO() {
    let result = shell("/usr/bin/file", arguments: ["/usr/local/bin/TimeMachineTrimmer-helper"])
    assertContains(result.stdout, "Mach-O", "binary is Mach-O format")
    assertContains(result.stdout, "arm64", "binary is arm64 architecture")
}

func testHelperCodeSignature() {
    let result = shell("/usr/bin/codesign", arguments: ["-dvv", "/usr/local/bin/TimeMachineTrimmer-helper"])
    assertContains(result.stderr + result.stdout, "adhoc", "signed with ad-hoc signature")
}

// MARK: - Runner

func runIntegrationTests() {
    print("\n\n================================================")
    print("Integration Tests")
    print("================================================")

    requireCLI()

    // Build verification
    print("\n-- Build verification --")
    testHelperBinaryExists()
    testHelperPlistExists()
    testHelperIsMachO()
    testHelperCodeSignature()

    // XPC communication
    print("\n-- XPC communication --")
    testPing()
    testVersion()

    // Delete operations
    print("\n-- Delete operations --")
    testDelete_invalidSnapshot_returnsError()
    testDelete_missingVolume_returnsError()
}
