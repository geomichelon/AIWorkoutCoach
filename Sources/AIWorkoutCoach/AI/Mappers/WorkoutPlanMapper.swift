import Foundation

public struct WorkoutPlanMapper: Sendable {
    public init() {}

    public func map(response: AIWorkoutPlanResponseDTO, userID: UUID) throws -> WorkoutPlan {
        let goal = TrainingGoal(rawValue: response.goal)!
        let fitnessLevel = FitnessLevel(rawValue: response.fitnessLevel)!
        let workouts = try response.workouts.map { workoutDTO in
            let exercises = try workoutDTO.exercises.map { exerciseDTO in
                try Exercise(
                    name: exerciseDTO.name,
                    muscleGroup: exerciseDTO.muscleGroup,
                    durationInMinutes: exerciseDTO.durationInMinutes,
                    incompatibleRestrictions: exerciseDTO.incompatibleRestrictionNames.map {
                        HealthRestriction(name: $0)
                    }
                )
            }

            return try Workout(title: workoutDTO.title, exercises: exercises)
        }

        return try WorkoutPlan(
            userID: userID,
            goal: goal,
            fitnessLevel: fitnessLevel,
            workouts: workouts
        )
    }
}
