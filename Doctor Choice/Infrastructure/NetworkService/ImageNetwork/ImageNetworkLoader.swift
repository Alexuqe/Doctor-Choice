import Foundation
import UIKit

protocol ImageNetworkLoadeble {
    func loadImage(from url: URL) async throws -> UIImage
}

enum ImageLoadingError: Error {
    case badResponse
    case decodingFailed
    case failed
}

final class ImageNetworkLoader: ImageNetworkLoadeble {
    private var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.waitsForConnectivity = true

        return URLSession(configuration: config)
    }()

    func loadImage(from url: URL) async throws -> UIImage {
        let (data, response) = try await session.data(from: url)

        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw ImageLoadingError.badResponse
        }

        guard let image = UIImage(data: data) else {
            throw ImageLoadingError.decodingFailed
        }

        return image
    }
}
