import AIWorkoutCoach
import XCTest

final class WorkoutPerformanceAnalyzerTests: XCTestCase {
    func testPerformanceAnalyzerShouldCalculateTotalDurationByWorkout() throws {
        let plan = try makePerformancePlan()

        let result = WorkoutPerformanceAnalyzer().totalDurationByWorkout(in: plan)

        XCTAssertEqual(
            result,
            [
                WorkoutPerformanceMetric(label: "Strength A", durationInMinutes: 30),
                WorkoutPerformanceMetric(label: "Mobility B", durationInMinutes: 21)
            ]
        )
    }

    func testPerformanceAnalyzerShouldCalculateTotalDurationByMuscleGroup() throws {
        let plan = try makePerformancePlan()

        let result = WorkoutPerformanceAnalyzer().totalDurationByMuscleGroup(in: plan)

        XCTAssertEqual(
            result,
            [
                WorkoutPerformanceMetric(label: "Chest", durationInMinutes: 10),
                WorkoutPerformanceMetric(label: "Core", durationInMinutes: 14),
                WorkoutPerformanceMetric(label: "Legs", durationInMinutes: 20),
                WorkoutPerformanceMetric(label: "Mobility", durationInMinutes: 7)
            ]
        )
    }

    func testPerformanceAnalyzerShouldCalculateTotalWorkoutDuration() throws {
        let plan = try makePerformancePlan()

        let result = WorkoutPerformanceAnalyzer().totalWorkoutDuration(in: plan)

        XCTAssertEqual(result, 51)
    }

    private func makePerformancePlan() throws -> WorkoutPlan {
        let strengthWorkout = try Workout(
            title: "Strength A",
            exercises: [
                TestFixtures.exercise(name: "Squat", muscleGroup: "Legs", duration: 12),
                TestFixtures.exercise(name: "Push Up", muscleGroup: "Chest", duration: 10),
                TestFixtures.exercise(name: "Plank", muscleGroup: "Core", duration: 8)
            ]
        )
        let mobilityWorkout = try Workout(
            title: "Mobility B",
            exercises: [
                TestFixtures.exercise(name: "Lunge", muscleGroup: "Legs", duration: 8),
                TestFixtures.exercise(name: "Dead Bug", muscleGroup: "Core", duration: 6),
                TestFixtures.exercise(name: "Hip Flow", muscleGroup: "Mobility", duration: 7)
            ]
        )

        return try TestFixtures.plan(workouts: [strengthWorkout, mobilityWorkout])
    }
}
