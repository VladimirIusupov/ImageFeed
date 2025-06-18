import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage? {
        didSet {
<<<<<<< HEAD:ImageFeed/Views/SingleImageViewController.swift
            guard isViewLoaded else { return }
=======
            guard isViewLoaded else { return } // проверяем был ли раньше загружен view
>>>>>>> db53a05 (problems with commmit):ImageFeed/SingleImageView/SingleImageViewController.swift
            imageView.image = image
            if let image = image {
                rescaleAndCenterImageInScrollView(image: image)
            }
        }
    }

    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        guard let image else { return }
        imageView.image = image
        imageView.frame.size = image.size
        rescaleAndCenterImageInScrollView(image: image)
    }

    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        guard let image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.imageView
    }
    
<<<<<<< HEAD:ImageFeed/Views/SingleImageViewController.swift
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
=======
    func scrollViewDidZoom(_ scrollView: UIScrollView) { // вычисляем внутренние отступы, чтобы оцентровать картинку после зумирования
>>>>>>> db53a05 (problems with commmit):ImageFeed/SingleImageView/SingleImageViewController.swift
        let boundSize = scrollView.bounds.size
        let frameToCenter = imageView.frame
        let contentInsetX = max((boundSize.width - frameToCenter.size.width) * 0.5, 0)
        let contentInsetY = max((boundSize.height - frameToCenter.size.height) * 0.5, 0)
<<<<<<< HEAD:ImageFeed/Views/SingleImageViewController.swift
        scrollView.contentInset = UIEdgeInsets(top: contentInsetY, left: contentInsetX, bottom: contentInsetY, right: contentInsetX)
        scrollView.contentInsetAdjustmentBehavior = .automatic
=======
        scrollView.contentInset = UIEdgeInsets(top: contentInsetY, left: contentInsetX, bottom: contentInsetY, right: contentInsetX) // устанавливаем внутренние отступы
        scrollView.contentInsetAdjustmentBehavior = .automatic // устанавливаем отскок содержимого внутри отступов
>>>>>>> db53a05 (problems with commmit):ImageFeed/SingleImageView/SingleImageViewController.swift
    }
}


