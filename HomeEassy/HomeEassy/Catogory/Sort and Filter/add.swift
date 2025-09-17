//
//  FilterVC.swift
//  HomeEassy
//
//  Created by Macbook on 25/08/23.
//

import UIKit

class add: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    var isExpand:Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "FilterTableCell", bundle: nil), forCellReuseIdentifier: "FilterTableCell")
        tableView.registerNibName("FilterHeaderView", forCellHeaderFooter: "FilterHeaderView")
    }
    
}

extension add:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
      
        case 0:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FilterHeaderView") as! FilterHeaderView
            header.delegate = self
            header.lblTitle.text = "Price"
            return header
        case 1:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FilterHeaderView") as! FilterHeaderView
            header.delegate = self
            header.lblTitle.text = "Category"
            return header
        case 2:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FilterHeaderView") as! FilterHeaderView
            header.delegate = self
            header.lblTitle.text = "Size"
            return header
        default:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FilterHeaderView") as! FilterHeaderView
//            MatchInfoVC.headersection = section
        }
        
       return UIView()

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableCell") as! FilterTableCell
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
            if  isExpand == true{
                if indexPath.section == 0{
                    return 50
                }
            }
            else
            {
                return 0
            }
           
        
        return 0
    }
    
}

extension add:btnSelected{
    func Selected(bool: Bool) {
        isExpand = bool
        tableView.reloadData()
    }
    
    
}
