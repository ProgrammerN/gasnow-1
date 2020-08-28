//
//  String+Encode.swift
//  chatapp
//
//  Created by Kris Rudolph  on 2/7/17.
//  Copyright © 2017 Outlook Amusements, Inc. All rights reserved.
//

import Foundation
import UIKit
enum CardNumberValue: String {
    case addNewCard = "0"
    case paypal = "-1"
}

//MARK:- Psychic Status 
enum PsychicAvailableStatus:String {
    case onLine = "Online"
    case offLine = "Offline"
    case onACall = "On a call"
}

enum CreditCardType: String {
    case Amex, Visa, MasterCard, Discover, PayPal, Unknown
}

extension String {
    //: ### Base64 encoding a string
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    //: ### Base64 decoding a string
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    /// Uppercased first letter - preserves the rest of the characters.. unlike `capitalized`
    var firstLetterUppercased: String {
        if isEmpty { return self }
        let first = uppercased().substring(to: index(after: startIndex))
        let rest = String(dropFirst())
        return first + rest
    }
    
    func appendHTTPPrefix() -> String {
        let httpStr: NSString = "https:"
        return httpStr.appending(self)
    }
    
    func appendPerMinuteSuffix() -> String {
        let perMinStr: String = "/min"
        return self.appending(perMinStr)
    }
    
    func utf8Encode() -> String {
        if let htmldata = self.data(using: .utf8), let attributedStr = try? NSAttributedString(data: htmldata, options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) {
            let decodedString = attributedStr.string
            return decodedString
        }
        return " "
    }
    
    func truncateString() -> String {
        if self.count > 100 {
        let trimToCharacter = self.count > 70 ? 70 : self.count
        return String(self.prefix(trimToCharacter)) + "..."
        } else {
            return self
        }
    }
    
    func appendColonInText() -> String {
        return self + ": "
    }
    
    // MARK: - Credit Card Helpers
    func getCreditCardType() -> CreditCardType {
        if self.hasPrefix("34") == true || self.hasPrefix("37") == true {
            return .Amex
        } else if self.hasPrefix("6") {
            return .Discover
        } else if self.hasPrefix("2") || self.hasPrefix("5") {
            return .MasterCard
        } else if self.hasPrefix("4") {
            return .Visa
        }
        return .Unknown
    }
    
    func formatPhoneNumber() -> String? {
        // Remove any character that is not a number
        let numbersOnly = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let length = numbersOnly.count
        let hasLeadingOne = numbersOnly.hasPrefix("1")
        
        // Check for supported phone number length
        guard length == 7 || length == 10 || (length == 11 && hasLeadingOne) else {
            return nil
        }
        
        let hasAreaCode = (length >= 10)
        var sourceIndex = 0
        
        // Leading 1
        var leadingOne = ""
        if hasLeadingOne {
            leadingOne = "1."
            sourceIndex += 1
        }
        
        // Area code
        var areaCode = ""
        if hasAreaCode {
            let areaCodeLength = 3
            guard let areaCodeSubstring = numbersOnly.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
                return nil
            }
            areaCode = String(format: "%@.", areaCodeSubstring)
            sourceIndex += areaCodeLength
        }
        
        // Prefix, 3 characters
        let prefixLength = 3
        guard let prefix = numbersOnly.substring(start: sourceIndex, offsetBy: prefixLength) else {
            return nil
        }
        sourceIndex += prefixLength
        
        // Suffix, 4 characters
        let suffixLength = 4
        guard let suffix = numbersOnly.substring(start: sourceIndex, offsetBy: suffixLength) else {
            return nil
        }
        
        return leadingOne + areaCode + prefix + "." + suffix
    }
    
    
    /// This method makes it easier extract a substring by character index where a character is viewed as a human-readable character (grapheme cluster).
    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }
        
        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }
        
        return String(self[substringStartIndex ..< substringEndIndex])
    }
    
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func deleteHTMLTag(tag:String) -> String {
        return self.replacingOccurrences(of: "(?i)</?\(tag)\\b[^<]*>", with: "", options: .regularExpression, range: nil)
    }
}
