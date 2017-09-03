import Foundation
import UIKit

class NetfoxViewController: UIViewController {

    override func viewDidLoad(){
        super.viewDidLoad()
        
        edgesForExtendedLayout = UIRectEdge()
        view.backgroundColor = UIColor(netHex: 0xf2f2f2)
    }
    
    func formatNFXString(_ string: String) -> NSAttributedString
    {
        var tempMutableString = NSMutableAttributedString()
        tempMutableString = NSMutableAttributedString(string: string)
        
        let l = string.characters.count
        
        let regexBodyHeaders = try! NSRegularExpression(pattern: "(\\-- Body \\--)|(\\-- Headers \\--)", options: NSRegularExpression.Options.caseInsensitive)
        let matchesBodyHeaders = regexBodyHeaders.matches(in: string, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, l)) as Array<NSTextCheckingResult>
        
        for match in matchesBodyHeaders {
            tempMutableString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 14), range: match.range)
            tempMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.orange, range: match.range)
        }
        
        let regexKeys = try! NSRegularExpression(pattern: "\\[.+?\\]", options: NSRegularExpression.Options.caseInsensitive)
        let matchesKeys = regexKeys.matches(in: string, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, l)) as Array<NSTextCheckingResult>
        
        for match in matchesKeys {
            tempMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: match.range)
        }
        
        return tempMutableString
    }
    
    func reloadData() {
    }
}
