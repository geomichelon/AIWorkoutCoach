import Foundation

public enum AIResponseValidationError: Error, Equatable {
    case invalidGoal(String)
    case invalidFitnessLevel(String)
    case planRequiresAtLeastOneWorkout
    case planCannotHaveMoreThanSevenWorkouts
    case workoutRequiresAtLeastThreeExercises
    case exerciseNameRequired
    case exerciseMuscleGroupRequired
    case exerciseDurationMustBePositive
}

public struct AIResponseValidator: Sendable {
    public init() {}

    public func validate(_ response: AIWorkoutPlanResponseDTO) throws {
        guard TrainingGoal(rawValue: response.goal) != nil else {
            throw AIResponseValidationError.invalidGoal(response.goal)
        }
        guard FitnessLevel(rawValue: response.fitnessLevel) != nil else {
            throw AIResponseValidationError.invalidFitnessLevel(response.fitnessLevel)
        }
        guard !response.workouts.isEmpty else {
            throw AIResponseValidationError.planRequiresAtLeastOneWorkout
        }
        guard response.workouts.count <= 7 else {
            throw AIResponseValidationError.planCannotHaveMoreThanSevenWorkouts
        }

        for workout in response.workouts {
            guard workout.exercises.count >= 3 else {
                throw AIResponseValidationError.workoutRequiresAtLeastThreeExercises
            }

            for exercise in workout.exercises {
                guard !exercise.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    throw AIResponseValidationError.exerciseNameRequired
                }
                guard !exercise.muscleGroup.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    throw AIResponseValidationError.exerciseMuscleGroupRequired
                }
                guard exercise.durationInMinutes > 0 else {
                    throw AIResponseValidationError.exerciseDurationMustBePositive
                }
            }
        }
    }
}
