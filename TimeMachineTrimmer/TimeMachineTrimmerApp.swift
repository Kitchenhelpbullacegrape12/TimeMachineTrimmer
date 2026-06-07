import SwiftUI

@main
struct TimeMachineTrimmerApp: App {
    @State private var viewModel = BackupViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
                .frame(minWidth: 720, minHeight: 520)
        }
        .windowResizability(.contentMinSize)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("Scan Backups") {
                    Task { await viewModel.checkPermissionsAndScan() }
                }
                .keyboardShortcut("r", modifiers: .command)
                .disabled(viewModel.state != .ready && viewModel.state != .scanned)
            }

            CommandMenu("Actions") {
                Button("Preview Deletion") {
                    viewModel.computePreview()
                }
                .keyboardShortcut("p", modifiers: .command)
                .disabled(viewModel.state != .scanned)

                Button("Execute Deletion") {
                    Task { await viewModel.executeDeletion() }
                }
                .keyboardShortcut(.delete, modifiers: [.command, .shift])
                .disabled(viewModel.state != .scanned)

                Divider()

                Button("Search Backups") {
                    NotificationCenter.default.post(name: NSNotification.Name("focusSearch"), object: nil)
                }
                .keyboardShortcut("f", modifiers: .command)
                .disabled(viewModel.state != .scanned)
            }
        }
    }
}
