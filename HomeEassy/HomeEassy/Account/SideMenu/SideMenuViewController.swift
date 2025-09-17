//
//  SideMenuViewController.swift
//  CustomSideMenuiOSExample
//
//  Created by John Codeos on 2/7/21.
//

import UIKit
import UIKit
protocol SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int,id:String,title:String)
}
class SideMenuViewController: UIViewController {
    @IBOutlet var sideMenuTableView: UITableView!
    @IBOutlet var footerLabel: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail:UILabel!
    @IBOutlet weak var imgUser:UIImageView!
    let loginBaseViewModel:LoginBaseDelgate = LoginBaseViewModel()
    var menuItems: MenuViewModel?
    var delegate: SideMenuViewControllerDelegate?
    var menuItemsViewModel:MenuViewModelProtocol  = MenuItemsViewModel()
    var defaultHighlightedCell: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        self.sideMenuTableView.backgroundColor = UIColor(named: "CustomGrey")
        self.sideMenuTableView.separatorStyle = .none
        self.footerLabel.textColor = UIColor.black
        //self.footerLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        self.footerLabel.text = "VERSION: 1.0.2"
        bindDataModel()
        // Register TableView Cell
        self.sideMenuTableView.delegate = self
        self.sideMenuTableView.dataSource = self
        self.sideMenuTableView.register(SideMenuCell.nib, forCellReuseIdentifier: SideMenuCell.identifier)
        Client.shared.fetchMenu(){ item in
            self.menuItems = item
            self.sideMenuTableView.delegate = self
            self.sideMenuTableView.dataSource = self
       }
        // Update TableView with the data
        self.sideMenuTableView.reloadData()
    }
    
    func bindDataModel() {
        menuItemsViewModel.apiCallBack = { [weak self] in
            guard let self = self else {return}
            self.sideMenuTableView?.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
       fetchData()
    }
    
    func fetchData(){
        lblName.text = ""
        lblEmail.text = ""
        menuItemsViewModel.fetchCollections()
        if NetStatus.shared.isConnected{
            if AccountController.shared.accessToken != nil{
                loginBaseViewModel.UserDetails{ [self] customerDetail in
                    if customerDetail != nil{
                        lblName.text = "Hi " + (customerDetail?.firstName ?? "")
                        lblEmail.text = customerDetail?.email
                        imgUser.placeholderImage(customerDetail!.displayName, size: CGSize(width: 64, height: 64))
                    }
                    else {
                        lblName.text = ""
                        lblEmail.text = ""
                        //imgUser.image = UIImage(named: "defaultImage")
                    }
                }
//                Client.shared.fetchMenu(){ item in
//                    self.menuItems = item
//               }
                // Update TableView with the data
                self.sideMenuTableView.reloadData()
            }
            else{
                lblName.text = ""
                lblEmail.text = ""
            }
        }  else {
            lblName.text = ""
            lblEmail.text = ""
        }
    }
}


extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension SideMenuViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        menuItemsViewModel.widgets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuItemsViewModel.widgets?.first!.widgetData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let item = menuItemsViewModel.widgets?.first!.widgetData![indexPath.row]{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as? SideMenuCell else { fatalError("xib doesn't exist") }
            cell.titleLabel.text = item.title
        return cell
    }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
    

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.menuItemsViewModel.widgets?.count ?? 0
//    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as? SideMenuCell else { fatalError("xib doesn't exist") }
//
//     //   cell.iconImageView.image = self.menu[indexPath.row].icon
//        cell.titleLabel.text = self.menuItemsViewModel.widgets.
//        // Highlighted color
////        let myCustomSelectionColorView = UIView()
////        myCustomSelectionColorView.backgroundColor = .white
////        myCustomSelectionColorView.cornerRadius = 8
////
////        cell.selectedBackgroundView = myCustomSelectionColorView
//        return cell
//    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = menuItemsViewModel.widgets?.first!.widgetData![indexPath.row]{
            self.delegate?.selectedCell(indexPath.row, id: item.id, title: item.title)
    }
        // Remove highlighted color when you press the 'Profile' and 'Like us on facebook' cell
        if indexPath.row == 4 || indexPath.row == 6 {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
