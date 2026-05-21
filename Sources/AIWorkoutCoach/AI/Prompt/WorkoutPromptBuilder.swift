public struct WorkoutPromptBuilder: Sendable {
    public init() {}

    public func buildPrompt(input: WorkoutRecommendationInput) -> String {
        """
        Create a weekly workout plan.
        User: \(input.user.name)
        Goal: \(input.goal.rawValue)
        Fitness level: \(input.fitnessLevel.rawValue)
        Available days per week: \(input.availableDaysPerWeek)
        Health restrictions: \(input.user.healthRestrictions.map(\.name).joined(separator: ", "))
        Return structured data with workouts and exercises only.
        """
    }
}
