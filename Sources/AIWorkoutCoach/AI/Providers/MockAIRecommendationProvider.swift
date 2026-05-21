public final class MockAIRecommendationProvider: AIRecommendationProvider, @unchecked Sendable {
    public enum Mode: Sendable {
        case success(AIWorkoutPlanResponseDTO)
        case invalidResponse
        case failure(Error)
        case timeout
    }

    private let mode: Mode

    public init(mode: Mode) {
        self.mode = mode
    }

    public func generateRecommendation(
        prompt: String,
        input: WorkoutRecommendationInput
    ) async throws -> AIWorkoutPlanResponseDTO {
        switch mode {
        case let .success(response):
            return response
        case .invalidResponse:
            return .invalidMock
        case let .failure(error):
            throw error
        case .timeout:
            throw AIProviderError.timeout
        }
    }
}

public enum AIProviderError: Error, Equatable {
    case timeout
    case unavailable
}
