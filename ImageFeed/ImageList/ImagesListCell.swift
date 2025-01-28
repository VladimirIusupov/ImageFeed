import UIKit

final class ImagesListCell: UITableViewCell {
    // MARK: - Static properties
    static let reuseIdentifier = "ImagesListCell"
    // MARK: - Dinamic properties
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
}
