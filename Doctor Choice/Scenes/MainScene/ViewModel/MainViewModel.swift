import Observation

@Observable
final class MainViewModel {
    var tabItem: TabItemModel =  .home
    var items: [TabItemModel] = TabItemModel.allCases
}
