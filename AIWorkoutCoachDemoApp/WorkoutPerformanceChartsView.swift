import AIWorkoutCoach
import SwiftUI

struct WorkoutPerformanceChartsView: View {
    @StateObject private var viewModel: WorkoutPerformanceChartsViewModel

    init(plan: WorkoutPlan) {
        _viewModel = StateObject(wrappedValue: WorkoutPerformanceChartsViewModel(plan: plan))
    }

    var body: some View {
        List {
            Section("Resumo") {
                Label(viewModel.totalDurationText, systemImage: "clock")
            }

            ChartSection(
                title: "Duracao por treino",
                items: viewModel.workoutChartItems
            )

            ChartSection(
                title: "Duracao por grupo muscular",
                items: viewModel.muscleGroupChartItems
            )
        }
        .navigationTitle("Desempenho")
    }
}

private struct ChartSection: View {
    let title: String
    let items: [WorkoutPerformanceChartsViewModel.ChartItem]

    private var maxValue: Int {
        items.map(\.value).max() ?? 0
    }

    var body: some View {
        Section(title) {
            if items.isEmpty {
                Text("Sem dados")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(items) { item in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(item.label)
                                .font(.subheadline)
                            Spacer()
                            Text("\(item.value) min")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        GeometryReader { geometry in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.blue)
                                .frame(
                                    width: barWidth(for: item.value, availableWidth: geometry.size.width),
                                    height: 8
                                )
                        }
                        .frame(height: 8)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }

    private func barWidth(for value: Int, availableWidth: CGFloat) -> CGFloat {
        guard maxValue > 0 else { return 0 }
        return availableWidth * CGFloat(value) / CGFloat(maxValue)
    }
}
