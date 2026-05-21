public protocol GenerateWorkoutPlanUseCasing: Sendable {
    func execute(input: WorkoutRecommendationInput) async throws -> WorkoutPlan
}

public struct GenerateWorkoutPlanUseCase: GenerateWorkoutPlanUseCasing, Sendable {
    private let provider: AIRecommendationProvider
    private let repository: WorkoutPlanRepository
    private let promptBuilder: WorkoutPromptBuilder
    private let aiResponseValidator: AIResponseValidator
    private let mapper: WorkoutPlanMapper
    private let workoutPlanValidator: WorkoutPlanValidator

    public init(
        provider: AIRecommendationProvider,
        repository: WorkoutPlanRepository,
        promptBuilder: WorkoutPromptBuilder = WorkoutPromptBuilder(),
        aiResponseValidator: AIResponseValidator = AIResponseValidator(),
        mapper: WorkoutPlanMapper = WorkoutPlanMapper(),
        workoutPlanValidator: WorkoutPlanValidator = WorkoutPlanValidator()
    ) {
        self.provider = provider
        self.repository = repository
        self.promptBuilder = promptBuilder
        self.aiResponseValidator = aiResponseValidator
        self.mapper = mapper
        self.workoutPlanValidator = workoutPlanValidator
    }

    public func execute(input: WorkoutRecommendationInput) async throws -> WorkoutPlan {
        let prompt = promptBuilder.buildPrompt(input: input)
        let response = try await provider.generateRecommendation(prompt: prompt, input: input)

        try aiResponseValidator.validate(response)

        let plan = try mapper.map(response: response, userID: input.user.id)
        try workoutPlanValidator.validate(plan: plan, for: input.user)

        try await repository.save(plan)
        return plan
    }
}
