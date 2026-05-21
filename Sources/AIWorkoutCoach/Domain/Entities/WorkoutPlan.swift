import Foundation

public struct WorkoutPlan: Identifiable, Sendable, Equatable {
    public let id: UUID
    public let userID: UUID
    public let goal: TrainingGoal
    public let fitnessLevel: FitnessLevel
    public let workouts: [Workout]

    public init(
        id: UUID = UUID(),
        userID: UUID,
        goal: TrainingGoal,
        fitnessLevel: FitnessLevel,
        workouts: [Workout]
    ) throws {
        guard !workouts.isEmpty else {
            throw WorkoutPlanError.planRequiresAtLeastOneWorkout
        }
        guard workouts.count <= 7 else {
            throw WorkoutPlanError.planCannotHaveMoreThanSevenWorkouts
        }

        self.id = id
        self.userID = userID
        self.goal = goal
        self.fitnessLevel = fitnessLevel
        self.workouts = workouts
    }
}
