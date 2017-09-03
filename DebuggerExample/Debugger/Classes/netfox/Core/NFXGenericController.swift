//
//  NFXGenericController.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

import Foundation
import UIKit

class NFXGenericController: UIViewController {
    var selectedModel: NFXHTTPModel = NFXHTTPModel()

    override func viewDidLoad(){
        super.viewDidLoad()
        
        edgesForExtendedLayout = UIRectEdge()
        view.backgroundColor = UIColor.NFXGray95Color()
    }
    
    func selectedModel(_ model: NFXHTTPModel)
    {
        self.selectedModel = model
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
            tempMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.NFXOrangeColor(), range: match.range)
        }
        
        let regexKeys = try! NSRegularExpression(pattern: "\\[.+?\\]", options: NSRegularExpression.Options.caseInsensitive)
        let matchesKeys = regexKeys.matches(in: string, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, l)) as Array<NSTextCheckingResult>
        
        for match in matchesKeys {
            tempMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.NFXBlackColor(), range: match.range)
        }
        
        return tempMutableString
    }
    
    func reloadData()
    {
    }
}
