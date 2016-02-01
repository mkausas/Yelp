//
//  BusinessCell.swift
//  Yelp
//
//  Created by Martynas Kausas on 1/31/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var catergoriesLabel: UILabel!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    
    var business: Business! {
        didSet {
            nameLabel.text = business.name
            thumbImageView.setImageWithURL(business.imageURL!)
            catergoriesLabel.text = business.categories
            addressLabel.text = business.address
            reviewsCountLabel.text = business.address
            reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
            ratingImageView.setImageWithURL(business.ratingImageURL!)
            distanceLabel.text = business.distance
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // rounded edges on photo
        thumbImageView.layer.cornerRadius = 5
        thumbImageView.clipsToBounds = true
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width

    }
    
    // for rotating the screen
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        
    }
    
}
