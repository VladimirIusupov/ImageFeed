import UIKit

enum OAuth2Error: Error {
    case noData
    case invalidResponse
}

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case tokenError
}

enum FetchOAuthError: Error {
    case invalidURL
    case noData
    case invalidStatusCode
    case invalidResponse
}
