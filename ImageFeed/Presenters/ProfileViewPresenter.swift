import Foundation
import UIKit

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func didLogout()
    func didUpdateAvatar() -> URL?
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    
    func viewDidLoad() {
        profileImageServiceObserver()
    }
    
    func didLogout() {
        profileLogoutService.logout()
    }
    
    private func profileImageServiceObserver() {
        NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            view?.updateAvatar()
        }
    }
    
    func didUpdateAvatar() -> URL? {
            guard let profileImageURL = profileImageService.avatarURL,
                  let url = URL(string: profileImageURL)
            else {
                print("[ProfileViewPresenter: didUpdateAvatar]: URL was not found")
                return nil }
            return url
        }
}
