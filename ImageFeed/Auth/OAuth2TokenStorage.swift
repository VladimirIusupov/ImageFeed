import SwiftUI

final class OAuth2TokenStorage {
    
    // MARK: - Private properties
    private let tokenKey = "BearerToken"
    // MARK: - Internal properties
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
}
