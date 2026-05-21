public struct WorkoutRecommendation: Sendable, Equatable {
    public let plan: WorkoutPlan

    public init(plan: WorkoutPlan) {
        self.plan = plan
    }
}
