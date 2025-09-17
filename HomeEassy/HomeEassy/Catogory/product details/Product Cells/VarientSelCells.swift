//
//  VarientSelCells.swift
//  HomeEassy
//
//  Created by Macbook on 27/09/23.
//

import UIKit

class VarientSelCells: UICollectionViewCell {
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var view:UIView!
    var indexpath:Int!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateSel(value:String, selectedValue:String){
        if value == selectedValue{
            lblName.textColor = .white
            view.backgroundColor = UIColor(named: "CustomBlack")
            view.cornerRadius = 5.0
            lblName.font = UIFont(name: NiveauGrotesk.Bold.rawValue, size: 12)
        }
        else{
            lblName.textColor = .black
            view.backgroundColor = .white
            lblName.font = UIFont(name: NiveauGrotesk.regular.rawValue, size: 12)
            view.cornerRadius = 5.0
        }
    }
    func desel(value:String, selectedValue:String){
        if value == selectedValue{
            lblName.textColor = .white
            view.backgroundColor = .brown
            view.cornerRadius = 5.0
            lblName.font = UIFont(name: NiveauGrotesk.regular.rawValue, size: 12)
        }
    }
}
