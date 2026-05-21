import AIWorkoutCoach
import XCTest

final class WorkoutPlanMapperTests: XCTestCase {
    func testMapperShouldConvertAIResponseDTOToDomainEntity() throws {
        let user = TestFixtures.user()
        let dto = TestFixtures.validAIResponse()

        let plan = try WorkoutPlanMapper().map(response: dto, userID: user.id)

        XCTAssertEqual(plan.userID, user.id)
        XCTAssertEqual(plan.goal, .strength)
        XCTAssertEqual(plan.fitnessLevel, .intermediate)
        XCTAssertEqual(plan.workouts.first?.title, "Strength A")
        XCTAssertEqual(plan.workouts.first?.exercises.first?.name, "Goblet Squat")
    }
}
