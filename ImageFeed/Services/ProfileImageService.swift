import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private let storage = OAuth2TokenStorage()
    private let tokenStorage = OAuth2TokenStorage()
    private(set) var avatarURL: String?
    private var username: String?
    private enum AuthServiceError: Error {
        case invalidRequest
    }
    private init() {}
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if let existingTask = task {
            print("The request is already in progress")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        if self.username == username {
            completion(.failure(NetworkError.urlSessionError))
            print("ProfileImageService error: fetchProfileImageURL - repeatedRequest")
            return
        }
        
        self.username = username
        task?.cancel()
        
        guard let request = makeRequest(username: username) else {
            completion(.failure(NetworkError.urlSessionError))
            print("ProfileImageService Error: fetchProfileImageURL - invalidImageRequest")
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result:(Result<UserResult, Error>)) in
            guard let self = self else { return }
            switch result{
            case .success(let userResult):
                let avatarURL = userResult.profileImage.large
                self.avatarURL = avatarURL
                completion(.success(avatarURL))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": avatarURL])
                
            case .failure(let error):
                completion(.failure(error))
                print("Error: fetchProfileImageURL - NetworkError - \(error)")
            }
            self.task = nil
            self.username = nil
        }
        
        self.task = task
        task.resume()
    }
    
    private func makeRequest(username: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
            print("cannot construct url for fetching image")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("Bearer \(tokenStorage.token ?? "")", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func deleteAvatar() {avatarURL = nil}
}




