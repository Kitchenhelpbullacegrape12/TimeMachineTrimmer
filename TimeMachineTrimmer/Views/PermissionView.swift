import SwiftUI

struct PermissionView: View {
    @Environment(BackupViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "lock.shield")
                .font(.system(size: 32))
                .foregroundStyle(Color.actionCoral)

            VStack(spacing: 4) {
                Text("Limited Mode")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("Backups are listed via APFS snapshots.\nGrant Full Disk Access for tmutil integration.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }

            VStack(alignment: .leading, spacing: 6) {
                featureRow(active: true, text: "List backups (APFS snapshots)")
                featureRow(active: true, text: "Delete snapshots (admin password)")
                featureRow(active: false, text: "tmutil listbackups (requires FDA)")
            }
            .padding(12)
            .background(.fill.quaternary, in: RoundedRectangle(cornerRadius: 8))

            Button {
                viewModel.requestPermissions()
            } label: {
                Label("Open System Settings", systemImage: "gearshape")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            Text("Settings \u{2192} Privacy & Security \u{2192} Full Disk Access \u{2192} add TimeMachineTrimmer")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)

            Text("Note: Grant persists as long as source code isn\u{2019}t changed.")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Continue without Full Disk Access") {
                viewModel.needsPermissionSheet = false
                dismiss()
            }
            .buttonStyle(.link)
            .controlSize(.small)

            Button("Re-scan after granting") {
                viewModel.needsPermissionSheet = false
                dismiss()
                Task { await viewModel.checkPermissionsAndScan() }
            }
            .buttonStyle(.bordered)
            .controlSize(.small)

            Spacer()
        }
        .padding(24)
        .frame(width: 400, height: 460)
    }

    private func featureRow(active: Bool, text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: active ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundStyle(active ? Color.accentTeal : .secondary)
                .imageScale(.small)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(active ? .primary : .secondary)
        }
    }
}
