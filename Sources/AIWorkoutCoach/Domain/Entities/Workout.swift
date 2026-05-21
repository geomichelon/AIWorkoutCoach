public struct Workout: Sendable, Equatable {
    public let title: String
    public let exercises: [Exercise]

    public init(title: String, exercises: [Exercise]) throws {
        guard exercises.count >= 3 else {
            throw WorkoutPlanError.workoutRequiresAtLeastThreeExercises
        }

        self.title = title
        self.exercises = exercises
    }
}
