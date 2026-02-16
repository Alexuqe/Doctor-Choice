import Foundation

protocol NetworkConfigurable {
    var timeoutInterval: TimeInterval { get }
    var maxRetryAttempts: Int { get }
    var retryBaseDelay: TimeInterval { get }
    var autoRetryEnabled: Bool { get }
    var cachingEnabled: Bool { get }
    var defaultCacheTTL: TimeInterval { get }
    var maxCacheSize: Int { get }
    var defaultHeaders: [String: String] { get }
    var jsonDecoder: JSONDecoder { get }
}

struct DefaultNetworkConfiguration: NetworkConfigurable, Sendable {
    var timeoutInterval: TimeInterval
    var maxRetryAttempts: Int
    var retryBaseDelay: TimeInterval
    var autoRetryEnabled: Bool
    var cachingEnabled: Bool
    var defaultCacheTTL: TimeInterval
    var maxCacheSize: Int
    var defaultHeaders: [String: String]
    var jsonDecoder: JSONDecoder

    init(
        timeoutInterval: TimeInterval = 30.0,
        maxRetryAttempts: Int = 3,
        retryBaseDelay: TimeInterval = 1.0,
        autoRetryEnabled: Bool = true,
        cachingEnabled: Bool = true,
        defaultCacheTTL: TimeInterval = 300,
        maxCacheSize: Int = 50 * 1024 * 1024,
        defaultHeaders: [String: String] = [:],
        jsonDecoder: JSONDecoder = .default
    ) {
        self.timeoutInterval = timeoutInterval
        self.maxRetryAttempts = maxRetryAttempts
        self.retryBaseDelay = retryBaseDelay
        self.autoRetryEnabled = autoRetryEnabled
        self.cachingEnabled = cachingEnabled
        self.defaultCacheTTL = defaultCacheTTL
        self.maxCacheSize = maxCacheSize
        self.defaultHeaders = defaultHeaders
        self.jsonDecoder = jsonDecoder
    }
}

struct ProductionNetworkConfiguration: NetworkConfigurable, Sendable {
    var timeoutInterval: TimeInterval
    var maxRetryAttempts: Int
    var retryBaseDelay: TimeInterval
    var autoRetryEnabled: Bool
    var cachingEnabled: Bool
    var defaultCacheTTL: TimeInterval
    var maxCacheSize: Int
    var defaultHeaders: [String: String]
    var jsonDecoder: JSONDecoder

    init(
        timeoutInterval: TimeInterval = 5.0,
        maxRetryAttempts: Int = 5,
        retryBaseDelay: TimeInterval = 1.0,
        autoRetryEnabled: Bool = true,
        cachingEnabled: Bool = false,
        defaultCacheTTL: TimeInterval = 60 * 60 * 24,
        maxCacheSize: Int = 50 * 1024 * 1024,
        defaultHeaders: [String: String] = [:],
        jsonDecoder: JSONDecoder = .default
    ) {
        self.timeoutInterval = timeoutInterval
        self.maxRetryAttempts = maxRetryAttempts
        self.retryBaseDelay = retryBaseDelay
        self.autoRetryEnabled = autoRetryEnabled
        self.cachingEnabled = cachingEnabled
        self.defaultCacheTTL = defaultCacheTTL
        self.maxCacheSize = maxCacheSize
        self.defaultHeaders = defaultHeaders
        self.jsonDecoder = jsonDecoder
    }
}

extension NetworkConfigurable where Self == DefaultNetworkConfiguration {
    static var `default`: NetworkConfigurable { DefaultNetworkConfiguration() }
}

extension NetworkConfigurable where Self == ProductionNetworkConfiguration {
    static var production: NetworkConfigurable { ProductionNetworkConfiguration() }
}
