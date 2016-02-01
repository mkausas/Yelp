//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Martynas Kausas on 1/31/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: FiltersViewControllerDelegate?
    
    var catergories: [[String: String]]!
    
    var switchStates = [Int: Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        catergories = [["name": "vegetarian"]]
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return catergories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
        
        cell.switchLabel.text = catergories[indexPath.row]["name"]
        cell.delegate = self
        
        cell.onSwitch.on = switchStates[indexPath.row] ?? false // shorthand for if not nill then choose next
        
        return cell
        
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!
        
        
        switchStates[indexPath.row] = value
        print("Filters view controller got the switch event")
    }


    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
        var filters = [String: AnyObject]()
        
        var selectedCategories = [String]()
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(catergories[row]["code"]!)
            }
        }
        
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories
        }
        
        
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
    }
    
}
