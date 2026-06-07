import SwiftUI

struct TrimManualView: View {
    @Environment(BackupViewModel.self) private var viewModel

    var body: some View {
        HStack(spacing: 8) {
            Button("Select All") { viewModel.selectAllBackups() }
                .buttonStyle(.borderedProminent)
                .tint(Color.accentTeal)
                .controlSize(.small)
            Button("Clear") { viewModel.deselectAllBackups() }
                .buttonStyle(.borderedProminent)
                .tint(.gray)
                .controlSize(.small)
            Spacer()
        }
    }
}
