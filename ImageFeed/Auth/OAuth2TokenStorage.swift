import Foundation
import SwiftKeychainWrapper
final class OAuth2TokenStorage {
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: "AuthToken")
        }
        set {
            guard let token = newValue else {
                print("Token not found")
                return
            }
            let isSuccess = KeychainWrapper.standard.set(token,forKey: "AuthToken")
            guard isSuccess else {
                print ("Error when saving token")
                return
            }
        }
    }
}
