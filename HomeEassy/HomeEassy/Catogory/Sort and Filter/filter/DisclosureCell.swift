//
//  DisclosureCell.swift
//  KoovsOnlineFashion
//
//  Created by Koovs on 16/09/16.
//  Copyright © 2016 Koovs. All rights reserved.
//

import Foundation
import UIKit

private let padding : CGFloat = 16.0
private let fixedPadding : CGFloat = 16.0

class DisclosureCell : UITableViewCell {
  @IBOutlet weak var titleLabel : UILabel?
  @IBOutlet weak var seperatorLabel : UILabel?
  @IBOutlet weak var countLabel : UILabel?
  @IBOutlet weak var disclosureImage : UIImageView?
  @IBOutlet weak var iconImageView : UIImageView?
  @IBOutlet weak var leftConstraint : NSLayoutConstraint?
  @IBOutlet weak var rightSeperatorView : UIView?
  @IBOutlet weak var topSeperatorView : UILabel?
  @IBOutlet weak var bottomSeperatorView : UILabel?
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if countLabel != nil {
      countLabel?.layer.cornerRadius = countLabel!.frame.height/2
      countLabel?.layer.masksToBounds = true
    }}
 
}
