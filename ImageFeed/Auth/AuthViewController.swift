import UIKit

final class AuthViewController: UIViewController {
    
    private let identifier = Identifiers.authWebScreenIdentifier
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    weak var delegate: AuthViewControllerDelegate?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(identifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self else { return }
            self.navigationController?.popViewController(animated: true)
            switch result {
            case .success(let bearerToken):
                self.oauth2TokenStorage.token = bearerToken
                delegate?.didAuthenticate(self)
            case .failure(let error):
                print("failure with error - \(error)")
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true, completion: nil)
    }
}
