import Foundation

struct BackupDestination: Identifiable, Codable {
    let id: String
    let name: String
    let kind: String
    let mountPoint: String?
}

struct TMUtilDestinationPlist: Codable {
    let Destinations: [DestinationEntry]

    struct DestinationEntry: Codable {
        let ID: String
        let Kind: String
        let Name: String
        let MountPoint: String?
    }
}
