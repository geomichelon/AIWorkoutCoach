public struct WorkoutPlanValidator: Sendable {
    public init() {}

    public func validate(plan: WorkoutPlan, for user: User) throws {
        for workout in plan.workouts {
            for exercise in workout.exercises {
                for restriction in user.healthRestrictions {
                    if exercise.incompatibleRestrictions.contains(restriction) {
                        throw WorkoutPlanError.exerciseIncompatibleWithHealthRestriction(
                            exerciseName: exercise.name,
                            restriction: restriction.name
                        )
                    }
                }
            }
        }
    }
}
