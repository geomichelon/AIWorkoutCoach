import AIWorkoutCoach
import XCTest

final class WorkoutPlanTests: XCTestCase {
    func testWorkoutPlanShouldNotAllowMoreThanSevenWorkouts() throws {
        let workouts = try (1...8).map { try TestFixtures.workout(title: "Workout \($0)") }

        XCTAssertThrowsError(
            try WorkoutPlan(
                userID: TestFixtures.user().id,
                goal: .hypertrophy,
                fitnessLevel: .beginner,
                workouts: workouts
            )
        ) { error in
            XCTAssertEqual(error as? WorkoutPlanError, .planCannotHaveMoreThanSevenWorkouts)
        }
    }

    func testWorkoutPlanShouldRequireAtLeastOneWorkout() {
        XCTAssertThrowsError(
            try WorkoutPlan(
                userID: TestFixtures.user().id,
                goal: .hypertrophy,
                fitnessLevel: .beginner,
                workouts: []
            )
        ) { error in
            XCTAssertEqual(error as? WorkoutPlanError, .planRequiresAtLeastOneWorkout)
        }
    }

    func testWorkoutShouldRequireAtLeastThreeExercises() throws {
        let exercises = [
            try TestFixtures.exercise(name: "Push Up"),
            try TestFixtures.exercise(name: "Plank")
        ]

        XCTAssertThrowsError(try Workout(title: "Too Short", exercises: exercises)) { error in
            XCTAssertEqual(error as? WorkoutPlanError, .workoutRequiresAtLeastThreeExercises)
        }
    }

    func testExerciseShouldRequirePositiveDuration() {
        XCTAssertThrowsError(
            try Exercise(name: "Squat", muscleGroup: "Legs", durationInMinutes: 0)
        ) { error in
            XCTAssertEqual(error as? WorkoutPlanError, .exerciseDurationMustBePositive)
        }
    }
}
