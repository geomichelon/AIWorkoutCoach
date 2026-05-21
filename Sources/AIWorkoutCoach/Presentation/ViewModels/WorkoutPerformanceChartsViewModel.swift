import Foundation

@MainActor
public final class WorkoutPerformanceChartsViewModel: ObservableObject {
    public struct ChartItem: Identifiable, Equatable {
        public let id: String
        public let label: String
        public let value: Int

        public init(label: String, value: Int) {
            self.id = label
            self.label = label
            self.value = value
        }
    }

    public let totalDurationText: String
    public let workoutChartItems: [ChartItem]
    public let muscleGroupChartItems: [ChartItem]

    public init(
        plan: WorkoutPlan,
        analyzer: WorkoutPerformanceAnalyzer = WorkoutPerformanceAnalyzer()
    ) {
        totalDurationText = "\(analyzer.totalWorkoutDuration(in: plan)) min"
        workoutChartItems = analyzer
            .totalDurationByWorkout(in: plan)
            .map { ChartItem(label: $0.label, value: $0.durationInMinutes) }
        muscleGroupChartItems = analyzer
            .totalDurationByMuscleGroup(in: plan)
            .map { ChartItem(label: $0.label, value: $0.durationInMinutes) }
    }
}
