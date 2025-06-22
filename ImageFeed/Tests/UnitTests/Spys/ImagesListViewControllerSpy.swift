import Foundation

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var didUpdateTableViewAnimatedCalled: Bool = false
    var presenter: ImagesListViewPresenterProtocol?
    var oldCount: Int = 0
    var newCount: Int = 0
    
    func updateTableViewAnimated() {
        didUpdateTableViewAnimatedCalled = true
    }
}
