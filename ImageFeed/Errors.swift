import SwiftUI

enum OAuth2Error: Error {
    case noData
    case invalidResponse
}

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

enum FetchOAuthError: Error {
    case invalidURL
    case noData
    case invalidStatusCode
    case invalidResponse
}
