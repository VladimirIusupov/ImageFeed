import Foundation

final class OAuth2TokenStorage {
    var token: String? {
        get {
            guard let token = UserDefaults.standard.string(forKey: Identifiers.tokenKey) else {
                print("Bearer token isn't string")
                return UserDefaults.standard.string(forKey: Identifiers.tokenKey)
            }
            return token
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Identifiers.tokenKey)
        }
    }
}
