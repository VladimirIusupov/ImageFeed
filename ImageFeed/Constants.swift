import Foundation

enum Constants {
    
    static let accessKey = "OJcrfLnPv4Wxxd8lEFsrcRD2gRxacXqZVnOBio1nJlg"
    static let secretKey = "cxypN_OSFP4gTydwoNpvh1DQ7ipVzKaEaxIMEZZ0Nh8"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    }

enum UserDefaults {
    static let bearerTokenKey = "bearerToken"
    static let unsplashGetProfileImageURLString = "https://api.unsplash.com/users/"
    static let accessKey = "OJcrfLnPv4Wxxd8lEFsrcRD2gRxacXqZVnOBio1nJlg"
    static let secretKey = "cxypN_OSFP4gTydwoNpvh1DQ7ipVzKaEaxIMEZZ0Nh8"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL: URL = defaultBaseURLgetter
    static private var defaultBaseURLgetter: URL {
        guard let url = URL(string: "https://api.unsplash.com") else {preconditionFailure("Unable to construct unsplashUrl")}
        return url
    }
}

