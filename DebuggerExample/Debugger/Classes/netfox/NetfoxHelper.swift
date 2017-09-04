import Foundation
import UIKit

enum NFXAssetName {
    case settings
    case info
}

class NFXAssets {
    class func getImage(_ image: NFXAssetName) -> Data {
        var base64Image: String
        
        switch image {
        case .settings:
            base64Image = getSettingsImageBase64()
        case .info:
            base64Image = getInfoImageBase64()
        }
        
        if let imageData = Data(base64Encoded: base64Image, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) {
            return imageData
        } else {
            return Data()
        }
    }
    
    class func getSettingsImageBase64() -> String {
        return "iVBORw0KGgoAAAANSUhEUgAAACwAAAAsCAMAAAApWqozAAAAjVBMVEUAAADsXijtXSfsXSftXijsXibsXSftXibtXSftXijtXSftXSXtXijtXijtXibtXSftXSfsXijsXSfuXSbsXijtXiftXSfuXSbtXijsXSjsXSjsXSjsXSftXSbsXSftXijtXibtXSftXSbuXSXtXSfsXifsXSftXibtXibsXSjtXSjtXSbtXyXtXibsXigoILJHAAAALnRSTlMA+wPDvSDAgdqtlhUH1GpRGOnIk/j0XS7vz6mkdR0PtJw7MguQZFl8VuzMRSaGMJ3GQwAAAi5JREFUOMulVdm2ojAQTEJYZRcQBBQVl+tS//95MwGDAQev50xeslWS7upONXlvfp4kNMkz8k1bo9A0D85XYC8/ELKh2jfYBb12R9LDPGa5ZP1gh1J0Nvb93F2WbIoFilU3CnAWnYmgm648wJ5iuQNaiU3eoy7g4rBPseRYq1gHhksuCZyTBli6WNItgAct6IW4HPbLklZgu0sBO9j0i5tgC8D4a7lAlwP4Id9Z2nf1wdXWkdQ/Xqsc/ic2fXCV2xSreewK6UKdZyjYLLjAacqdmguuO6KqnZy+YSuHuqlFkXbW5VzDbgK+Qm5WACwLQPVc2MMYY/UhpA1Sv2as9lM0w9XhAGTh7mjg1k9MGIsnQwZM6f022y2YeLW0IB7uE7LGz2Lg8wd1NwgjANQrKwL8XMvqEsqLj2RoR3m1fjqX1xwgSbFRbI+pQn9IY2VrUyRk9H3cyFLdtiKVb40SanwLNihJvJCpZoQzZrDQS4jw0z7/5qBpexQgxzZOX9Tps9SlWpt1fu6z34Jy2iuc3Ydwl8jfw70goxZ/SiT+IUXP4xSN31K0QTuf/M70S37QwRjHUTrTVJ8H3ylVdlmBgHxoJ+U7s8HgZkZkHDRMgh1wEcDdtZOvgypfsWDiwLFmqjAy4gNmEANePQjj7QH4hElhHGTDWCPKRAiMkeRmOdZSchU0eP30plLFXDekmKtok8gy0YzKBDHLeWULEcsC9FVpc2Vp+/+iOS3H9N/l+A8JizxgzuMcJQAAAABJRU5ErkJggg=="
    }
    
    class func getInfoImageBase64() -> String {
        return "iVBORw0KGgoAAAANSUhEUgAAACwAAAAsCAMAAAApWqozAAAAb1BMVEUAAADsXijsXijsXCbtXCfsXijsXijsXijsXijsXifsXijsXifsXijsXijsXijsXSfsXijsXSjsXijsXijsXijsXijsXijsXifsXSjsXiftXSfsXijsXSfsXSbsXijsXijsXijsXijtXifsXSjsXihHY9oeAAAAJHRSTlMA+mMTBO/VUeM3CqHe9KwOmj/nx7ymmJF7a1s4MyabRN1nG4QDLG4nAAABaklEQVQ4y5WV626DMAyFHXInhDuMcm07v/8zTt0mNEiykvPT+mQ5ju0DR7FUD7moEWuRDzplEBadeoKEq7sQd8UJkn6iAbSQLdpmTWbKABidk7Wx2MrCx+oOeSkPmagsOXbaZW8KTeXUyCqD6naOfhA+puBROnLycQwZzBYIaMnQHPKioBAUFfgn941kO+ulM7LXrRVf4F8tXOnf/nY4whuN2P30W6I59aEyZjv1xKD8LqjlFRz1QPw8hSreUgCYsGTvYVbiBMB6K53Xb9vzHJO2Z5CShsIF0YanoHGFS1pRw0ASJ/6U8ukEEzJAzmdP3JNh5jkIRa/BVAmo7+wazLIaUMA1GARGwVFlRD0wrnUDSUKw+yka12vwitoZpBBMG5vuI+rC7ojuw+/A7vAH1+rhWSv/wm557lnYwClgRcHcUxBzZGLOV8xhjDm5Mcc82ibiDShsbeVubQHTtC/TzITIXqZpHdOMsOMvY4Ib6juEh/AAAAAASUVORK5CYII="
    }
}

