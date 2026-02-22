import Foundation

enum NetworkError: Error {
    case invalidParams
    case invalidURL
    case invalidResponse(String?)
    case requestFailed(Error)
    case decodingFailed

    var errorDescription: String? {
        switch self {
            case .invalidParams:
                return "Invalid params"
            case .invalidURL:
                return "Invalid URL"
            case .invalidResponse(let string):
                return string
            case .requestFailed(let error):
                return "Request Failed: \(error.localizedDescription)"
            case .decodingFailed:
                return "Failed to decode response"
        }
    }
}
