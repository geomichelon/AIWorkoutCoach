import SwiftUI

@main
struct AIWorkoutCoachDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: DemoDependencies.makeViewModel())
        }
    }
}
