//
//  BaseCurrencyInfo.swift
//  RevolutTest
//
//  Created by Nilofar Vahab poor on 28/11/2017.
//  Copyright © 2017 Nilofar Vahab poor. All rights reserved.
//

import UIKit

class BaseCurrencyInfo: NSObject {
    var baseRate: String?
    var lastAccessDate: Date?
    var rates: NSDictionary?
    
    
    init (base: String, lastAccessedDate: Date, ratesDict: NSDictionary) {
        baseRate         = base
        lastAccessDate   = lastAccessedDate
        rates            = ratesDict
    }
}
