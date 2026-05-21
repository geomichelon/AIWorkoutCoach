import AIWorkoutCoach
import XCTest

@MainActor
final class WorkoutPerformanceChartsViewModelTests: XCTestCase {
    func testChartsViewModelShouldExposeWorkoutChartData() throws {
        let plan = try makePerformancePlan()

        let viewModel = WorkoutPerformanceChartsViewModel(plan: plan)

        XCTAssertEqual(
            viewModel.workoutChartItems,
            [
                WorkoutPerformanceChartsViewModel.ChartItem(label: "Strength A", value: 30),
                WorkoutPerformanceChartsViewModel.ChartItem(label: "Mobility B", value: 21)
            ]
        )
    }

    func testChartsViewModelShouldExposeMuscleGroupChartData() throws {
        let plan = try makePerformancePlan()

        let viewModel = WorkoutPerformanceChartsViewModel(plan: plan)

        XCTAssertEqual(
            viewModel.muscleGroupChartItems,
            [
                WorkoutPerformanceChartsViewModel.ChartItem(label: "Chest", value: 10),
                WorkoutPerformanceChartsViewModel.ChartItem(label: "Core", value: 14),
                WorkoutPerformanceChartsViewModel.ChartItem(label: "Legs", value: 20),
                WorkoutPerformanceChartsViewModel.ChartItem(label: "Mobility", value: 7)
            ]
        )
    }

    func testChartsViewModelShouldNotRequireAIProvider() throws {
        let plan = try makePerformancePlan()

        let viewModel = WorkoutPerformanceChartsViewModel(plan: plan)

        XCTAssertEqual(viewModel.totalDurationText, "51 min")
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
