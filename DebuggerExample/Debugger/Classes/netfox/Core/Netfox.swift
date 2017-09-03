import Foundation
import UIKit

// Notifications posted when NFX opens/closes, for client application that wish to log that information.
let nfxWillOpenNotification = "NFXWillOpenNotification"
let nfxWillCloseNotification = "NFXWillCloseNotification"
let sessionLogPath = FileManager.debugger.appendingPathComponent("session.log")

@objc
open class Netfox: NSObject {
    // swiftSharedInstance is not accessible from ObjC
    class var shared: Netfox {
        struct Singleton {
            static let instance = Netfox()
        }
        return Singleton.instance
    }
    
    // the sharedInstance class method can be reached from ObjC
    open class func sharedInstance() -> Netfox {
        return Netfox.shared
    }
    
    @objc public enum ENFXGesture: Int {
        case shake
        case custom
    }
    
    fileprivate var started: Bool = false
    fileprivate var presented: Bool = false
    fileprivate var enabled: Bool = false
    fileprivate var selectedGesture: ENFXGesture = .shake
    fileprivate var ignoredURLs = [String]()
    fileprivate var filters = [Bool]()
    fileprivate var lastVisitDate: Date = Date()
    
    @objc open func start() {
        guard !self.started else {
            Logger.info("Alredy started!")
            return
        }
        
        self.started = true
        register()
        enable()
        clearOldData()
    }
    
    @objc open func stop() {
        unregister()
        disable()
        clearOldData()
        started = false
    }
    
    internal func isEnabled() -> Bool {
        return enabled
    }
    
    internal func enable() {
        enabled = true
    }
    
    internal func disable() {
        enabled = false
    }
    
    fileprivate func register() {
        URLProtocol.registerClass(NFXProtocol.self)
    }
    
    fileprivate func unregister() {
        URLProtocol.unregisterClass(NFXProtocol.self)
    }
    
    func motionDetected() {
        if started { presented ? hideNFX() : showNFX() }
    }
    
    @objc open func setGesture(_ gesture: ENFXGesture) {
        self.selectedGesture = gesture
    }
    
    @objc open func show() {
        if (self.started) && (self.selectedGesture == .custom) {
            showNFX()
        } else {
            Logger.error("Please call start() and setGesture(.custom) first")
        }
    }
    
    @objc open func hide() {
        if (self.started) && (self.selectedGesture == .custom) {
            hideNFX()
        } else {
            Logger.error("Please call start() and setGesture(.custom) first")
        }
    }
    
    @objc open func ignoreURL(_ url: String) {
        self.ignoredURLs.append(url)
    }
    
    internal func getLastVisitDate() -> Date {
        return self.lastVisitDate
    }
    
    fileprivate func showNFX() {
        if self.presented { return }
        
        self.showNFXFollowingPlatform()
        self.presented = true
        
    }
    
    fileprivate func hideNFX() {
        if !self.presented { return }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "NFXDeactivateSearch"), object: nil)
        self.hideNFXFollowingPlatform {
            self.presented = false
            self.lastVisitDate = Date()
        }
    }
    
    internal func clearOldData() {
        NFXHTTPModelManager.sharedInstance.clear()
        do {
            try FileManager.default.removeItem(atPath: FileManager.debugger)
            try FileManager.default.removeItem(atPath: sessionLogPath)
            Logger.info("Cache cleanup success")
        } catch {}
    }
    
    func getIgnoredURLs() -> [String] {
        return self.ignoredURLs
    }
    
    func getSelectedGesture() -> ENFXGesture {
        return self.selectedGesture
    }
    
    func cacheFilters(_ selectedFilters: [Bool]) {
        self.filters = selectedFilters
    }
    
    func getCachedFilters() -> [Bool] {
        if self.filters.count == 0 {
            self.filters = [Bool](repeating: true, count: HTTPModelShortType.allValues.count)
        }
        return self.filters
    }
    
}

extension Netfox {
    
    fileprivate func showNFXFollowingPlatform() {
        var navigationController: UINavigationController?
        
        let listController = RequestListViewController()
        
        navigationController = UINavigationController(rootViewController: listController)
        navigationController!.navigationBar.isTranslucent = false
        
        presentingViewController?.present(navigationController!, animated: true, completion: nil)
    }
    
    fileprivate func hideNFXFollowingPlatform(_ completion: (() -> Void)?) {
        presentingViewController?.dismiss(animated: true, completion: { () -> Void in
            completion?()
        })
    }
    
    fileprivate var presentingViewController: UIViewController? {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        return rootViewController?.presentedViewController ?? rootViewController
    }
    
}
