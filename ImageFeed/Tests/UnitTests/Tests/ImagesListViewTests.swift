@testable import ImageFeed
import XCTest

final class ImagesListViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let imagesListViewController = ImagesListViewController()
        let imagesListViewPresenterSpy = ImagesListViewPresenterSpy()
        imagesListViewPresenterSpy.view = imagesListViewController
        imagesListViewController.presenter = imagesListViewPresenterSpy
        
        //when
        _ = imagesListViewController.view
        
        //then
        XCTAssertTrue(imagesListViewPresenterSpy.viewDidLoadCalled)
    }
    
    
    func testPresenterViewDidLoadCallsFetchPhotosNextPage() {
        //given
        let imagesListServiceSpy = ImagesListServiceSpy(emulateError: false)
        let imagesListViewPresenter = ImagesListViewPresenter(imagesListService: imagesListServiceSpy)
        
        //when
        imagesListViewPresenter.viewDidLoad()
        
        //then
        XCTAssertTrue(imagesListServiceSpy.fetchPhotosNextPageCalled)
    }
    func testPresenterCallsUpdateTableViewAnimated() {
        //given
        let imagesListServiceSpy = ImagesListServiceSpy(emulateError: false)
        let imagesListViewControllerSpy = ImagesListViewControllerSpy()
        let imagesListViewPresenter = ImagesListViewPresenter()
        imagesListViewPresenter.view = imagesListViewControllerSpy
        imagesListViewControllerSpy.presenter = imagesListViewPresenter
        imagesListViewPresenter.imagesListService = imagesListServiceSpy
        
        //when
        let photo = Photo(photoResult: PhotoResult(id: "", width: 10, height: 10, createdAt: "", description: nil, urls: UrlsResult(thumb: "", full: ""), likedByUser: false))
        let photos = [photo]
        imagesListViewPresenter.photos = photos
        imagesListViewPresenter.didUpdateTableViewAnimated()
        
        //then
        XCTAssertTrue(imagesListViewControllerSpy.didUpdateTableViewAnimatedCalled)
    }
    
    func testPresenterCallsFetchPhotosNextPage() {
        //given
        let imagesListServiceSpy = ImagesListServiceSpy(emulateError: false)
        let imagesListViewPresenter = ImagesListViewPresenter(imagesListService: imagesListServiceSpy)
        
        //when
        imagesListViewPresenter.loadImages()
        
        //then
        XCTAssertTrue(imagesListServiceSpy.fetchPhotosNextPageCalled)
    }
    
    func testSuccessChangeLike() throws {
        // Given
        let imagesListServiceSpy = ImagesListServiceSpy(emulateError: false)
        let imagesListViewPresenter = ImagesListViewPresenter(imagesListService: imagesListServiceSpy)
        
        // When
        let expectation = expectation(description: "Loading expectation")
        
        let photo = Photo(photoResult: PhotoResult(id: "", width: 0, height: 0, createdAt: "", description: nil, urls: UrlsResult(thumb: "", full: ""), likedByUser: false))
        let photos = [photo]
        imagesListViewPresenter.photos = photos
        
        imagesListViewPresenter.tapLike(for: photo) { result in
            // Then
            DispatchQueue.main.async {
                switch result {
                case .success(let isLiked):
                    imagesListViewPresenter.photos[0].isLiked = isLiked
                    expectation.fulfill()
                    XCTAssertEqual(imagesListViewPresenter.photos[0].isLiked, true)
                case .failure(_):
                    XCTFail("Unexpected failure")
                }
            }
        }
        waitForExpectations(timeout: 1)
    }
}
