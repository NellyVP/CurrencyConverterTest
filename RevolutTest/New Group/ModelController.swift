//
//  ModelController.swift
//  RevolutTest
//
//  Created by Nilofar Vahab poor on 23/11/2017.
//  Copyright © 2017 Nilofar Vahab poor. All rights reserved.
//

import UIKit

class ModelController: NSObject {

    static let sharedInstance = ModelController()
    
    func populateBaseCurrencyInfo(dict: NSDictionary) -> BaseCurrencyInfo {
        let currencyValues: BaseCurrencyInfo
        
        let baseRate     = dict["base"] as! String
        let date         = dict["date"] as! String
        let ratesDict    = dict["rates"]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD" //Your date format
        let accessDate = dateFormatter.date(from: date) //according to date format your date string
        
        currencyValues = BaseCurrencyInfo (base: baseRate, lastAccessedDate: accessDate!, ratesDict: ratesDict as! NSDictionary)
        
        return currencyValues
    }
    
}
