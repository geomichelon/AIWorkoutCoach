import Foundation

@MainActor
public final class WorkoutDetailsViewModel: ObservableObject {
    public struct ExerciseRow: Identifiable, Equatable {
        public let id: String
        public let name: String
        public let muscleGroup: String
        public let durationText: String
        public let restrictionWarning: String?

        public var hasRestrictionWarning: Bool {
            restrictionWarning != nil
        }
    }

    public let title: String
    public let exerciseRows: [ExerciseRow]

    public init(workout: Workout) {
        title = workout.title
        exerciseRows = workout.exercises.map { exercise in
            let restrictionNames = exercise.incompatibleRestrictions.map(\.name)
            let warning = restrictionNames.isEmpty
                ? nil
                : "Incompativel com: \(restrictionNames.joined(separator: ", "))"

            return ExerciseRow(
                id: "\(exercise.name)-\(exercise.muscleGroup)-\(exercise.durationInMinutes)",
                name: exercise.name,
                muscleGroup: exercise.muscleGroup,
                durationText: "\(exercise.durationInMinutes) min",
                restrictionWarning: warning
            )
        }
    }
}
