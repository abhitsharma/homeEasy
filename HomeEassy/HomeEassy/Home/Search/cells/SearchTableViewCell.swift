//
//  SearchTableViewCell.swift
//  HomeEassy
//
//  Created by Macbook on 15/09/23.
//

import UIKit

protocol SearchHisoryDelegate{
    func searchPrevious(search:String)
}
let KSearchCollectionVCell = "SearchCollectionVCell"
class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView:UICollectionView!
    var arrSearchHistory:[String] = []
    var delegate:SearchHisoryDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        collectionView.register(UINib.init(nibName: KSearchCollectionVCell, bundle: nil), forCellWithReuseIdentifier: KSearchCollectionVCell)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    
    func fetchTrending(){
        let sortDescriptors = [NSSortDescriptor(key: "lastupdateDate", ascending: false)]
        let predicate=NSPredicate(format: "istrnding == %d", true)
        self.arrSearchHistory = persistentStorage.Shared.fetchTrendinfQueries(predicate: predicate, sortWith: sortDescriptors as NSArray?)!
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
    
    func fetchHisory(){
        
        arrSearchHistory =  persistentStorage.Shared.fetchSearchQueries()!
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
    
    func setData(obj:[String]){
        self.arrSearchHistory = obj
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension SearchTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return arrSearchHistory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KSearchCollectionVCell, for: indexPath) as! SearchCollectionVCell
        let obj = arrSearchHistory[indexPath.row]
        cell.setData(obj: obj)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj = arrSearchHistory[indexPath.row]
        delegate.searchPrevious(search: obj)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellText = arrSearchHistory[indexPath.item]
           let cellWidthPadding: CGFloat = 5
        var width = cellText.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]).width + cellWidthPadding
        if width <= 30{
            width = 55
        }
        return CGSize(
           width: width + 15, height: 30
        )
    }
    
}


extension SearchTableViewCell:UpdateSearchHistory{
    func updateSearch() {
    }
    
    
}
