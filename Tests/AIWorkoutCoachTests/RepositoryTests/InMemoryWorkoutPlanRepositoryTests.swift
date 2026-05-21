import AIWorkoutCoach
import XCTest

final class InMemoryWorkoutPlanRepositoryTests: XCTestCase {
    func testRepositoryShouldSaveAndFindWorkoutPlan() async throws {
        let repository = InMemoryWorkoutPlanRepository()
        let plan = try TestFixtures.plan()

        try await repository.save(plan)
        let found = try await repository.find(by: plan.id)

        XCTAssertEqual(found, plan)
    }
}
