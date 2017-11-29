//
//  CurrenciesViewController.swift
//  RevolutTest
//
//  Created by Nilofar Vahab poor on 23/11/2017.
//  Copyright © 2017 Nilofar Vahab poor. All rights reserved.
//

import UIKit
import ReachabilitySwift

class currencyCell: UITableViewCell {
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyDescription: UILabel!
    @IBOutlet weak var baseRateText: UITextField!
    @IBOutlet weak var countryFlag:UILabel!
}

class CurrenciesViewController: UIViewController, NetworkStatusListener, UITableViewDelegate, UITableViewDataSource {
    let requestController   = RequestController()
    let countryFinder       = CountryFinder()
    var arrayOfCurrencies   = [Currency]()

    var baseCurrency: BaseCurrencyInfo!
    var refreshTimer: Timer!
    @IBOutlet var tableView:UITableView!
    @IBOutlet var heightConstraints: NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate      = self
        tableView.dataSource    = self
        refreshTimer            = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(refreshRate), userInfo: nil, repeats: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ReachabilityManager.shared.addListener(listener: self)
        self.downloadRates(baseRate: "EUR") // this is the base url when we dont have anything set.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshTimer.fire()

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ReachabilityManager.shared.removeListener(listener: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCurrencies.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as! currencyCell
        
        let cellCurrency: Currency  = arrayOfCurrencies[indexPath.row]
        cell.currencyLabel.text     = cellCurrency.currencyCode
        cell.countryFlag.text       = cellCurrency.countryFlag
        cell.baseRateText.text      = String(describing: cellCurrency.currencyRate!)
        cell.currencyDescription.text = cellCurrency.countryName

        return cell
    }
    
    //network status listener protocol method
    func networkStatusDidChange(status: Reachability.NetworkStatus) {
        var constraints: CGFloat = 0.0

        switch status {
        case .notReachable:
            constraints = 44.0
            debugPrint("ViewController: Network became unreachable")
            
        case .reachableViaWiFi:
            debugPrint("ViewController: Network reachable through WiFi")
            constraints = 0.0
            
        case .reachableViaWWAN:
            debugPrint("ViewController: Network reachable through Cellular Data")
            constraints = 0.0
        }
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.heightConstraints.constant = constraints
                self.view.layoutIfNeeded()
            }
        }
    }
    @objc func refreshRate() -> Void {
        var baseString:String
        if self.baseCurrency != nil {
            baseString = self.baseCurrency.baseRate!
        }
        else {
            baseString = "EUR"
        }
        self.downloadRates(baseRate: baseString)
    }
    
     func downloadRates(baseRate:String) -> Void {
        requestController.downloadLatestRatesForBaseRate(baseRate: baseRate) { (baseCurr) in
            var currencies = [Currency]()

            self.baseCurrency = baseCurr
            for (key, value) in self.baseCurrency.rates! {
                let currencyCode: String = key as! String
                let currencyRate: Double = value as! Double
                let currDescription: String =  self.countryFinder.getLocalisedStringForCurrencyCode(code: key as! String)!
                let countFlag:String = self.countryFinder.flag(country: key as! String)
                let returnedCurrency = Currency (currencyC: currencyCode, localisedName:currDescription, flag: countFlag, rate:currencyRate)
                currencies.append(returnedCurrency)
            }
            self.arrayOfCurrencies = currencies
            self.tableView .reloadData()
        }
    }
}

