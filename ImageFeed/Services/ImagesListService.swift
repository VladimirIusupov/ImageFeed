import Foundation
final class ImagesListService {
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let shared = ImagesListService()
    private init() {}
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        
        if !isLike {
            unlikePhoto(photoId: photoId, completion: completion)
        } else {
            likePhoto(photoId: photoId, completion: completion)
        }
    }
    func likePhoto(photoId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "https://api.unsplash.com/photos/\(photoId)/like") else {
            return
        }
        
        guard let token = OAuth2TokenStorage().token else {
            completion(.failure(NSError(domain: "ImagesListService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("[ProfileService]: Ошибка - \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            self.updatePhoto(photoId: photoId)
            completion(.success(()))
        }
        task.resume()
    }
    func updatePhoto(photoId: String) -> Void {
        if let index = photos.firstIndex(where: { $0.id == photoId }) {
            var photo = photos[index]
            photo.isLiked = !photo.isLiked
            photos[index] = photo
        }
    }
    func unlikePhoto(photoId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "https://api.unsplash.com/photos/\(photoId)/like") else {
            return
        }
        
        guard let token = OAuth2TokenStorage().token else {
            completion(.failure(NSError(domain: "ImagesListService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("[ProfileService]: Ошибка - \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            self.updatePhoto(photoId: photoId)
            completion(.success(()))
        }
        task.resume()
    }
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard task == nil else {
            print("extra task in imageListService")
            return
        }
        task?.cancel()
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard let request = makeImageListRequest(nextPage: nextPage) else {
            print("invalid request in ImagesListService")
            return
        }
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let photosResult):
                self?.photos.append(contentsOf: photosResult.map(Photo.init))
                NotificationCenter.default.post(name: Self.didChangeNotification, object: self)
                self?.lastLoadedPage = nextPage
            case .failure(let error):
                print("ImagesListService: network or request error: \(error.localizedDescription)")
            }
            self?.task = nil
        }
        self.task = task
        task.resume()
    }

    private func makeImageListRequest(nextPage: Int) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/photos" + "?page=\(nextPage)"),
              let token = OAuth2TokenStorage().token
        else {
            assertionFailure("ImagesListService: Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        lastLoadedPage = nextPage
        return request
    }
    func deletImagesList() {photos = []}
}
