@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let profileViewController = ProfileViewController()
        let profileViewPresenterSpy = ProfileViewPresenterSpy()
        profileViewController.presenter = profileViewPresenterSpy
        profileViewPresenterSpy.view = profileViewController
        
        //when
        _ = profileViewController.view
        
        //then
        XCTAssertTrue(profileViewPresenterSpy.viewDidLoadCalled)
    }

    func testViewControllerCallsDidUpdateAvatar() {
        //given
        let profileViewController = ProfileViewController()
        let profileViewPresenterSpy = ProfileViewPresenterSpy()
        profileViewController.presenter = profileViewPresenterSpy
        profileViewPresenterSpy.view = profileViewController
        
        //when
        profileViewController.updateAvatar()
        
        //then
        XCTAssertTrue(profileViewPresenterSpy.didUpdateAvatarCalled)
    }
}
