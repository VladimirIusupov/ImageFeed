import UIKit

final class OAuth2Service {
    var authToken: String? {
        get {
            OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    static let shared = OAuth2Service()
    private var task: URLSessionTask?
    private var lastCode: String?
    private let decoder = JSONDecoder()
    private let urlSession = URLSession.shared
    private enum AuthServiceError: Error {
        case invalidRequest
        case codeError
        case tokenError
    }
    
    private enum OAuth2ServiceConstants {
        static let unsplashGetTokenURLString = "https://unsplash.com/oauth/token"
    }
    
    private init() {
    }
    
    func fetchOAuthToken(_ code: String, handler: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                handler(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                handler(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        lastCode = code
        guard
            let request = makeOAuthTokenRequest(code: code)
        else {
            print("Request didn't founded or din't created")
            handler(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { (result: Result<OAuthTokenResponseBody, Error>) in
            
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let token = data.accessToken
                else {
                    handler(.failure(AuthServiceError.tokenError))
                    print("Token not found")
                    return
                }
                handler(.success(token))
            case .failure(let error):
                print("Error: \(error)")
                handler(.failure(error))
            }
        }
        task.resume()
    }
}

private func makeOAuthTokenRequest(code: String) -> URLRequest? {
    let baseURL = URL(string: "https://unsplash.com")
    guard
        let url = URL(string: "/oauth/token"
                      + "?client_id=\(Constants.accessKey)"
                      + "&&client_secret=\(Constants.secretKey)"
                      + "&&redirect_uri=\(Constants.redirectURI)"
                      + "&&code=\(code)"
                      + "&&grant_type=authorization_code",
                      relativeTo: baseURL)
    else {
        print("OAuth2Service url - error")
        return nil
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    return request
}
