import AIWorkoutCoach
import Foundation

enum TestFixtures {
    static let kneeRestriction = HealthRestriction(name: "knee")

    static func user(
        id: UUID = UUID(),
        restrictions: [HealthRestriction] = []
    ) -> User {
        User(id: id, name: "Taylor", healthRestrictions: restrictions)
    }

    static func exercise(
        name: String = "Squat",
        muscleGroup: String = "Legs",
        duration: Int = 10,
        incompatibleRestrictions: [HealthRestriction] = []
    ) throws -> Exercise {
        try Exercise(
            name: name,
            muscleGroup: muscleGroup,
            durationInMinutes: duration,
            incompatibleRestrictions: incompatibleRestrictions
        )
    }

    static func workout(title: String = "Workout A") throws -> Workout {
        try Workout(
            title: title,
            exercises: [
                exercise(name: "\(title) Squat", muscleGroup: "Legs"),
                exercise(name: "\(title) Push Up", muscleGroup: "Chest"),
                exercise(name: "\(title) Plank", muscleGroup: "Core")
            ]
        )
    }

    static func plan(userID: UUID = UUID(), workouts: [Workout]? = nil) throws -> WorkoutPlan {
        try WorkoutPlan(
            userID: userID,
            goal: .strength,
            fitnessLevel: .intermediate,
            workouts: workouts ?? [workout()]
        )
    }

    static func validAIResponse() -> AIWorkoutPlanResponseDTO {
        AIWorkoutPlanResponseDTO(
            goal: TrainingGoal.strength.rawValue,
            fitnessLevel: FitnessLevel.intermediate.rawValue,
            workouts: [
                AIWorkoutDTO(
                    title: "Strength A",
                    exercises: [
                        AIExerciseDTO(name: "Goblet Squat", muscleGroup: "Legs", durationInMinutes: 12),
                        AIExerciseDTO(name: "Push Up", muscleGroup: "Chest", durationInMinutes: 10),
                        AIExerciseDTO(name: "Plank", muscleGroup: "Core", durationInMinutes: 8)
                    ]
                )
            ]
        )
    }

    static func invalidAIResponse() -> AIWorkoutPlanResponseDTO {
        AIWorkoutPlanResponseDTO(
            goal: TrainingGoal.strength.rawValue,
            fitnessLevel: FitnessLevel.intermediate.rawValue,
            workouts: []
        )
    }
}
