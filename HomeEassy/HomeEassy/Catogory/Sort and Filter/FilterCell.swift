//
//  FilterCell.swift
//  KoovsOnlineFashion
//
//  Created by Koovs on 17/11/16.
//  Copyright © 2016 Koovs. All rights reserved.
//

import Foundation
import UIKit



class FilterCell : UITableViewCell {
    @IBOutlet weak var selectionView : UIImageView?
    @IBOutlet weak var titleLabel : UILabel?
    @IBOutlet weak var countLabel : UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCell.SelectionStyle.none
      
    }
    
    func isFilterSelected(_ selected : Bool, quantityAvailable : Bool = true) {
        let canSelect = (selected || quantityAvailable)
        selectionView?.alpha = canSelect ? 1 : 0.5
        titleLabel?.alpha = canSelect ? 1 : 0.5
        countLabel?.alpha = canSelect ? 1 : 0.5
      if quantityAvailable==false{
        selectionView?.alpha = quantityAvailable ? 1 : 0.5
        titleLabel?.alpha = quantityAvailable ? 1 : 0.5
        countLabel?.alpha = quantityAvailable ? 1 : 0.5
      }

    }
    
}
