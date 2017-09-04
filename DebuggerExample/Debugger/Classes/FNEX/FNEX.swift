import UIKit

class FNEXWindow: UIWindow {}

var fnexWindow = FNEXWindow(frame: UIScreen.main.bounds)

class FNEX {
    class func setup() {
        fnexWindow.rootViewController = FNEXViewController()
        fnexWindow.windowLevel = UIWindowLevelAlert + 1
        show()
    }
    
    class func show() {
        fnexWindow.isHidden = false
    }
    
    class func close() {
        fnexWindow.isHidden = true
    }
}
