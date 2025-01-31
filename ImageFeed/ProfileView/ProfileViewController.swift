import SwiftUI

final class ProfileViewController: UIViewController {
    // MARK: - IBOutlet
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var exitButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func exitButtonPush() {
    }
}
