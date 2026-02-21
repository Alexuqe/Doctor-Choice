import Observation

@Observable
final class DIContainer {
    let cacheService: CacheServiceProtocol
    let router: Routeble
    let networkService: NetworkServiceProtocol

    init() {
        self.cacheService = CacheService()
        self.router = Router()
        self.networkService = NetworkService(cache: cacheService)
    }

    func makePediatriciansViewModel() -> PediatriciansViewModel {
        PediatriciansViewModel(networkService: networkService)
    }

    func makeMainViewModel() -> TabViewSceneViewModel {
        TabViewSceneViewModel()
    }

}
