import Foundation

public struct Exercise: Sendable, Equatable {
    public let name: String
    public let muscleGroup: String
    public let durationInMinutes: Int
    public let incompatibleRestrictions: [HealthRestriction]

    public init(
        name: String,
        muscleGroup: String,
        durationInMinutes: Int,
        incompatibleRestrictions: [HealthRestriction] = []
    ) throws {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw WorkoutPlanError.exerciseNameRequired
        }
        guard !muscleGroup.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw WorkoutPlanError.exerciseMuscleGroupRequired
        }
        guard durationInMinutes > 0 else {
            throw WorkoutPlanError.exerciseDurationMustBePositive
        }

        self.name = name
        self.muscleGroup = muscleGroup
        self.durationInMinutes = durationInMinutes
        self.incompatibleRestrictions = incompatibleRestrictions
    }
}
