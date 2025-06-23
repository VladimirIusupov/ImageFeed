import Foundation

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    func tapLike(for photo: Photo, completion: @escaping (Result<Bool, any Error>) -> Void) {}
    var viewDidLoadCalled: Bool = false
    var imagesListService: ImagesListServiceProtocol?
    var view: ImagesListViewControllerProtocol?
    var photos: [ImageFeed.Photo] = []
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateTableViewAnimated() {}
    
    func loadImages() {}
}
