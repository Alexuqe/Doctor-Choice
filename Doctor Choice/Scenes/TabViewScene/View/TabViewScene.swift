import SwiftUI

struct TabViewScene: View {
    @State private var viewModel: TabViewSceneViewModel
    @State private var pediatriciansViewModel: PediatriciansViewModel
    @State private var pediatriciansDetailViewModel: PediatriciansDetailViewModel

    init(container: DIContainer) {
        _viewModel = State(wrappedValue: container.makeMainViewModel())
        _pediatriciansViewModel = State(wrappedValue: container.makePediatriciansViewModel())
        _pediatriciansDetailViewModel = State(wrappedValue: container.makePediatriciansDetailViewModel())
    }

    var body: some View {
        NavigationStack(path: $viewModel.router.path) {
            TabBarView(
                currentScreen: $viewModel.tabItem,
                pediatriciansViewModel: pediatriciansViewModel,
                pediatricDetailVM: pediatriciansDetailViewModel
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
            .navigationDestination(for: AppScenes.self) { scene in
                switch scene {
                case .main(.pediatricianDetail(let user)):
                    PediatricianDetailView(
                        viewModel: pediatriciansDetailViewModel,
                        user: pediatriciansViewModel.binding(for: user)
                    )
                case .main(.priceDetail(let user)):
                    PriceView(user: user)
                }
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}


