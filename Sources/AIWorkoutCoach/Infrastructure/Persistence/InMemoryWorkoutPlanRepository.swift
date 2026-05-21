import Foundation

public actor InMemoryWorkoutPlanRepository: WorkoutPlanRepository {
    private var plans: [UUID: WorkoutPlan] = [:]

    public init() {}

    public func save(_ plan: WorkoutPlan) async throws {
        plans[plan.id] = plan
    }

    public func find(by id: UUID) async throws -> WorkoutPlan? {
        plans[id]
    }

    public func count() async -> Int {
        plans.count
    }
}
