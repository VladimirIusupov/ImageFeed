import SwiftUI
import WebKit

final class WebViewViewController: UIViewController, WKNavigationDelegate {
    let screenIdentifier = Identifiers.authWebScreenIdentifier
    let unsplashURLAuth = Identifiers.unsplashAuthorizeURLStringIdentifier
    
    
    @IBOutlet private weak var webView: WKWebView!
    
    override func viewDidLoad() {
        webView.navigationDelegate = self
        loadAuthView()
        backButttonSetup()
    }
    
    private func backButttonSetup() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black")
    }
    
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: unsplashURLAuth) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)]
        guard let url = urlComponents.url else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension WKNavigationDelegate {
    private func WebView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let code = code(from: navigationAction) {
                // TODO: Make code processor
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        }
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItems = items.first(where: { $0.name == "code" })
        {
            return codeItems.value
        } else {
            return nil
        }
            
    }
}
