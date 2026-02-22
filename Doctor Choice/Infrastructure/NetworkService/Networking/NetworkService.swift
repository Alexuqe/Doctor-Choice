import Foundation

protocol NetworkServiceProtocol {
    func fetchUsers<T: Decodable>(url: Endpoint) async throws -> T
}

enum Endpoint: String {
    case `default` = "https://raw.githubusercontent.com/salfa-ru/test_iOS_akatosphere/main/test.json"
}

final class NetworkService: NetworkServiceProtocol {

    private let cache: CacheServiceProtocol
    private let jsonDecoder = JSONDecoderDTO()

    private var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.waitsForConnectivity = true
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        return URLSession(configuration: config)
    }()

    init(cache: CacheServiceProtocol) {
        self.cache = cache
    }

    func fetchUsers<T>(url: Endpoint) async throws -> T where T : Decodable {
        let request = try makeRequest(with: url.rawValue, httpMethod: .GET)

        if await cache.isValid() {
            if let cached = await cache.load() {
                return try jsonDecoder.decode(type: T.self, from: cached)
            }
        }

        let (data, response) = try await session.data(for: request)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse("Response decoding failed")
        }

        do {
            let result = try jsonDecoder.decode(type: T.self, from: data)
            await cache.save(data: data)
            return result
        } catch {
            if let cached = await cache.load() {
                return try jsonDecoder.decode(type: T.self, from: cached)
            }

            throw error
        }
    }

    private func makeRequest(with endpoint: String, httpMethod: HTTPMethod) throws -> URLRequest {
        guard
            let components = URLComponents(string: endpoint),
            let requestURL = components.url
        else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = httpMethod.rawValue

        return request
    }


}

struct JSONDecoderDTO {
    func decode<T>(type: T.Type, from data: Data) throws -> T where T: Decodable {
        try JSONDecoder().decode(type.self, from: data)
    }
}
