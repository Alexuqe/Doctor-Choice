import SwiftUI

struct TabBarView: View {
    @Binding var currentScreen: TabItemModel
    var pediatriciansViewModel: PediatriciansViewModel

    init(
        currentScreen: Binding<TabItemModel>,
        pediatriciansViewModel: PediatriciansViewModel
    ) {
        self._currentScreen = currentScreen
        self.pediatriciansViewModel = pediatriciansViewModel

        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        TabView(selection: $currentScreen) {
            ContentView(viewModel: pediatriciansViewModel).tag(TabItemModel.home)
            Text(currentScreen.title).tag(TabItemModel.clipboard)
            Text(currentScreen.title).tag(TabItemModel.message)
            Text(currentScreen.title).tag(TabItemModel.person)
        }
    }
}


