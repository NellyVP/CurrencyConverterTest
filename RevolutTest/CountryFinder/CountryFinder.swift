//
//  CountryFinder.swift
//  RevolutTest
//
//  Created by Nilofar Vahab poor on 29/11/2017.
//  Copyright © 2017 Nilofar Vahab poor. All rights reserved.
//

import UIKit

class CountryFinder: NSObject {
    func getLocalisedStringForCurrencyCode(code: String) -> String? {
        let newlocale = NSLocale(localeIdentifier: "en_US")
        return newlocale.displayName(forKey: NSLocale.Key.currencyCode, value: code)
    }
    
    func flag(country:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }

}
