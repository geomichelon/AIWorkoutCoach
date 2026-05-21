public struct WorkoutPerformanceMetric: Sendable, Equatable {
    public let label: String
    public let durationInMinutes: Int

    public init(label: String, durationInMinutes: Int) {
        self.label = label
        self.durationInMinutes = durationInMinutes
    }
}

public struct WorkoutPerformanceAnalyzer: Sendable {
    public init() {}

    public func totalDurationByWorkout(in plan: WorkoutPlan) -> [WorkoutPerformanceMetric] {
        plan.workouts.map { workout in
            WorkoutPerformanceMetric(
                label: workout.title,
                durationInMinutes: workout.exercises.reduce(0) { $0 + $1.durationInMinutes }
            )
        }
    }

    public func totalDurationByMuscleGroup(in plan: WorkoutPlan) -> [WorkoutPerformanceMetric] {
        let durations = plan.workouts
            .flatMap(\.exercises)
            .reduce(into: [String: Int]()) { partialResult, exercise in
                partialResult[exercise.muscleGroup, default: 0] += exercise.durationInMinutes
            }

        return durations
            .map { WorkoutPerformanceMetric(label: $0.key, durationInMinutes: $0.value) }
            .sorted { $0.label < $1.label }
    }

    public func totalWorkoutDuration(in plan: WorkoutPlan) -> Int {
        plan.workouts
            .flatMap(\.exercises)
            .reduce(0) { $0 + $1.durationInMinutes }
    }
}
