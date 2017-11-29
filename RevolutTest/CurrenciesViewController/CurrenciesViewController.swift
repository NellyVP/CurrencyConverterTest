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
    @IBOutlet weak var countryImg:UIImageView!
    
}

class CurrenciesViewController: UIViewController, NetworkStatusListener, UITableViewDelegate, UITableViewDataSource {
    let requestController   = RequestController()
    let countryFinder       = CountryFinder()

    var baseCurrency: BaseCurrency!
    var refreshTimer: Timer!
    @IBOutlet var tableView:UITableView!
    @IBOutlet var heightConstraints: NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate      = self
        tableView.dataSource    = self
        refreshTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(refreshRate), userInfo: nil, repeats: true)

        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ReachabilityManager.shared.addListener(listener: self)
        self.downloadRates(baseRate: "EUR")
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
        if (baseCurrency != nil) {
            return (baseCurrency.rates?.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as! currencyCell
        
        
        cell.currencyLabel?.text = baseCurrency.rates?.allKeys[indexPath.row] as? String
        let arrayOfNames:[String] = baseCurrency.rates?.allKeys as! [String]

        var countryNames = [String]()
        let locale:Locale  = countryFinder.locale(from: "GBP")
        print(locale)

        let fullName:String = countryFinder.getSymbolForCurrencyCode(code: "GBP")!
        print(fullName)
        
//        for name:String in arrayOfNames {
//            let fullName = countryFinder.getSymbolForCurrencyCode(code: name)
//            countryNames.append(fullName!)
//        }
        
       // countryFinder.getSymbolForCurrencyCode(code: (baseCurrency.rates?.allKeys[indexPath.row] as? String)!)
       // cell.currencyDescription?.text = countryNames[indexPath.row]
        cell.currencyDescription?.text = baseCurrency.rates?.allKeys[indexPath.row] as? String

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
            self.baseCurrency = baseCurr
            self.tableView .reloadData()
        }
    }
}

