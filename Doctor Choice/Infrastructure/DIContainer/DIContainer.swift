import Observation

@Observable
final class DIContainer {
    let cacheService: CacheServiceProtocol
    let router: Routeble
    let networkService: NetworkServiceProtocol
    let imageCache: ImageCacheble
    let imageNetworkLoader: ImageNetworkLoadeble
    let imageLoadService: ImageLoadingServiceble

    init() {
        self.cacheService = CacheService()
        self.router = Router()
        self.networkService = NetworkService(cache: cacheService)
        self.imageCache = ImageCacheService()
        self.imageNetworkLoader = ImageNetworkLoader()
        self.imageLoadService = ImageLoadingService(cache: imageCache, networkLoader: imageNetworkLoader)
    }

    func makePediatriciansViewModel() -> PediatriciansViewModel {
        PediatriciansViewModel(
            networkService: networkService,
            router: router
        )
    }

    func makeMainViewModel() -> TabViewSceneViewModel {
        TabViewSceneViewModel(router: router)
    }

    func makePediatriciansDetailViewModel() -> PediatriciansDetailViewModel {
        PediatriciansDetailViewModel(imageLoadService: imageLoadService, router: router)
    }
}
