import Foundation

public protocol WorkoutPlanRepository: Sendable {
    func save(_ plan: WorkoutPlan) async throws
    func find(by id: UUID) async throws -> WorkoutPlan?
}
