//
//  SortVC.swift
//  HomeEassy
//
//  Created by Macbook on 21/08/23.
//

import UIKit
protocol SortDelegate : NSObjectProtocol {
    func didSelectSort(_ sortId : SortOption?)
}

struct SortOption:Equatable{
    var sortingKey:String
    var reverse:Bool
    var title:String
    static func getAllSortOption()->[SortOption]{
        var sort=[SortOption]()
        sort.append(SortOption(sortingKey: "RELEVANCE", reverse: false, title: "Relevance"))
        sort.append(SortOption(sortingKey: "PRICE", reverse: false, title: "Price-low to High"))
        sort.append(SortOption(sortingKey: "PRICE", reverse: true, title: "Price-High to low"))
        sort.append(SortOption(sortingKey: "BEST_SELLING", reverse: false, title: "Best Selling"))
        
        sort.append(SortOption(sortingKey: "TITLE", reverse: false, title: "Title"))
        return sort
    }
}

let KSortCell = "SortCell"
class SortVC: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    var arrTitle = ["first","second","third"]
    weak var delegate : SortDelegate?
    var sortOptions = SortOption.getAllSortOption()
      var seletedSort : SortOption?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: KSortCell, bundle: nil), forCellReuseIdentifier: KSortCell)
        
    }
    func setData(seleted : SortOption?){
        seletedSort = seleted
    }
}
    
extension SortVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KSortCell) as! SortCell
        if let cell = cell as? SortCell {

            if let sortOption = sortOptionAt(indexPath.row) {
               cell.lblSortTitle?.text = sortOption.title
                    cell.btnSelSort?.isSelected = (sortOption == seletedSort)
            }
        }
        return cell
    }
    
    func sortOptionAt(_ index : Int) -> SortOption?{
        var sortOption : SortOption?
        if sortOptions.count > index {
            sortOption = sortOptions[index]
        }
        return sortOption
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true){
            self.delegate?.didSelectSort(self.sortOptionAt(indexPath.row))
        }
     
    }
}
