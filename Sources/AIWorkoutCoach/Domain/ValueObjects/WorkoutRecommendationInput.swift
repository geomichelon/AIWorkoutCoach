public struct WorkoutRecommendationInput: Sendable, Equatable {
    public let user: User
    public let goal: TrainingGoal
    public let fitnessLevel: FitnessLevel
    public let availableDaysPerWeek: Int

    public init(
        user: User,
        goal: TrainingGoal,
        fitnessLevel: FitnessLevel,
        availableDaysPerWeek: Int
    ) {
        self.user = user
        self.goal = goal
        self.fitnessLevel = fitnessLevel
        self.availableDaysPerWeek = availableDaysPerWeek
    }
}
