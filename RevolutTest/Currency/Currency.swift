//
//  Currency.swift
//  RevolutTest
//
//  Created by Nilofar Vahab poor on 29/11/2017.
//  Copyright © 2017 Nilofar Vahab poor. All rights reserved.
//

import UIKit

class Currency: NSObject {
    
    var currencyCode: String?
    var countryName: String?
    var countryFlag: String?
    var currencyRate: Double?
    
    
    init (currencyC:String, localisedName:String, flag:String, rate:Double) {
        currencyCode = currencyC
        countryName  = localisedName
        countryFlag  = flag
        currencyRate = rate
    }
}
