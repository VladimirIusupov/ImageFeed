import UIKit

enum OAuth2Error: Error {
    case noData
    case invalidResponse
}

enum FetchOAuthError: Error {
    case invalidURL
    case noData
    case invalidStatusCode
    case invalidResponse
}
