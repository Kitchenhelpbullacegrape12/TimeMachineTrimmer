import SwiftUI

struct BackupListView: View {
    let backups: [TimeMachineBackup]
    var selection: Binding<Set<String>>?

    var body: some View {
        Table(of: TimeMachineBackup.self, selection: selection ?? .constant([])) {
            TableColumn("Date") { backup in
                Text(backup.dateShortFormatted)
                    .monospacedDigit()
                    .font(.body)
            }
            .width(min: 100, ideal: 130, max: 180)

            TableColumn("Age") { backup in
                Text(backup.ageFormatted)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }
            .width(min: 70, ideal: 90, max: 120)

            TableColumn("Volume") { backup in
                Text(backup.volumeName)
                    .font(.body)
            }
            .width(min: 120, ideal: 200)

            TableColumn("Snapshot") { backup in
                Text(backup.snapshotName ?? "\u{2014}")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            .width(min: 180, ideal: 300)
        } rows: {
            ForEach(backups) { backup in
                TableRow(backup)
            }
        }
    }
}
