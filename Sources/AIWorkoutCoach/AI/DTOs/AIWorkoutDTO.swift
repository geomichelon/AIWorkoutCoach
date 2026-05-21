public struct AIWorkoutDTO: Sendable, Equatable {
    public let title: String
    public let exercises: [AIExerciseDTO]

    public init(title: String, exercises: [AIExerciseDTO]) {
        self.title = title
        self.exercises = exercises
    }
}
