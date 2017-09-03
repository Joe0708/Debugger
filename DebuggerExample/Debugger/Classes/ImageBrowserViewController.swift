import Foundation
import UIKit

class ImageBrowserViewController: UIViewController {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 10, y: 10, width: self.view.frame.width - 2*10, height: self.view.frame.height - 2*10)
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        return imageView
    }()
    
    public func setImageDataString(_ responseBody: String) {
        if let data = Data(base64Encoded: responseBody, options: .ignoreUnknownCharacters),
            let image = UIImage(data: data) {
            imageView.image = image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Image preview"        
    }
}
