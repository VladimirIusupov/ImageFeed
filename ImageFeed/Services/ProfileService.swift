import Foundation

struct ProfileResult: Decodable {
    
    var username: String
    var firstName: String
    var lastName: String?
    var bio: String?
    
}

struct Profile {
    
    let username: String
    let name: String
    let loginName: String?
    let bio: String?
    
}

final class ProfileService {
    private var storage = OAuth2TokenStorage()
    static let shared = ProfileService()
    private init() {}
    
    private let decoder = JSONDecoder()
    private(set) var profile: Profile?
    
    private enum RequestError: Error {
        case invalidRequest
        case invalidBaseURL
        case invalidURLComponents
        case badRequest
    }
    
    private enum ParsingJSONServiceError: Error { 
        case decodeError
        case invalidJson
        case incorrectObject
    }
    
    
    
    private func makeProfileRequest(token: String) -> URLRequest? {
        guard let baseUrl = URL(string: Constants.defaultBaseURL?.absoluteString ?? "") else {
            preconditionFailure("Invalid base URL \(ErrorsList.RequestError.invalidBaseURL)")
        }
        guard let url = URL(string:
                                "/me",
                            relativeTo: baseUrl
        ) else {
            print("нельзя создать makeProfileRequest")
            preconditionFailure("Invalid URL Components \(ErrorsList.RequestError.invalidURLComponents)")
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        return request
    }
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request = makeProfileRequest(token: token) else {
            print("нельзя создать makeProfileRequest")
            return completion(.failure(RequestError.invalidRequest))
            
        }
        
        let task = URLSession.shared.objectTask(for: request) { (result: Result<ProfileResult, Error>) in
            
            switch result {
            case .success(let response):
                self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let profile = Profile(username: response.username,
                                      name: response.firstName + " " + (response.lastName ?? ""),
                                      loginName: "@" + response.username,
                                      bio: response.bio ?? "")
                self.profile = profile
                completion(.success(profile))
            
        case .failure(let error):
            print("Network error: \(error)")
            completion(.failure(error))
        }
    }
    task.resume()
}

}

