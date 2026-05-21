import AIWorkoutCoach
import Foundation
import XCTest

@MainActor
final class WorkoutPlanViewModelTests: XCTestCase {
    func testViewModelShouldSetLoadingStateWhenGeneratingPlan() async throws {
        let viewModel = WorkoutPlanViewModel(
            useCase: DelayedSuccessfulUseCase(),
            input: WorkoutRecommendationInput(
                user: TestFixtures.user(),
                goal: .strength,
                fitnessLevel: .intermediate,
                availableDaysPerWeek: 3
            )
        )

        let task = Task {
            await viewModel.generatePlan()
        }

        await Task.yield()

        XCTAssertTrue(viewModel.isLoading)

        await task.value
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.workoutPlan)
    }

    func testViewModelShouldExposeErrorWhenUseCaseFails() async {
        let viewModel = WorkoutPlanViewModel(
            useCase: FailingUseCase(),
            input: WorkoutRecommendationInput(
                user: TestFixtures.user(),
                goal: .strength,
                fitnessLevel: .intermediate,
                availableDaysPerWeek: 3
            )
        )

        await viewModel.generatePlan()

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.workoutPlan)
        XCTAssertNotNil(viewModel.errorMessage)
    }
}

private struct DelayedSuccessfulUseCase: GenerateWorkoutPlanUseCasing {
    func execute(input: WorkoutRecommendationInput) async throws -> WorkoutPlan {
        try await Task.sleep(nanoseconds: 100_000_000)
        return try TestFixtures.plan(userID: input.user.id)
    }
}

private struct FailingUseCase: GenerateWorkoutPlanUseCasing {
    func execute(input: WorkoutRecommendationInput) async throws -> WorkoutPlan {
        throw NSError(domain: "AIWorkoutCoachTests", code: 1)
    }
}
