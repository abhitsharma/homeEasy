//
//  AddressViewController.swift
//  Storefront
//
//  Created by Macbook on 08/08/23.
//  Copyright © 2023 Shopify Inc. All rights reserved.
//

import UIKit
let KAddressTableViewCell = "AddressTableViewCell"
let KheaderAddressView = "headerAddressView"
 
class AddressViewController: BaseVC{
   
    @IBOutlet weak var tableView:UITableView!
    var addressList = [AddressViewModel]()
    var defaultAddress : AddressViewModel!
    var accountBool:Bool!
    var addressBaseVM:AddressBaseDelegate = AddressBaseVM()
    override func viewDidLoad() {
        super.viewDidLoad()
       getUserData()
        tableView.register(UINib.init(nibName: "AddressTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressTableViewCell")
        tableView.registerNibName("headerAddressView", forCellHeaderFooter: "headerAddressView")
        tableView.reloadData()
        let barButtonItem = UIBarButtonItem(title: "+ Add Address", style: .plain, target: self, action: #selector(actionAdd))

        // Create a dictionary with the desired font attributes
        let fontAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: NiveauGrotesk.Medium.rawValue, size: 15)!
        ]

        barButtonItem.setTitleTextAttributes(fontAttributes, for: .normal)
        navigationItem.rightBarButtonItem = barButtonItem
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "CustomBlack")
    
        
    }
    
    @objc func actionAdd() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddAddressVC" )
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func getUserData(){
        self.defaultAddress = nil
        self.addressList = []
        showLoader()
        addressBaseVM.processAllAdress(accesstoken: AccountController.shared.accessToken!){ defaultAddress,allAdress  in
            if defaultAddress != nil {
            self.defaultAddress = defaultAddress
            }
            self.addressList = allAdress!
            self.dismissLoader()
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserData()
        setNavigationBarTitle("Address Book",inMiddle: true)
    }
    

   
}

extension AddressViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        if section == 0{
           
              if defaultAddress != nil {
                  rows = 1
                  return rows
              }
        }
        else{
            rows = addressList.count
            return rows
        }
       return rows
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if  defaultAddress != nil
        {
            return 2
        }
        else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return UITableView.automaticDimension
        }
        else{
            return UITableView.automaticDimension
        }
        //return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: KAddressTableViewCell) as! AddressTableViewCell
            cell.setupCell(obj: defaultAddress!)
            cell.lblDefault.isHidden = false
            cell.Delegate = self
            cell.btnMarkAsDefault.isHidden = true
            cell.DelegateController = self
            return cell
        }
        else{
            let obj = addressList[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: KAddressTableViewCell) as! AddressTableViewCell
            cell.lblDefault.isHidden = true
            cell.btnMarkAsDefault.isHidden = false
            cell.setupCell(obj: obj)
            cell.Delegate = self
            cell.address = obj
            cell.DelegateController = self
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section{
        case 0:
            return 25
        case 1:
            return 25
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        
        switch section {
      
        case 0:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: KheaderAddressView) as! headerAddressView
            header.lblTitle.text = "Default Address"
            return header
        case 1:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: KheaderAddressView) as! headerAddressView
            header.lblTitle.text = "All Address"
            return header
            
        default:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: KheaderAddressView)
        }
        
       return UIView()

    }
}

extension AddressViewController: selectAction{
    func NextController(flag: Bool, address:AddressViewModel) {
        if flag{
            let vc = storyboard?.instantiateViewController(withIdentifier: "EditAddressVC" ) as! EditAddressVC
            vc.address = address
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension AddressViewController:ReloadTable{
    func getData(flag: Bool, delete: Bool,id:String) {
        if flag{
            if delete{
                AppHelper.sharedInstance.showAlertView(title: "HOMEEASSY", message: "Do You Want To Delete This Address?", cancelButtonTille: "No", otherButtonTitles: "Yes"){ data in
                    if data == "2"{
                        Client.shared.deleteUserAddress(accesstoken: AccountController.shared.accessToken, id: id){ respone in
                            let error = respone?.customerAddressDelete?.customerUserErrors.first?.message
                            if error == nil || error == ""{
                                self.view.makeToast("Your Address Has Been Deleted Succfully")
                                self.getUserData()
                            }
                            else {
                                self.view.makeToast("Failed to delete address")
                            }
                            self.getUserData()
                        }
                    }
                }
                getUserData()
            }
            getUserData()
        }
        
    }
}

