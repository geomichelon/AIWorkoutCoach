import AIWorkoutCoach
import XCTest

final class GenerateWorkoutPlanUseCaseTests: XCTestCase {
    func testUseCaseShouldReturnValidWorkoutPlanWhenAIResponseIsValid() async throws {
        let user = TestFixtures.user()
        let repository = InMemoryWorkoutPlanRepository()
        let provider = MockAIRecommendationProvider(mode: .success(TestFixtures.validAIResponse()))
        let useCase = GenerateWorkoutPlanUseCase(provider: provider, repository: repository)

        let plan = try await useCase.execute(
            input: WorkoutRecommendationInput(
                user: user,
                goal: .strength,
                fitnessLevel: .intermediate,
                availableDaysPerWeek: 3
            )
        )

        XCTAssertEqual(plan.userID, user.id)
        XCTAssertEqual(plan.goal, .strength)
        XCTAssertEqual(plan.fitnessLevel, .intermediate)
        XCTAssertEqual(plan.workouts.count, 1)

        let persisted = try await repository.find(by: plan.id)
        XCTAssertEqual(persisted, plan)
    }

    func testUseCaseShouldNotPersistPlanWhenAIResponseIsInvalid() async throws {
        let repository = InMemoryWorkoutPlanRepository()
        let provider = MockAIRecommendationProvider(mode: .invalidResponse)
        let useCase = GenerateWorkoutPlanUseCase(provider: provider, repository: repository)

        do {
            _ = try await useCase.execute(
                input: WorkoutRecommendationInput(
                    user: TestFixtures.user(),
                    goal: .strength,
                    fitnessLevel: .intermediate,
                    availableDaysPerWeek: 3
                )
            )
            XCTFail("Expected invalid AI response to throw.")
        } catch {
            XCTAssertEqual(error as? AIResponseValidationError, .planRequiresAtLeastOneWorkout)
        }

        let persistedPlanCount = await repository.count()
        XCTAssertEqual(persistedPlanCount, 0)
    }
}
