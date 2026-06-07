import SwiftUI

struct TrimByAgeView: View {
    @Environment(BackupViewModel.self) private var viewModel

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text("Delete backups older than")
                    .font(.callout)
                Text("\(viewModel.ageThresholdMonths) months")
                    .font(.callout.weight(.semibold))
                    .monospacedDigit()
                    .contentTransition(.numericText())
                Spacer()
            }

            Slider(
                value: Binding(
                    get: { Double(viewModel.ageThresholdMonths) },
                    set: { viewModel.ageThresholdMonths = Int($0) }
                ),
                in: 1...24,
                step: 1
            )
            .padding(.horizontal, 2)

            HStack {
                Text("1 month")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                Spacer()
                Text("24 months")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
    }
}
