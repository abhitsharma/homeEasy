//
//  DataPickerViewController.swift
//  FITOPPO
//
//  Created by swatantra on 2/8/17.
//  Copyright © 2017 swatantra. All rights reserved.
//

import UIKit
import Foundation
let kFiterMatchCartCell = "FiterMatchCartCell"

enum SelectionOptions: String {
    case SEL_NONE, SEL_SRCH, east, west, categoriesName, SEL_SRCH_CITY , SEL_CAT
}


typealias  DidSelectItems = ((_ selectedvalues: [Any]) -> Void)

class DataPickerViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource   {
    var fromFilter = false
    @IBOutlet weak var clooectionViewHeight: NSLayoutConstraint!
    var selectedRows = [Any]()
    var mainDataSourceArray = [Any]()
    var dataSourceArray = [Any]()
    
    @IBOutlet weak var tableViewConstraintsY: NSLayoutConstraint!
    var selectionType = SelectionOptions.SEL_NONE
    
    @IBOutlet weak var dataTableView: UITableView?
    var selectItems : DidSelectItems!
    var isSingleSelectionCriteria: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataTableView?.reloadData()
        dataTableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.registerCell()
    }
    
    func registerCell() {
        self.dataTableView?.separatorStyle = .none
        self.dataTableView?.register(UINib(nibName: kFiterMatchCartCell, bundle: nil), forCellReuseIdentifier: kFiterMatchCartCell)

    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        dataTableView?.tableFooterView = UIView()
        self.dataTableView?.reloadData()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addPopUp( isSingleSelection: Bool, dataSource: [Any], withSelectedDataSourceRows selectedDataSourceRows: [Any], selectionType type: SelectionOptions, andSelectedValuesCallBack selectedItemsCallBack: @escaping DidSelectItems){
        self.selectItems = selectedItemsCallBack
        self.dataSourceArray = dataSource
        self.mainDataSourceArray = dataSource
        self.selectedRows = selectedDataSourceRows
        self.isSingleSelectionCriteria = isSingleSelection
        selectionType = type
        self.dataTableView?.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if fromFilter {
        return 70
            
        }else {
        return UITableView.automaticDimension

        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isSingleSelectionCriteria {
            selectedRows.removeAll()
            selectedRows.append(self.dataSourceArray[indexPath.row])
        }
        else {
            
        }
        
        //tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        
        self.dismiss(animated: true, completion: {   self.selectItems(self.selectedRows) })
        
    }
    
    @IBAction func tapGestureAction(_ sender: Any) {
        self.dismiss(animated: true, completion: {  })
        
    }
}







