import SwiftUI

@main
struct JobTrackerApp: App {
    @StateObject private var store = JobStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .tint(.indigo)
        }
    }
}
