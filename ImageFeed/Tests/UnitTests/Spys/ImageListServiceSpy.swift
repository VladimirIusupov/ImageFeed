import UIKit

final class ImagesListServiceSpy: ImagesListServiceProtocol {
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, any Error>) -> Void) {
        if emulateError {
            completion(.failure(TestError.test))
        } else {
            completion(.success(()))
        }
    }
    
    enum TestError: Error {
        case test
    }
    
    let emulateError: Bool
    init(emulateError: Bool) {
        self.emulateError = emulateError
    }
    
    var fetchPhotosNextPageCalled: Bool = false
    var photos: [ImageFeed.Photo] = [
        ImageFeed.Photo(photoResult: PhotoResult(id: "", width: 10, height: 10, createdAt: "", description: nil, urls: UrlsResult(thumb: "", full: ""), likedByUser: false)),
        ImageFeed.Photo(photoResult: PhotoResult(id: "", width: 10, height: 10, createdAt: "", description: nil, urls: UrlsResult(thumb: "", full: ""), likedByUser: false))]
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }
}
