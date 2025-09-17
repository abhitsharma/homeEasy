//
//  FilterViewControler.swift
//  HomeEassy
//
//  Created by Macbook on 23/11/23.
//

import UIKit
protocol FilterHandler : NSObjectProtocol {
    func applyFilters(_ filters : [String:[String]],flag:Bool)
}
class FilterViewControler: BaseVC {
    @IBOutlet weak var leftTableView : UITableView?
    @IBOutlet weak var rightTableView : UITableView?
    var currentSeletcedIndex = IndexPath(row: 0, section: 0)
    weak var filterHandler : FilterHandler?
    var selectedFilters = [String:[String]]()
    var filters:[ProductFilter]?
    var values :[ProductFilterValue]?
    var index:Int = 0
    @IBOutlet weak var lblFilter: UILabel?
    @IBOutlet weak var btnClear: UIButton?
    @IBOutlet weak var btnApply: UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.rightTableView?.registerNibName("FilterOptionCell", forCellWithReuseIdentifier: "FilterOptionCell")
        self.leftTableView?.registerNibName("FilterTypeTableCell", forCellWithReuseIdentifier: "FilterTypeTableCell")
        leftTableView?.delegate = self
        leftTableView?.dataSource = self
        rightTableView?.delegate = self
        rightTableView?.dataSource = self
    }
    
    func setData(filters:[ProductFilter],selectedFilters:[String:[String]]){
        self.filters = filters
        self.selectedFilters = selectedFilters
        self.values = filters[index].values
    }
    
    func refreshView(){
        rightTableView?.reloadData()
        leftTableView?.reloadData()
    }
    
    @IBAction func applyFilters() {
      self.dismiss(animated: true) {
          self.filterHandler?.applyFilters(self.selectedFilters, flag: true)
      }
    }
    
    @IBAction func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
 
    
    @IBAction func clearAllFilters() {
        index = 0
        values = filters?[0].values
        selectedFilters.removeAll()
        self.filterHandler?.applyFilters(self.selectedFilters, flag: false)
        refreshView()

    }
    
    func updateSelectedFilter(_ indexPath: IndexPath, shouldAdd: Bool, filter: ProductFilter) {
        guard let filterTypeLabel = filter.label else {
            return
        }

        if let filterValueId = filter.values?[indexPath.row].label {
            var values = selectedFilters[filterTypeLabel] ?? []

            if shouldAdd {
                values.append(filterValueId)
            } else {
                values.removeAll { $0 == filterValueId }
            }
            selectedFilters[filterTypeLabel] = values.isEmpty ? nil : values
        }
    }

    
    func getSelectedValue(for filter: ProductFilter) -> Int {
        guard let selectedValues = selectedFilters[filter.label ?? ""] else {
            return 0
        }

        return filter.values?.reduce(0) { count, filterValue in
            return selectedValues.contains(filterValue.label ) ? count + 1 : count
        } ?? 0
    }


    }



extension FilterViewControler:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTableView{
            return filters!.count
        }
       else if tableView == rightTableView{
           return values!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == leftTableView{
            let cell  = tableView.dequeueReusableCell(withIdentifier: "FilterTypeTableCell",for: indexPath) as! FilterTypeTableCell
            cell.lblFilter.text = filters?[indexPath.row].label
            values = filters?[index].values!
            let count = getSelectedValue(for:(filters?[indexPath.row])!)
            if count != 0{
                cell.lblCount.text = "\(count)"
            } else {
                cell.lblCount.text = ""
            }
            if index == indexPath.row{
                cell.backgroundColor = .white
                //UIColor(named: "CustomBlack")
                cell.lblFilter.textColor = .black
                cell.lblCount.textColor = .darkGray
            }
            else{
                cell.backgroundColor = .clear
                cell.lblFilter.textColor = .black
                            cell.lblCount.textColor = .darkGray
            }
            //index = indexPath.row
            return cell
        }
        else  if tableView == rightTableView{
            let cell  = tableView.dequeueReusableCell(withIdentifier: "FilterOptionCell",for: indexPath) as! FilterOptionCell
            guard let filterValue = values?[indexPath.row] else {
                return UITableViewCell()
            }
            cell.lblfilter?.text = filterValue.label
            let isSelected = selectedFilters[filters?[index].label ?? ""]?.contains(filterValue.label ) ?? false
            cell.flag = isSelected
           if values?[indexPath.row].label == "In stock" || values?[indexPath.row].label == "Out of stock"{
                if  filterValue.count == 0 {
                    cell.isUserInteractionEnabled = false
                    cell.backgroundColor = .lightGray
                    cell.isHidden = true
                   
                }
                else {
                    cell.isUserInteractionEnabled = true
                    cell.backgroundColor = .clear
                    cell.isHidden = false
                   
                }
            }
            else{
                cell.isUserInteractionEnabled = true
                cell.backgroundColor = .clear
                cell.isHidden = false
             
            }
            cell.btnSel?.isSelected = isSelected
            cell.btnSel?.isUserInteractionEnabled = false
            cell.lblfilter!.text = values?[indexPath.row].label
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == leftTableView || tableView == rightTableView{
            return UITableView.automaticDimension
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == leftTableView{
            self.index = indexPath.row
            values = filters?[index].values!
            refreshView()
        }
       else  if tableView == rightTableView{
           let filter = filters?[index]
           values = filters?[index].values!
           let filterValue = values?[indexPath.row]
           let isSelected = selectedFilters[filters?[index].label ?? ""]?.contains(filterValue?.label ?? "") ?? false
           updateSelectedFilter(indexPath, shouldAdd: !isSelected, filter: filter!)
          refreshView()
        }
    }
    
}


