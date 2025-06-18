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

enum ProfileServiceError: Error {
    case invalidRequest
    case codeError
    case tokenError
    case decodeError
}

enum RequestError: Error {
    case invalidRequest
    case invalidBaseURL
    case invalidURLComponents
    case badRequest
}

enum ParsingJSONServiceError: Error {
    case decodeError
    case invalidJson
    case incorrectObject
}
