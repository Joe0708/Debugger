import Foundation
import UIKit

enum HTTPModelShortType: String {
    case JSON = "JSON"
    case XML = "XML"
    case HTML = "HTML"
    case IMAGE = "Image"
    case OTHER = "Other"
    
    static let allValues = [JSON, XML, HTML, IMAGE, OTHER]
}

extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int)
    {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex: Int)
    {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    class func NFXOrangeColor() -> UIColor
    {
        return UIColor.init(netHex: 0xec5e28)
    }
    
    class func NFXGreenColor() -> UIColor
    {
        return UIColor.init(netHex: 0x38bb93)
    }
    
    class func NFXDarkGreenColor() -> UIColor
    {
        return UIColor.init(netHex: 0x2d7c6e)
    }
    
    class func NFXRedColor() -> UIColor
    {
        return UIColor.init(netHex: 0xd34a33)
    }
    
    class func NFXDarkRedColor() -> UIColor
    {
        return UIColor.init(netHex: 0x643026)
    }
    
    class func NFXStarkWhiteColor() -> UIColor
    {
        return UIColor.init(netHex: 0xccc5b9)
    }
    
    class func NFXDarkStarkWhiteColor() -> UIColor
    {
        return UIColor.init(netHex: 0x9b958d)
    }
    
    class func NFXLightGrayColor() -> UIColor
    {
        return UIColor.init(netHex: 0x9b9b9b)
    }
    
    class func NFXGray44Color() -> UIColor
    {
        return UIColor.init(netHex: 0x707070)
    }
    
    class func NFXGray95Color() -> UIColor
    {
        return UIColor.init(netHex: 0xf2f2f2)
    }
    
    class func NFXBlackColor() -> UIColor
    {
        return UIColor.init(netHex: 0x231f20)
    }
}

extension URLRequest
{
    func getNFXURL() -> String {
        return url != nil ? url!.absoluteString : "Unknown"
    }
    
    func getNFXMethod() -> String {
        return httpMethod ?? "Unknown"
    }
    
    func getNFXCachePolicy() -> String
    {
        switch cachePolicy {
        case .useProtocolCachePolicy: return "UseProtocolCachePolicy"
        case .reloadIgnoringLocalCacheData: return "ReloadIgnoringLocalCacheData"
        case .reloadIgnoringLocalAndRemoteCacheData: return "ReloadIgnoringLocalAndRemoteCacheData"
        case .returnCacheDataElseLoad: return "ReturnCacheDataElseLoad"
        case .returnCacheDataDontLoad: return "ReturnCacheDataDontLoad"
        case .reloadRevalidatingCacheData: return "ReloadRevalidatingCacheData"
        }
        
    }
    
    func getNFXTimeout() -> String
    {
        return String(Double(timeoutInterval))
    }
    
    func getNFXHeaders() -> [AnyHashable: Any]
    {
        if (allHTTPHeaderFields != nil) {
            return allHTTPHeaderFields!
        } else {
            return Dictionary()
        }
    }
    
    func getNFXBody() -> Data
    {
        return httpBody ?? URLProtocol.property(forKey: "NFXBodyData", in: self) as? Data ?? Data()
    }
}

extension URLResponse {
    func getNFXStatus() -> Int
    {
        return (self as? HTTPURLResponse)?.statusCode ?? 999
    }
    
    func getNFXHeaders() -> [AnyHashable: Any]
    {
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
    
    class func NFXStatistics() -> UIImage {
        return UIImage(data: NFXAssets.getImage(NFXAssetName.statistics), scale: 1.7)!
    }
}

extension Date {
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        return compare(dateToCompare) == ComparisonResult.orderedDescending
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
    
    class func getNFXDeviceType() -> String {
        return UIDevice.getNFXDeviceType()
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


struct NFXPath {
    static let Documents = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first! as NSString
    
    static let SessionLog = NFXPath.Documents.appendingPathComponent("session.log");
}


extension String {
    func appendToFile(filePath: String) {
        let contentToAppend = self
        
        if let fileHandle = FileHandle(forWritingAtPath: filePath) {
            /* Append to file */
            fileHandle.seekToEndOfFile()
            fileHandle.write(contentToAppend.data(using: String.Encoding.utf8)!)
        } else {
            /* Create new file */
            do {
                try contentToAppend.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
            } catch {
                print("Error creating \(filePath)")
            }
        }
    }
}
