import SwiftUI

@main
struct Doctor_ChoiceApp: App {
    @State var container = DIContainer()

    var body: some Scene {
        WindowGroup {
            TabViewScene(container: container)
            .environment(\.diContainer, container)
        }
    }
}



