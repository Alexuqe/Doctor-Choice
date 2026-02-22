import Foundation
import UIKit

protocol ImageLoadingServiceble {
    func image(for url: URL) async -> UIImage?
}

final class ImageLoadingService: ImageLoadingServiceble {
    private let cache: ImageCacheble
    private let networkLoader: ImageNetworkLoadeble

    init(cache: ImageCacheble, networkLoader: ImageNetworkLoadeble) {
        self.cache = cache
        self.networkLoader = networkLoader
    }

    func image(for url: URL) async -> UIImage? {
        if let cached = await cache.image(for: url) {
            return cached
        }

        do {
            let image = try await networkLoader.loadImage(from: url)
            cache.setImage(image, for: url)
            return image
        } catch {
            return nil
        }
    }
    

}
