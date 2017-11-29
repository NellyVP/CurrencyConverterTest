//
//  RequestController.swift
//  RevolutTest
//
//  Created by Nilofar Vahab poor on 23/11/2017.
//  Copyright © 2017 Nilofar Vahab poor. All rights reserved.
//

import UIKit
import Alamofire


class RequestController: NSObject {
    private var baseURL = "https://revolut.duckdns.org/latest?base="
    
    var networkAccessible:Bool?
    
    func downloadLatestRatesForBaseRate (baseRate:String, completionBlock: @escaping (BaseCurrency?) -> Void) {
        let modifiedURLString = String(format:"%@%@", baseURL, baseRate)
        var baseCurr: BaseCurrency!
        
        Alamofire.request(
            URL(string: modifiedURLString)!,
            method: .get,
            parameters: ["include_docs": "true"])
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching remote information: \(String(describing: response.result.error))")
                    completionBlock(nil)
                    return
                }
                
                if let arrayOfDic = response.result.value as? NSDictionary {
                    baseCurr = ModelController.sharedInstance.populateBaseCurrency(dict: arrayOfDic)
                }
                completionBlock(baseCurr)
        }
    }
    
}
