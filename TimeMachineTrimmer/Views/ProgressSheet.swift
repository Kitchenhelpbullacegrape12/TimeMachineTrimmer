import SwiftUI

struct ProgressSheet: View {
    @Environment(BackupViewModel.self) private var viewModel

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "trash.fill")
                .font(.title2)
                .foregroundStyle(.red)

            Text("Deleting Backups…")
                .font(.title3)
                .fontWeight(.semibold)

            ProgressView(value: viewModel.deletionProgress) {
                Text("\(Int(viewModel.deletionProgress * 100))%")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
                    .contentTransition(.numericText())
            }
            .progressViewStyle(.linear)
            .padding(.horizontal)

            logSection
        }
        .frame(width: 500, height: 360)
    }

    private var logSection: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(Array(viewModel.deletionLog.enumerated()), id: \.offset) { _, entry in
                        Text(entry)
                            .font(.caption)
                            .monospaced()
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(10)
            }
            .background(.fill.quinary, in: RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal)
            .onChange(of: viewModel.deletionLog.count) { _, _ in
                if !viewModel.deletionLog.isEmpty {
                    proxy.scrollTo(viewModel.deletionLog.count - 1, anchor: .bottom)
                }
            }
        }
    }
}
