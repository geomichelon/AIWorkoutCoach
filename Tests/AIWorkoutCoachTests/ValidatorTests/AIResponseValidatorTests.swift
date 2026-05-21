import AIWorkoutCoach
import XCTest

final class AIResponseValidatorTests: XCTestCase {
    func testAIResponseValidatorShouldRejectInvalidResponse() {
        XCTAssertThrowsError(try AIResponseValidator().validate(TestFixtures.invalidAIResponse())) { error in
            XCTAssertEqual(error as? AIResponseValidationError, .planRequiresAtLeastOneWorkout)
        }
    }

    func testPromptBuilderShouldIncludeGoalFitnessLevelAndAvailableDays() {
        let prompt = WorkoutPromptBuilder().buildPrompt(
            input: WorkoutRecommendationInput(
                user: TestFixtures.user(),
                goal: .weightLoss,
                fitnessLevel: .beginner,
                availableDaysPerWeek: 4
            )
        )

        XCTAssertTrue(prompt.contains("weightLoss"))
        XCTAssertTrue(prompt.contains("beginner"))
        XCTAssertTrue(prompt.contains("4"))
    }
}
