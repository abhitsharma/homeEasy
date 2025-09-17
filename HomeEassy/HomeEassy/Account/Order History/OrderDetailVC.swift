//
//  OrderDetailVC.swift
//  HomeEassy
//
//  Created by Macbook on 12/09/23.
//

import UIKit
let KOrderDetailViewCell = "OrderDetailViewCell"
let KOrderDetailHeader = "OrderDetailHeader"
class OrderDetailVC: BaseVC, trackOrderDelegate {
  
    
    var orderDetail:OrderViewModel!
    @IBOutlet weak var tableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: KOrderDetailViewCell, bundle: nil), forCellReuseIdentifier: KOrderDetailViewCell)
        tableView.registerNibName(KOrderDetailHeader, forCellHeaderFooter: KOrderDetailHeader)
        self.tableView.dataSource = self
        self.tableView.delegate = self
     
    }

}

extension OrderDetailVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderDetail.lineItems.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KOrderDetailViewCell) as! OrderDetailViewCell
        let obj = orderDetail.lineItems[indexPath.row]
        cell.setData(obj: obj)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = StoryBoardHelper.controller(.category, type: ProductDetailVC.self)
        let obj = orderDetail.lineItems[indexPath.row]
        if obj.productID != nil && obj.productID != ""{
            vc?.productId = obj.productID
            navigationController?.pushViewController(vc!, animated: true)
        }
        else{
            self.view.makeToast("There is an error")
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: KOrderDetailHeader) as! OrderDetailHeader
        header.setObj(obj: orderDetail)
        header.delegate = self
        return header
    }
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 180
        
    }
    
    func trackOrder(urlTrack: String, title: String) {
        if let webVC = StoryBoardHelper.controller(.main, type: WebViewController.self){
            webVC.webViewUrl = urlTrack
            webVC.title = "Track Order"
            navigationController?.pushViewController(webVC, animated: true)
        }
    }
}
