//
//  SwitchCell.swift
//  Yelp
//
//  Created by Martynas Kausas on 1/31/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

// protocol is
@objc protocol SwitchCellDelegate {
    optional func switchCell(switchCell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!

    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        onSwitch.addTarget(self, action: "switchValueChanged", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func switchValueChanged() {
        // if delegate is not nil -> call switchCell method if implemented
        delegate?.switchCell?(self, didChangeValue: onSwitch.on)
    }
    

}
