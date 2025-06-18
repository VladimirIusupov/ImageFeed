import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func cellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBAction func didTapLikeButton(_ sender: Any) {
        delegate?.cellDidTapLike(self)
    }
    static let reuseIdentifier = "ImagesListCell"
    let gradientLayer = CAGradientLayer()
    var delegate: ImagesListCellDelegate?

    override func layoutSubviews() {
        super.layoutSubviews()
        configureGradient()
    }

    private func configureGradient() {
        
        let firstColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0.3)
        let secondColor = firstColor
        let clearColor = UIColor.clear
        
        gradientLayer.frame = dateLabel.bounds
        gradientLayer.bounds.size.height = 31
        gradientLayer.bounds.size.width = bounds.width
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor, clearColor.cgColor]
        gradientLayer.locations = [0.0, 0.2, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        dateLabel.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    func setIsLiked(isLiked: Bool) {
        likeButton.setImage(UIImage(resource: isLiked ? .likeButtonOn : .likeButtonOff), for: .normal)
    }
}

