//
//  CountryFinder.swift
//  RevolutTest
//
//  Created by Nilofar Vahab poor on 29/11/2017.
//  Copyright © 2017 Nilofar Vahab poor. All rights reserved.
//

import UIKit

class CountryFinder: NSObject {
    func getSymbolForCurrencyCode(code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        let symbol = locale.object(forKey: NSLocale.Key.currencySymbol) as! String

        if symbol == code {
            let newlocale = NSLocale(localeIdentifier: code.characters.dropLast() + "_en")
            return newlocale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
        }
       // return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
        return locale.localizedString(forCountryCode:code)
    }
    func locale(from currencyCode: String) -> Locale {
        var locale = Locale.current
        if (locale.currencyCode != currencyCode) {
            let identifier = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.currencyCode.rawValue: currencyCode])
            locale = NSLocale(localeIdentifier: identifier) as Locale
        }
        return locale;
    }
}
