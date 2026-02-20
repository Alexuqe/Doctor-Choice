import SwiftUI

@main
struct Doctor_ChoiceApp: App {
    @State var diContainer = DIContainer()

    var body: some Scene {
        WindowGroup {
            MainScene(diContainer: diContainer).environment(diContainer)
        }
    }
}


