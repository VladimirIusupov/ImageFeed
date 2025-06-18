import UIKit
import ProgressHUD

protocol AuthViewControllerDelegate: NSObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    weak var delegate: AuthViewControllerDelegate?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(showWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    private func showAuthErrorAlert() {
            let alert = UIAlertController(
                title: "Что-то пошло не так(",
                message: "Не удалось войти в систему",
                preferredStyle: .alert
            )
            
            let action = UIAlertAction(title: "OK", style: .default) { _ in
                self.dismiss(animated: true)
            }
            alert.addAction(action)
            
            present(alert, animated: true)
        }
}


extension AuthViewController: WebViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        UIBlockingProgressHUD.show()
        fetchOAuthToken(code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            
            switch result {
            case .success(let token):
                oauth2TokenStorage.token = token
                self.delegate?.didAuthenticate(self)
            case .failure:
               
                self.showAuthErrorAlert()
            }
        }
        
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true, completion: nil)
    }
}
extension AuthViewController {
    private func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        oauth2Service.fetchOAuthToken(code) { result in
            completion(result)
        }
    }
}
