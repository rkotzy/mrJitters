//
//  SearchCell.swift
//  mrJitters
//
//  Created by Ryan Kotzebue on 6/7/16.
//  Copyright © 2016 Ryan Kotzebue. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var address: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
