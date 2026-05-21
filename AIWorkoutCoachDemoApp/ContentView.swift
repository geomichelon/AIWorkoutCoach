import AIWorkoutCoach
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: WorkoutPlanViewModel

    init(viewModel: WorkoutPlanViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        Task {
                            await viewModel.generatePlan()
                        }
                    } label: {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Label("Gerar treino", systemImage: "figure.strengthtraining.traditional")
                        }
                    }
                    .disabled(viewModel.isLoading)
                }

                if let errorMessage = viewModel.errorMessage {
                    Section("Erro") {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }

                if let plan = viewModel.workoutPlan {
                    Section("Plano") {
                        Text("Objetivo: \(plan.goal.rawValue)")
                        Text("Nivel: \(plan.fitnessLevel.rawValue)")
                    }

                    ForEach(plan.workouts, id: \.title) { workout in
                        Section(workout.title) {
                            ForEach(workout.exercises, id: \.name) { exercise in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(exercise.name)
                                        .font(.headline)
                                    Text("\(exercise.muscleGroup) - \(exercise.durationInMinutes) min")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("AIWorkoutCoach")
        }
    }
}

enum DemoDependencies {
    @MainActor
    static func makeViewModel() -> WorkoutPlanViewModel {
        let user = User(name: "Taylor")
        let input = WorkoutRecommendationInput(
            user: user,
            goal: .strength,
            fitnessLevel: .intermediate,
            availableDaysPerWeek: 3
        )
        let provider = MockAIRecommendationProvider(mode: .success(.demoMock))
        let repository = InMemoryWorkoutPlanRepository()
        let useCase = GenerateWorkoutPlanUseCase(provider: provider, repository: repository)

        return WorkoutPlanViewModel(useCase: useCase, input: input)
    }
}
