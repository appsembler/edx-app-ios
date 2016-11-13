//
//  OEXFonts.swift
//  edX
//
//  Created by José Antonio González on 11/2/16.
//  Copyright © 2016 edX. All rights reserved.
//

import UIKit

public class OEXFonts: NSObject {
    
    //MARK: - Shared Instance
    public static let sharedInstance = OEXFonts()
    @objc public enum FontIdentifiers: Int {
        case Regular = 1, Italic, SemiBold, SemiBoldItalic, Bold, BoldItalic, Light, LightItalic, ExtraBold, ExtraBoldItalic, Irregular
    }
    
    public var fontsDictionary = [String: AnyObject]()
    
    private override init() {
        super.init()
        fontsDictionary = initializeFontsDictionary()
    }
    
    private func initializeFontsDictionary() -> [String: AnyObject] {
        guard let filePath = NSBundle.mainBundle().pathForResource("fonts", ofType: "json") else {
            return fallbackFonts()
        }
        if let data = NSData(contentsOfFile: filePath) {
            var error : NSError?
            
            if let json = JSON(data: data, error: &error).dictionaryObject{
                return json
            }
        }
        return fallbackFonts()
    }
    
    public func fallbackFonts() -> [String: AnyObject] {
        return OEXFontsDataFactory.fonts
    }
    
    public func fontForIdentifier(identifier: FontIdentifiers, size: CGFloat) -> UIFont {
        if let fontName = fontsDictionary[getIdentifier(identifier)] as? String {
            return UIFont(name: fontName, size: size)!
        }
        return UIFont(name:getIdentifier(FontIdentifiers.Irregular), size: size)!
    }
    
    private func getIdentifier(identifier: FontIdentifiers) -> String {
        switch identifier {
        case .Regular:
            return "regular"
        case .Italic:
            return "italic"
        case .SemiBold:
            return "semiBold"
        case .SemiBoldItalic:
            return "semiBoldItalic"
        case .Bold:
            return "bold"
        case .BoldItalic:
            return "boldItalic"
        case .Light:
            return "light"
        case .LightItalic:
            return "lightItalic"
        case .ExtraBold:
            return "extraBold"
        case .ExtraBoldItalic:
            return "extraBoldItalic"
        case .Irregular:
            return "Zapfino"
        }
    }
}

