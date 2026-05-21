import Foundation

public struct User: Identifiable, Sendable, Equatable {
    public let id: UUID
    public let name: String
    public let healthRestrictions: [HealthRestriction]

    public init(
        id: UUID = UUID(),
        name: String,
        healthRestrictions: [HealthRestriction] = []
    ) {
        self.id = id
        self.name = name
        self.healthRestrictions = healthRestrictions
    }
}
