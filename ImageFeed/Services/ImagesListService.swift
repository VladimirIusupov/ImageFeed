import Foundation

struct Photo {
    let id:String
    let size: CGSize
    let createdAT: Date?
    let welcomDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

final class ImageListServise {
    private (set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    
    //
    
    func fetchPhotosNextPage() {
        //
    }
}
