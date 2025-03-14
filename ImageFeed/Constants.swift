import UIKit

enum Constants {
    static let accessKey = "OJcrfLnPv4Wxxd8lEFsrcRD2gRxacXqZVnOBio1nJlg"
    static let secretKey = "cxypN_OSFP4gTydwoNpvh1DQ7ipVzKaEaxIMEZZ0Nh8"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
    static let unsplashAuthorizeURLStringIdentifier = "https://unsplash.com/oauth/authorize"
}

enum Identifiers {
    static let authWebScreenIdentifier = "ShowWebView"
    static let tokenKey = "BearerToken"
    static let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    static let showGallerySegueId = "showGallery"
    static let showAuthSegueId = "showAuthorization"
}
