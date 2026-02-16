import Foundation

protocol CacheServiceProtocol: Actor {
    func save(data: Data)
    func load() -> Data?
    func isValid() -> Bool
}

actor CacheService: CacheServiceProtocol {

    private let cacheURL: URL
    private let timestampURL: URL
    private let ttl: TimeInterval

    init(ttl: TimeInterval = 60 * 60 * 24) {
        self.ttl = ttl

        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        self.cacheURL = dir.appendingPathComponent("users_cache.json")
        self.timestampURL = dir.appendingPathComponent("users_cache_timestamp")
    }


    func save(data: Data) {
        do {
            try data.write(to: cacheURL, options: .atomic)
            let timeInterval = Date().timeIntervalSince1970
            let tsData = "\(timeInterval)".data(using: .utf8)

            try tsData?.write(to: timestampURL, options: .atomic)
        } catch {
            print("Cache save error:", error)
        }
    }

    func load() -> Data? {
        try? Data(contentsOf: cacheURL)
    }

    func isValid() -> Bool {
        guard
            let timeStampData = try? Data(contentsOf: timestampURL),
            let timeStampString = String(data: timeStampData, encoding: .utf8),
            let timeInterval = TimeInterval(timeStampString)
        else {
            return false
        }

        let age = Date().timeIntervalSince1970 - timeInterval
        return age < ttl


    }
}
