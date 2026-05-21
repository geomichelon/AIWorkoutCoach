import Combine
import Foundation

@MainActor
public final class WorkoutPlanViewModel: ObservableObject {
    @Published public private(set) var isLoading = false
    @Published public private(set) var workoutPlan: WorkoutPlan?
    @Published public private(set) var errorMessage: String?

    private let useCase: GenerateWorkoutPlanUseCasing
    private let input: WorkoutRecommendationInput

    public init(
        useCase: GenerateWorkoutPlanUseCasing,
        input: WorkoutRecommendationInput
    ) {
        self.useCase = useCase
        self.input = input
    }

    public func generatePlan() async {
        isLoading = true
        errorMessage = nil

        do {
            workoutPlan = try await useCase.execute(input: input)
        } catch {
            workoutPlan = nil
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
