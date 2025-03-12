import SwiftUI

final class AuthViewController: UIViewController {
    
    // MARK: - Private properties
    private let oauth2Service = OAuth2Service.shared
    private let tokenStorage = OAuth2TokenStorage()
    // MARK: - Internal properties
    weak var delegate: AuthViewControllerDelegate?
    let idSegue = Identifiers.authWebScreenIdentifier
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == idSegue {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(idSegue)")
                return
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private functions
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back_img")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back_img")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black")
    }
}

// MARK: - WebViewViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            switch result {
            case .failure(let error):
                switch error {
                case NetworkError.urlSessionError:
                    print("Network error")
                case NetworkError.httpStatusCode(let status):
                    print("Unsplash service error: \(status)")
                case NetworkError.urlRequestError(let requestError):
                    print("Nerwork error: \(requestError)")
                default:
                    print("Unknown error")
                }
            case .success(let data):
                guard let self = self else { return }
                self.delegate?.didAuthenticate(self)
                self.tokenStorage.token = data
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        // self.navigationController?.popViewController(animated: true)
        vc.dismiss(animated: true)
    }
}