enum HTTPModelShortType: String {
    case JSON = "JSON"
    case XML = "XML"
    case HTML = "HTML"
    case IMAGE = "Image"
    case OTHER = "Other"
    
    static let allValues = [JSON, XML, HTML, IMAGE, OTHER]
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex: Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    class func NFXGray44Color() -> UIColor {
        return UIColor(netHex: 0x707070)
    }
}

extension URLRequest {
    func getNFXURL() -> String {
        return url != nil ? url!.absoluteString : "Unknown"
    }
    
    func getNFXCachePolicy() -> String {
        switch cachePolicy {
        case .useProtocolCachePolicy: return "UseProtocolCachePolicy"
        case .reloadIgnoringLocalCacheData: return "ReloadIgnoringLocalCacheData"
        case .reloadIgnoringLocalAndRemoteCacheData: return "ReloadIgnoringLocalAndRemoteCacheData"
        case .returnCacheDataElseLoad: return "ReturnCacheDataElseLoad"
        case .returnCacheDataDontLoad: return "ReturnCacheDataDontLoad"
        case .reloadRevalidatingCacheData: return "ReloadRevalidatingCacheData"
        }
        
    }
    
    func getNFXTimeout() -> String {
        return String(Double(timeoutInterval))
    }
    
    func getNFXHeaders() -> [AnyHashable: Any] {
        if (allHTTPHeaderFields != nil) {
            return allHTTPHeaderFields!
        } else {
            return Dictionary()
        }
    }
    
    func getNFXBody() -> Data {
        return httpBody ?? URLProtocol.property(forKey: "NFXBodyData", in: self) as? Data ?? Data()
    }
}

extension URLResponse {
    func getNFXHeaders() -> [AnyHashable: Any] {
        return (self as? HTTPURLResponse)?.allHeaderFields ?? [:]
    }
}

extension UIImage {
    
    class func NFXSettings() -> UIImage{
        return UIImage(data: NFXAssets.getImage(NFXAssetName.settings), scale: 1.7)!
    }
    
    class func NFXInfo() -> UIImage {
        return UIImage(data: NFXAssets.getImage(NFXAssetName.info), scale: 1.7)!
    }
}



class NFXDebugInfo {
    
    class func getNFXAppName() -> String {
        return Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
    class func getNFXAppVersionNumber() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    class func getNFXAppBuildNumber() -> String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
    
    class func getNFXBundleIdentifier() -> String {
        return Bundle.main.bundleIdentifier ?? ""
    }
    
    class func getNFXOSVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    class func getNFXDeviceScreenResolution() -> String {
        let scale = UIScreen.main.scale
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width * scale
        let height = bounds.size.height * scale
        return "\(width) x \(height)"
    }
    
    class func getNFXIP(_ completion:@escaping (_ result: String) -> Void) {
        var req: NSMutableURLRequest
        req = NSMutableURLRequest(url: URL(string: "https://api.ipify.org/?format=json")!)
        URLProtocol.setProperty("1", forKey: "NFXInternal", in: req)
        
        let session = URLSession.shared
        session.dataTask(with: req as URLRequest, completionHandler: { (data, response, error) in
            do {
                let rawJsonData = try JSONSerialization.jsonObject(with: data!, options: [.allowFragments])
                if let ipAddress = (rawJsonData as AnyObject).value(forKey: "ip") {
                    completion(ipAddress as! String)
                } else {
                    completion("-")
                }
            } catch {
                completion("-")
            }
            
            }) .resume()
    }
    
}
