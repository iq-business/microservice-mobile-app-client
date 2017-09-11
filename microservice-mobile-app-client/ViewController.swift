//
//  ViewController.swift
//  beverage-maker-mobile-app
//
//  Created by Gerard de Jong on 2017/04/12.
//  Copyright © 2017 IQ Business. All rights reserved.
//



import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var beverages: [String]?
    weak var timer: Timer?
    
    @IBOutlet weak var menu: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadConfiguration(configuration: "Gateway")
    }
    
    // MARK: Configuration
    
    func loadConfiguration(configuration: String) {
        guard let plistPath = Bundle.main.path(forResource: "Config", ofType: "plist") else { return }
        guard let plistData = FileManager.default.contents(atPath: plistPath) else { return }
        var format = PropertyListSerialization.PropertyListFormat.xml
        guard let  plistDict = try! PropertyListSerialization.propertyList(from: plistData, options: .mutableContainersAndLeaves, format: &format) as? [String : AnyObject] else { return }
        beverages = plistDict[configuration] as? [String]
    }

    // MARK: Periodic Refresh

    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.menu.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    // MARK: Tableview Source & Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beverages!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeverageCell") as? BerverageInformationViewCell
        
        cell?.berverageName.text = ""
        cell?.berverageName.textColor = UIColor.white
        cell?.berverageDescription.text = ""
        cell?.berveragePrice.text = ""
        cell?.loadingIndicator.startAnimating()
        
        NetworkBeverageInformationService(endPoint: beverages![indexPath.row]).getBeverageInformation() { name, description, price, error in
        //MockedBeverageInformationService().getBeverageInformation() { name, description, price, error in
            DispatchQueue.main.async() {
                cell?.loadingIndicator.stopAnimating()
                if error != nil {
                    cell?.berverageName.text = "Error: Unavailable!"
                    cell?.berverageName.textColor = UIColor.red
                }
                else {
                    cell?.berverageName.text = name!
                    cell?.berverageDescription.text = description!
                    cell?.berveragePrice.text = NSString(format: "%.2f ", price!) as String
                }
            }
        }
        
        return cell!
    }
    
    
    
    
}

