import Foundation

struct TimeMachineBackup: Identifiable, Equatable {
    let id: String
    let date: Date
    let path: String
    let volumeName: String
    let snapshotName: String?
    let volumePath: String?
    var dateFormatted: String {
        date.formatted(date: .long, time: .shortened)
    }

    var dateShortFormatted: String {
        date.formatted(date: .numeric, time: .shortened)
    }

    var ageFormatted: String {
        let rel = RelativeDateTimeFormatter()
        rel.unitsStyle = .abbreviated
        return rel.localizedString(for: date, relativeTo: Date())
    }
}
