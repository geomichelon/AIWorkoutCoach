public struct AIExerciseDTO: Sendable, Equatable {
    public let name: String
    public let muscleGroup: String
    public let durationInMinutes: Int
    public let incompatibleRestrictionNames: [String]

    public init(
        name: String,
        muscleGroup: String,
        durationInMinutes: Int,
        incompatibleRestrictionNames: [String] = []
    ) {
        self.name = name
        self.muscleGroup = muscleGroup
        self.durationInMinutes = durationInMinutes
        self.incompatibleRestrictionNames = incompatibleRestrictionNames
    }
}
