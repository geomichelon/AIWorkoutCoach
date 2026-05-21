public struct AIWorkoutPlanResponseDTO: Sendable, Equatable {
    public let goal: String
    public let fitnessLevel: String
    public let workouts: [AIWorkoutDTO]

    public init(goal: String, fitnessLevel: String, workouts: [AIWorkoutDTO]) {
        self.goal = goal
        self.fitnessLevel = fitnessLevel
        self.workouts = workouts
    }

    public static let invalidMock = AIWorkoutPlanResponseDTO(
        goal: TrainingGoal.strength.rawValue,
        fitnessLevel: FitnessLevel.intermediate.rawValue,
        workouts: []
    )

    public static let demoMock = AIWorkoutPlanResponseDTO(
        goal: TrainingGoal.strength.rawValue,
        fitnessLevel: FitnessLevel.intermediate.rawValue,
        workouts: [
            AIWorkoutDTO(
                title: "Treino A",
                exercises: [
                    AIExerciseDTO(name: "Agachamento goblet", muscleGroup: "Pernas", durationInMinutes: 12),
                    AIExerciseDTO(name: "Flexao", muscleGroup: "Peito", durationInMinutes: 10),
                    AIExerciseDTO(name: "Prancha", muscleGroup: "Core", durationInMinutes: 8)
                ]
            )
        ]
    )
}
