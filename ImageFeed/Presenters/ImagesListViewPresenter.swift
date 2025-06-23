import Foundation

public protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var imagesListService: ImagesListServiceProtocol? { get }
    var photos: [Photo] { get set }
    func viewDidLoad()
    func didUpdateTableViewAnimated()
    func loadImages()
    func tapLike(for photo: Photo, completion: @escaping (Result<Bool, Error>) -> Void)
    
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    var imagesListService: ImagesListServiceProtocol?
    init(imagesListService: ImagesListServiceProtocol? = ImagesListService.shared) {
        self.imagesListService = imagesListService
    }

    func viewDidLoad() {
        imageListServiceObserver()
        imagesListService?.fetchPhotosNextPage()
    }
    
    func didUpdateTableViewAnimated() {
        let oldCount = photos.count
        guard let newCount = imagesListService?.photos.count else { return }
        guard let photos = imagesListService?.photos else { return }
        self.photos = photos
        if newCount != oldCount {
            view?.oldCount = oldCount
            view?.newCount = newCount
            view?.updateTableViewAnimated()
        }
    }
    
    func loadImages() {
        imagesListService?.fetchPhotosNextPage()
    }
    
    func tapLike(for photo: Photo, completion: @escaping (Result<Bool, Error>) -> Void) {
        let newLike = !photo.isLiked
        imagesListService?.changeLike(photoId: photo.id, isLike: newLike) { result in
            switch result {
            case .success:
                completion(.success(newLike))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func imageListServiceObserver() {
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            didUpdateTableViewAnimated()
        }
    }
}
