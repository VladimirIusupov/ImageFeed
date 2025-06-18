
import Foundation

final class ErrorsList {
    enum RequestError: Error {
        case invalidRequest
        case invalidBaseURL
        case invalidURLComponents
        case badRequest
    }
}

