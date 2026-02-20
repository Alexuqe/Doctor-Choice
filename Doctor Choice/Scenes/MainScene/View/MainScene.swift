import SwiftUI

struct MainScene: View {
    @Environment(DIContainer.self) var container
    @State private var viewModel: MainViewModel

    init(diContainer: DIContainer) {
        _viewModel = State(wrappedValue: diContainer.makeMainViewModel())
    }

    var body: some View {
        TabBarView(currentScreen: $viewModel.tabItem)
        .safeAreaInset(
            edge: .bottom,
            content: {
                TabBar(
                    page: $viewModel.tabItem,
                    bars: viewModel.items
                )
            }
        )
        .environment(container)
    }
}


