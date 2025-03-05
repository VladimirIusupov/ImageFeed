import SwiftUI

final class ProfileViewController: UIViewController {
    //MARK: adding variable values
    private var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Photo")
        imageView.layer.cornerRadius = 35
        return imageView
    }()
    
    private var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Vladimir Iusupov"
        label.font = UIFont(name: "YSDisplay-Bold", size: 23)
        label.textColor = .ypWhite
        return label
    }()
    
    private var systemLoginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@vladimiriusupov"
        label.font = UIFont(name: "YSDisplay-Medium", size: 13)
        label.textColor = .ypWhite
        return label
    }()
    
    private var userInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "iOS Swift developer"
        label.numberOfLines = 0
        label.font = UIFont(name: "YSDisplay-Medium", size: 13)
        label.textColor = .ypWhite
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "Exit")!,
            target: self,
            action: #selector(didTapLogoutButton)
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .ypRed
        return button
    }()
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddSubview()
        setupConstraits()
    }
    
    //MARK: functions for constraits and addindsubview
    
    private func setupAddSubview() {
        view.addSubview(avatarImageView)
        view.addSubview(usernameLabel)
        view.addSubview(systemLoginLabel)
        view.addSubview(userInfoLabel)
        view.addSubview(logoutButton)
    }
    
    private func setupConstraits() {
        let avatarImageViewConstraints = [
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ]
        let usernameLabelConstraints = [
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8)
        ]
        let systemLoginLabelConstraints = [
            systemLoginLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            systemLoginLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor)
        ]
        let userInfoLabelConstraints = [
            userInfoLabel.topAnchor.constraint(equalTo: systemLoginLabel.bottomAnchor, constant: 8),
            userInfoLabel.leadingAnchor.constraint(equalTo: systemLoginLabel.leadingAnchor)
        ]
        let logoutButtonConstraints = [
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(
            avatarImageViewConstraints +
            usernameLabelConstraints +
            systemLoginLabelConstraints +
            userInfoLabelConstraints +
            logoutButtonConstraints
        )
    }
    
    @objc
    private func didTapLogoutButton() {
        print("Logout button tapped")
    }
    
    
}
