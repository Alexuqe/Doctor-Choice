import Observation

@Observable
final class DIContainer {
    var cacheService: CacheServiceProtocol = CacheService()
    var networkService: NetworkServiceProtocol { NetworkService(cache: cacheService) }

    func makePediatriciansViewModel() -> PediatriciansViewModel {
        PediatriciansViewModel(networkService: networkService)
    }

    func makeMainViewModel() -> MainViewModel {
        MainViewModel()
    }

}
