//
//  VarientSelectedCell.swift
//  HomeEassy
//
//  Created by Macbook on 27/09/23.
//

import UIKit
protocol upDateSelectedDelegate{
    func selectedVarint(selctedIndex:Int,selName:String!)
}

let kVarientSelCells = "VarientSelCells"

class VarientSelectedCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var options:OptionViewModel!
    var delegate: upDateSelectedDelegate?
    var selIndex:Int!
    var disableCellFlag:Bool!
    var disableCellIndex:Int!
    var indexPath = IndexPath()
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var collectionView:UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.register(UINib.init(nibName: kVarientSelCells, bundle: nil), forCellWithReuseIdentifier: kVarientSelCells)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setData(currentIndex:Int,flag:Bool){
        selIndex = currentIndex
        disableCellFlag = flag
        self.disableCellIndex = currentIndex
        collectionView.reloadData()
        indexPath = IndexPath(item: currentIndex, section: 0)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.values.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kVarientSelCells, for: indexPath) as! VarientSelCells
            let obj = options.values[indexPath.row]
        cell.lblName.text = obj
        if disableCellFlag == true && options.name == "Size" && indexPath.row == disableCellIndex{
           // cell.desel(value: obj, selectedValue: options.SelectedValue!)
            cell.view.backgroundColor = UIColor(named: "CustomGrey")
            cell.view.borderColor = UIColor(named: "CustomGrey")
            cell.lblName.textColor = .black
            cell.lblName.font = UIFont(name: NiveauGrotesk.regular.rawValue, size: 12)
            cell.isSelected = false
            if let selectedItems = collectionView.indexPathsForSelectedItems {
                for indexPath in selectedItems {
                    collectionView.deselectItem(at: indexPath, animated: false)
                }
            }
            cell.isUserInteractionEnabled = false
            //collectionView.deselectItem(at: indexPath, animated: true)
        }
        else{
            cell.updateSel(value: obj, selectedValue: options.SelectedValue ?? "")
            cell.isUserInteractionEnabled = true
        }
            return cell
        

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellText = options.values[indexPath.item]
           let cellWidthPadding: CGFloat = 5
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 10
        let sectionSpacing = layout.sectionInset.left + layout.sectionInset.right
        var width = cellText.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]).width + cellWidthPadding
        if width <= 30{
            width = 55
        }
        else{
            width += 20
        }
        return CGSize(
           width: width, height: 30
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if disableCellFlag == true && options.name == "Size" && indexPath.row == disableCellIndex{
            collectionView.deselectItem(at: indexPath, animated: true)

        }
        else{
            let selectedValue = self.options.values[indexPath.item]
            delegate?.selectedVarint(selctedIndex:selIndex, selName:selectedValue)
        }
        
    }

}
