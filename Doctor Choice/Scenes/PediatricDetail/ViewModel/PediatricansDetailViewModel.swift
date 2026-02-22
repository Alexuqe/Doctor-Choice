import Observation
import UIKit

@Observable
final class PediatriciansDetailViewModel {
    var didTimeOut: Bool = false
    var loadedAvatar: [UUID: UIImage] = [:]
    var price = 0

    @ObservationIgnored private let timeOut: TimeInterval = 3
    @ObservationIgnored private let imageLoadService: ImageLoadingServiceble
    @ObservationIgnored private let router: Routeble

    init(imageLoadService: ImageLoadingServiceble, router: Routeble) {
        self.imageLoadService = imageLoadService
        self.router = router
    }

    func loadAvatar(for user: User) async {
        guard
            let urlString = user.avatar,
            !urlString.isEmpty,
            let url = URL(string: urlString)
        else { return }

        if let image = await imageLoadService.image(for: url) {
            loadedAvatar[user.id] = image
        }
    }

    func avatarImage(for user: User) -> UIImage? {
        loadedAvatar[user.id]
    }

    func startTimeOut() async {
        try? await Task.sleep(nanoseconds: UInt64(timeOut * 1_000_000_000))

        if !Task.isCancelled {
            didTimeOut = true
        }
    }

    func minPrice(doctor: User) {
        var result = Int.max

        result = min(doctor.textChatPrice, doctor.videoChatPrice)

        if let hospital = doctor.hospitalPrice, let home = doctor.homePrice {
            let minGeoPrice = min(hospital, home)
            result = min(result, minGeoPrice)
        }

        price = result
    }

    func openPriceScreen(for user: User) {
        router.push(to: .main(.priceDetail(user)))
    }
}
