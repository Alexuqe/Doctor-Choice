import SwiftUI

struct TabViewScene: View {
    @Environment(\.diContainer) private var di
    @State private var viewModel: TabViewSceneViewModel
    @State private var pediatriciansViewModel: PediatriciansViewModel

    init(container: DIContainer) {
        _viewModel = State(wrappedValue: container.makeMainViewModel())
        _pediatriciansViewModel = State(wrappedValue: container.makePediatriciansViewModel())
    }

    var body: some View {
        NavigationStack(path: $viewModel.router.path) {
            TabBarView(
                currentScreen: $viewModel.tabItem,
                pediatriciansViewModel: pediatriciansViewModel
            )
            .safeAreaInset(
                edge: .bottom,
                content: {
                    TabBar(
                        page: $viewModel.tabItem,
                        bars: viewModel.items
                    )
                }
            )
        }
        .ignoresSafeArea(.keyboard)
        .navigationDestination(for: AppScenes.self) { scene in
            switch scene {
                case .main(.pediatricianDetail(let user)):
                    PediatricanDetailView(user: pediatriciansViewModel.binding(for: user))
            }
        }
    }
}


