public protocol AIRecommendationProvider: Sendable {
    func generateRecommendation(
        prompt: String,
        input: WorkoutRecommendationInput
    ) async throws -> AIWorkoutPlanResponseDTO
}
