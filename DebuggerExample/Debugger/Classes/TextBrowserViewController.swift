import Foundation
import UIKit

class TextBrowserViewController: UIViewController {
    
    private lazy var bodyView: UITextView = {
        let bodyView = UITextView()
        bodyView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        bodyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bodyView.backgroundColor = UIColor.clear
        bodyView.textColor = UIColor.NFXGray44Color()
        bodyView.textAlignment = .left
        bodyView.isEditable = false
        bodyView.font = UIFont.systemFont(ofSize: 13)
        bodyView.showsHorizontalScrollIndicator = true
        return bodyView
    }()
    
    public var bodyText: String?
    
    private var copyAlert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Body details"

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Copy", style: .plain, target: self, action: #selector(copyLabel))

        view.addSubview(bodyView)
        bodyView.text = bodyText
    }

    @objc fileprivate func copyLabel() {
        UIPasteboard.general.string = bodyView.text

        let alert = UIAlertController(title: "Text Copied!", message: nil, preferredStyle: .alert)
        copyAlert = alert

        present(alert, animated: true) { [weak self] in
            guard let `self` = self else { return }

            Timer.scheduledTimer(timeInterval: 0.45,
                                 target: self,
                                 selector: #selector(TextBrowserViewController.dismissCopyAlert),
                                 userInfo: nil,
                                 repeats: false)
        }
    }

    @objc fileprivate func dismissCopyAlert() {
        copyAlert?.dismiss(animated: true) { [weak self] in self?.copyAlert = nil }
    }
}
