//
//  OrderHistoryVC.swift
//  HomeEassy
//
//  Created by Macbook on 12/09/23.
//

import UIKit
let KOrdersViewCell = "OrdersViewCell"
class OrderHistoryVC: BaseVC {
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var imgNoData:UIImageView!
    @IBOutlet weak var lblNoData:UILabel!
    @IBOutlet weak var lblSubTitle:UILabel!
    @IBOutlet weak var viewNoData:UIView!
    @IBOutlet weak var btnShopping:UIButton!
    var orders : PageableArray<OrderViewModel>?
    let orderHistoryVM:OrderHistoryVMDelgate = OrderHistoryVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        //setNavigationBarTitle("Orders",inMiddle: false)
        self.tableView.register(UINib.init(nibName: KOrdersViewCell, bundle: nil), forCellReuseIdentifier: KOrdersViewCell)
        self.viewNoData.isHidden = true
        self.btnShopping.isHidden = true
        self.lblNoData.text = "UH oh, you have no orders"
        self.lblSubTitle.text = "Let's fix that right away. Shop your favourites brands now."
        imgNoData?.image = UIImage(named: "noOrderHistory")
        //fetchData()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        setNavigationBarTitle("Order History",inMiddle: true)
    }
    
    func fetchData(){
        showLoader()
        orderHistoryVM.fetchOrderHistory(){container in
            if let container = container {
                if let _ = self.orders{
                    self.orders?.appendPage(from: container)
                }else{
                    if container.items.count > 0{
                        self.orders = container
                        self.tableView.dataSource = self
                        self.tableView.delegate = self
                        self.viewNoData.isHidden = true
                        self.btnShopping.isHidden = true
                        self.tableView.reloadData()
                    }
                    else{
                        self.viewNoData.isHidden = false
                        self.btnShopping.isHidden = false
                    }
                }
            }
            self.dismissLoader()
        }
    }
    
    @IBAction func actionStartShopping(_ sender: Any) {
        tabBarController?.selectedIndex = 0
        navigationController?.popToRootViewController(animated: true)
    }
}

extension OrderHistoryVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders?.items.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KOrdersViewCell) as! OrdersViewCell
        let obj = orders?.items[indexPath.row]
        cell.setObj(obj: obj!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = StoryBoardHelper.controller(.live, type: OrderDetailVC.self)
        let obj = orders?.items[indexPath.row]
        vc?.orderDetail = obj
        navigationController?.pushViewController(vc!, animated: true)
        
    }
    
 
 
}
