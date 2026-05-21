import Foundation

public enum WorkoutPlanError: Error, Equatable, LocalizedError {
    case planCannotHaveMoreThanSevenWorkouts
    case planRequiresAtLeastOneWorkout
    case workoutRequiresAtLeastThreeExercises
    case exerciseNameRequired
    case exerciseMuscleGroupRequired
    case exerciseDurationMustBePositive
    case exerciseIncompatibleWithHealthRestriction(exerciseName: String, restriction: String)

    public var errorDescription: String? {
        switch self {
        case .planCannotHaveMoreThanSevenWorkouts:
            "A workout plan cannot have more than 7 workouts per week."
        case .planRequiresAtLeastOneWorkout:
            "A workout plan must have at least 1 workout."
        case .workoutRequiresAtLeastThreeExercises:
            "Each workout must have at least 3 exercises."
        case .exerciseNameRequired:
            "Each exercise must have a name."
        case .exerciseMuscleGroupRequired:
            "Each exercise must have a muscle group."
        case .exerciseDurationMustBePositive:
            "Each exercise must have a positive duration."
        case let .exerciseIncompatibleWithHealthRestriction(exerciseName, restriction):
            "Exercise \(exerciseName) is incompatible with health restriction \(restriction)."
        }
    }
}
