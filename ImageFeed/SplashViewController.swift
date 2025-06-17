import UIKit

final class SplashViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .vector)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let showGallerySegueId = "showGallery"
    private let showAuthSegueId = "showAuthorization"
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let storage = OAuth2TokenStorage()
    let profileImageService = ProfileImageService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = oauth2TokenStorage.token {
            self.fetchProfile(token: token)
        } else {
            self.switchToAuthViewController()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func showNextScreen() {
        if let token = oauth2TokenStorage.token, !token.isEmpty {
            print("gallery showed")
            performSegue(withIdentifier: showGallerySegueId, sender: self)
        } else {
            performSegue(withIdentifier: showAuthSegueId, sender: self)
        }
    }
    private func configure() {
        view.backgroundColor = UIColor(resource: .ypBlack)
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 75),
            imageView.widthAnchor.constraint(equalToConstant: 77.68)
        ])
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthSegueId {
            let navigationController = segue.destination as? UINavigationController
            guard let authViewController = navigationController?.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthSegueId)")
                return
            }
            authViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        guard let token = oauth2TokenStorage.token else {
            print ("Токен не работает")
            return
        }
        self.fetchProfile(token: token)
        
    }
    private func switchToAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
            assertionFailure("AuthViewController did not load on storyboard")
            return
        }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
    
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else {
                print("fetchProfile dont work")
                return }
            switch result {
            case .success(let profile):
                self.profileImageService.fetchProfileImageURL(username: profile.username) { result in }
                
                switch result {
                case .success(let avatarURL):
                    print(avatarURL)
                case .failure(let failure):
                    print(failure.localizedDescription)
                    break
                }
                
                self.switchToTabBarController()
            case .failure(let failure):
                print(failure.localizedDescription)
                break
            }
        }
    }
}



