import Observation

@Observable
final class TabViewSceneViewModel {
    var router: Routeble

    var tabItem: TabItemModel =  .home
    var items: [TabItemModel] = TabItemModel.allCases

    init(router: Routeble) {
        self.router = router
    }
}
