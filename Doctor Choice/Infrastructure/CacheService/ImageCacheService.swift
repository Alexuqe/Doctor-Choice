import Foundation
import UIKit

protocol ImageCacheble {
    func image(for url: URL) async -> UIImage?
    func setImage(_ image: UIImage, for url: URL)
}

final class ImageCacheService: ImageCacheble {
    private let cache = NSCache<NSURL, UIImage>()

    init() {
        configureCacheLimits()
    }

    func image(for url: URL) async -> UIImage? {
        cache.object(forKey: url as NSURL)
    }

    func setImage(_ image: UIImage, for url: URL) {
        let cost = image.jpegData(compressionQuality: 1)?.count ?? 0
        cache.setObject(image, forKey: url as NSURL, cost: cost)
    }

    private func configureCacheLimits() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024
    }
}
