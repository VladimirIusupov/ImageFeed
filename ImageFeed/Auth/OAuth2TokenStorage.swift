import UIKit
final class OAuth2TokenStorage {
    // MARK: - Internal properties
    var token: String? {
        get { UserDefaults.standard.string(forKey: Identifiers.tokenKey) }
        set { UserDefaults.standard.set(newValue, forKey: Identifiers.tokenKey) }
    }
}
