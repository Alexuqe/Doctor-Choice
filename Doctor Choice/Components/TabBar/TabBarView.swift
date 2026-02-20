import SwiftUI

struct TabBarView: View {
    @Environment(DIContainer.self) var diContainer
    @Binding var currentScreen: TabItemModel

    init(currentScreen: Binding<TabItemModel>) {
        self._currentScreen = currentScreen

        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        TabView(selection: $currentScreen) {
            ContentView(diContainer: diContainer)
            .tag(TabItemModel.home)
            .environment(diContainer)

            Text(currentScreen.title).tag(TabItemModel.clipboard)
            Text(currentScreen.title).tag(TabItemModel.message)
            Text(currentScreen.title).tag(TabItemModel.person)
        }
    }
}


