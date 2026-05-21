import AIWorkoutCoach
import XCTest

final class WorkoutPlanValidatorTests: XCTestCase {
    func testValidatorShouldRejectPlanWithExerciseIncompatibleWithHealthRestriction() throws {
        let user = TestFixtures.user(restrictions: [TestFixtures.kneeRestriction])
        let riskyExercise = try TestFixtures.exercise(
            name: "Jump Squat",
            muscleGroup: "Legs",
            incompatibleRestrictions: [TestFixtures.kneeRestriction]
        )
        let workout = try Workout(
            title: "Leg Day",
            exercises: [
                riskyExercise,
                try TestFixtures.exercise(name: "Push Up", muscleGroup: "Chest"),
                try TestFixtures.exercise(name: "Plank", muscleGroup: "Core")
            ]
        )
        let plan = try TestFixtures.plan(userID: user.id, workouts: [workout])

        XCTAssertThrowsError(try WorkoutPlanValidator().validate(plan: plan, for: user)) { error in
            XCTAssertEqual(
                error as? WorkoutPlanError,
                .exerciseIncompatibleWithHealthRestriction(exerciseName: "Jump Squat", restriction: "knee")
            )
        }
    }
}
