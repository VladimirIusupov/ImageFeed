import Foundation

struct UserResult: Codable {
    let profileImage: Image
    struct Image: Codable{
        let large: String
    }
}
