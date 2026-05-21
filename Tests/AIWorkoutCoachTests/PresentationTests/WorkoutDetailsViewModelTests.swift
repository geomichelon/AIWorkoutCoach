import AIWorkoutCoach
import XCTest

@MainActor
final class WorkoutDetailsViewModelTests: XCTestCase {
    func testDetailsViewModelShouldExposeWorkoutTitle() throws {
        let workout = try TestFixtures.workout(title: "Upper Body")

        let viewModel = WorkoutDetailsViewModel(workout: workout)

        XCTAssertEqual(viewModel.title, "Upper Body")
    }

    func testDetailsViewModelShouldExposeExerciseRows() throws {
        let workout = try TestFixtures.workout(title: "Strength A")

        let viewModel = WorkoutDetailsViewModel(workout: workout)

        XCTAssertEqual(viewModel.exerciseRows.count, 3)
        XCTAssertEqual(viewModel.exerciseRows.first?.name, "Strength A Squat")
        XCTAssertEqual(viewModel.exerciseRows.first?.muscleGroup, "Legs")
    }

    func testDetailsViewModelShouldFormatDuration() throws {
        let workout = try Workout(
            title: "Core",
            exercises: [
                TestFixtures.exercise(name: "Plank", muscleGroup: "Core", duration: 8),
                TestFixtures.exercise(name: "Dead Bug", muscleGroup: "Core", duration: 6),
                TestFixtures.exercise(name: "Side Plank", muscleGroup: "Core", duration: 5)
            ]
        )

        let viewModel = WorkoutDetailsViewModel(workout: workout)

        XCTAssertEqual(viewModel.exerciseRows.first?.durationText, "8 min")
    }

    func testDetailsViewModelShouldExposeRestrictionWarnings() throws {
        let workout = try Workout(
            title: "Leg Day",
            exercises: [
                TestFixtures.exercise(
                    name: "Jump Squat",
                    muscleGroup: "Legs",
                    incompatibleRestrictions: [TestFixtures.kneeRestriction]
                ),
                TestFixtures.exercise(name: "Push Up", muscleGroup: "Chest"),
                TestFixtures.exercise(name: "Plank", muscleGroup: "Core")
            ]
        )

        let viewModel = WorkoutDetailsViewModel(workout: workout)

        XCTAssertTrue(viewModel.exerciseRows[0].hasRestrictionWarning)
        XCTAssertEqual(viewModel.exerciseRows[0].restrictionWarning, "Incompativel com: knee")
        XCTAssertFalse(viewModel.exerciseRows[1].hasRestrictionWarning)
    }

    func testDetailsViewModelShouldNotRequireAIProvider() throws {
        let workout = try TestFixtures.workout(title: "Mobility")

        let viewModel = WorkoutDetailsViewModel(workout: workout)

        XCTAssertEqual(viewModel.exerciseRows.count, workout.exercises.count)
    }
}
