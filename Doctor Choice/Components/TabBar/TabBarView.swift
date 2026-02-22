import SwiftUI

struct TabBarView: View {
    @Binding var currentScreen: TabItemModel
    var pediatriciansViewModel: PediatriciansViewModel
    var pediatricDetailVM: PediatriciansDetailViewModel

    init(
        currentScreen: Binding<TabItemModel>,
        pediatriciansViewModel: PediatriciansViewModel,
        pediatricDetailVM: PediatriciansDetailViewModel
    ) {
        self._currentScreen = currentScreen
        self.pediatriciansViewModel = pediatriciansViewModel
        self.pediatricDetailVM = pediatricDetailVM

        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        TabView(selection: $currentScreen) {
            ContentView(
                viewModel: pediatriciansViewModel,
                detailViewModel: pediatricDetailVM
            ).tag(TabItemModel.home)

            Text(currentScreen.title).tag(TabItemModel.clipboard)
            Text(currentScreen.title).tag(TabItemModel.message)
            Text(currentScreen.title).tag(TabItemModel.person)
        }
    }
}


