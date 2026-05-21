import AIWorkoutCoach
import SwiftUI

struct WorkoutDetailsView: View {
    @StateObject private var viewModel: WorkoutDetailsViewModel

    init(workout: Workout) {
        _viewModel = StateObject(wrappedValue: WorkoutDetailsViewModel(workout: workout))
    }

    var body: some View {
        List {
            Section("Exercicios") {
                ForEach(viewModel.exerciseRows) { row in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(row.name)
                            .font(.headline)

                        Text("\(row.muscleGroup) - \(row.durationText)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        if let warning = row.restrictionWarning {
                            Label(warning, systemImage: "exclamationmark.triangle")
                                .font(.caption)
                                .foregroundStyle(.orange)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle(viewModel.title)
    }
}
