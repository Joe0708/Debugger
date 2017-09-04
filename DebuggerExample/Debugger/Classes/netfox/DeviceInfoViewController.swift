import UIKit

class DeviceInfoViewController: NetfoxViewController {
    
    var scrollView: UIScrollView = UIScrollView()
    var textLabel: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Info"
        
        scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.autoresizesSubviews = true
        scrollView.backgroundColor = UIColor.clear
        view.addSubview(scrollView)
        
        textLabel = UILabel()
        textLabel.frame = CGRect(x: 20, y: 20, width: scrollView.frame.width - 40, height: scrollView.frame.height - 20);
        textLabel.font = UIFont.systemFont(ofSize: 13)
        textLabel.textColor = UIColor.NFXGray44Color()
        textLabel.attributedText = generateInfoString("Retrieving IP address..")
        textLabel.numberOfLines = 0
        textLabel.sizeToFit()
        scrollView.addSubview(textLabel)
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: textLabel.frame.maxY)
        
        generateInfo()
    }

    func generateInfo(){
        NFXDebugInfo.getNFXIP { (result) -> Void in
            DispatchQueue.main.async { () -> Void in
                self.textLabel.attributedText = self.generateInfoString(result)
            }
        }
    }
    
    func generateInfoString(_ ipAddress: String) -> NSAttributedString {
        var tempString: String
        tempString = String()
        
        tempString += "[App name] \n\(NFXDebugInfo.getNFXAppName())\n\n"
        
        tempString += "[App version] \n\(NFXDebugInfo.getNFXAppVersionNumber()) (build \(NFXDebugInfo.getNFXAppBuildNumber()))\n\n"
        
        tempString += "[App bundle identifier] \n\(NFXDebugInfo.getNFXBundleIdentifier())\n\n"
        
        tempString += "[Device OS] \niOS \(NFXDebugInfo.getNFXOSVersion())\n\n"
        
        tempString += "[Device screen resolution] \n\(NFXDebugInfo.getNFXDeviceScreenResolution())\n\n"
        
        tempString += "[Device IP address] \n\(ipAddress)\n\n"
        
        return formatNFXString(tempString)
    }
}
