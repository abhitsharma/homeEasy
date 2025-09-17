//
//  AccountViewController.swift
//  HomeEassy
//
//  Created by Swatantra singh on 29/07/23.
//

import UIKit

protocol LogOutDelegate{
    func logOutUpdate()
}
enum accountKey: String, CaseIterable {
    case OrderHistory = "Order History"
    case addressBook = "Address book"
    case aboutUs = "About us"
    case contactUs = "Contact us"
    case termCondition = "Terms and Condition"
    case disclaimer = "Disclaimer"
    case regulatoryInformation = "Regulatory Information"
    case security = "Security"
    case refundPolicy = "Refund Policy"
    
}
enum accountImgKey: String, CaseIterable {
    case OrderHistory = "orderHistory"
    case addressBook = "addressbook"
    case aboutUs = "about us"
    case contactUs = "Contact us"
    case termCondition = "Terms and Condition"
    case disclaimer = "Disclaimer"
    case regulatoryInformation = "Regulatory Information"
    case security = "Security"
    case refundPolicy = "Refund Policy"
}
let KProfileTableViewCell = "ProfileTableViewCell"
let KProfileHeaderCell = "ProfileHeaderCell"
let KLogoutFooterView = "LogoutFooterView"

class AccountViewController: BaseVC{
    @IBOutlet weak var tableView:UITableView!
    var arrList = ["Order History","Address Book","About us","Contact us","Terms and Condition","Refund Policy"]
    var arrImg = ["orderHistory","address book","setting"]
    var customerDetail:CustomerViewModel!
    let loginBaseViewModel:LoginBaseDelgate = LoginBaseViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarTitle("My Account",inMiddle: true)
        fetchData()
        tableView.register(UINib.init(nibName: KProfileTableViewCell, bundle: nil), forCellReuseIdentifier: KProfileTableViewCell)
        tableView.registerNibName(KProfileHeaderCell, forCellHeaderFooter: KProfileHeaderCell)
        tableView.registerNibName(KLogoutFooterView, forCellHeaderFooter: KLogoutFooterView)
        
    }
    
    func fetchData(){
        if NetStatus.shared.isConnected{
            removeNoInternetConnection()
            showLoader()
            setUserData()
        }
        else{
            self.handleNoInternetConnection()
        }
    }
    
    func setUserData(){
        if AccountController.shared.accessToken != nil{
            if UserManger.shared.custname == nil{
                loginBaseViewModel.UserDetails{ [self] customerDetail in
                    if customerDetail != nil{
                        self.customerDetail = customerDetail!
                        UserManger.shared.saveUser(username: customerDetail!.displayName, phone: (customerDetail?.phoneNumber)!, email: (customerDetail?.email)!,firstname: customerDetail?.firstName,lastname: customerDetail?.lastName)
                    }
                    tableView.delegate = self
                    tableView.dataSource = self
                    tableView.reloadData()
                }
            }
            else{
                tableView.delegate = self
                tableView.dataSource = self
                tableView.reloadData()
            }
        }
            else{
                tableView.delegate = self
                tableView.dataSource = self
                tableView.reloadData()
            }
        dismissLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       fetchData()
        addNoNetworkView()
        setNavigationBarTitle("My Account",inMiddle: true)
        addSideMenu()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeSideMenu()
    }
    
@objc func actionEdit() {
    let vc = storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController" ) as! EditProfileViewController
    //vc.customer = customerDetail
    navigationController?.pushViewController(vc, animated: true)
}

@objc func actionLogin() {
    let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC" )
    navigationController?.pushViewController(vc!, animated: true)
}

@objc func actionSignup() {
    let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController" )
    navigationController?.pushViewController(vc!, animated: true)
}


    
@IBAction func ActionLogOut(_ sender: Any) {
    guard let accessToken = AccountController.shared.accessToken else {
        return
    }
    
    Client.shared.logout(accessToken: accessToken) {  success in
        if success {
            AccountController.shared.deleteAccessToken()
            WishListController.shared.deleteUserId()
        }
    }

}
}

extension AccountViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountKey.allCases.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: KProfileHeaderCell) as! ProfileHeaderCell
        header.Delegate = self
        if AccountController.shared.accessToken != nil && AccountController.shared.accessToken != "" && UserManger.shared.custname != nil {
            header.setupCell()
        }
        else{
            header.setupNoLogin()
        }
            return header
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: KLogoutFooterView) as! LogoutFooterView
        if AccountController.shared.accessToken != nil && AccountController.shared.accessToken != "" && UserManger.shared.custname != nil {
            footer.Delegate = self
            footer.BtnLogout.isHidden = false
            footer.BtnLogout.isEnabled = true
        }
        else{
            footer.BtnLogout.isHidden = true
            footer.BtnLogout.isEnabled = false
        }
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            footer.lblVersion.text = "version: \(appVersion)"
            
        }
        return footer
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KProfileTableViewCell) as! ProfileTableViewCell
        cell.title?.text = accountKey.allCases[indexPath.row].rawValue
       // if indexPath.row < 2{
            cell.img.image = UIImage(named: accountImgKey.allCases[indexPath.row].rawValue)
      //  }
        return cell
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedValue = accountKey.allCases[indexPath.row]
        if AccountController.shared.accessToken != nil && AccountController.shared.accessToken != ""{
            switch selectedValue {
            case .addressBook:
                let vc = storyboard?.instantiateViewController(withIdentifier: "AddressViewController" )
                vc!.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc!, animated: true)
            case .OrderHistory:
                let vc = storyboard?.instantiateViewController(withIdentifier: "OrderHistoryVC" )
                vc!.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc!, animated: true)
            case .termCondition:
                if let webVC = StoryBoardHelper.controller(.main, type: WebViewController.self){
                    webVC.webViewUrl = "https://c63730-2.myshopify.com/pages/terms-and-condition"
                    webVC.title = "Track Order"
                    navigationController?.pushViewController(webVC, animated: true)
                }
            case .refundPolicy:
                if let webVC = StoryBoardHelper.controller(.main, type: WebViewController.self){
                    webVC.webViewUrl = "https://c63730-2.myshopify.com/pages/refund-policy"
                    webVC.title = "Track Order"
                    navigationController?.pushViewController(webVC, animated: true)
                }
            case .aboutUs:
                if let webVC = StoryBoardHelper.controller(.main, type: WebViewController.self){
                    webVC.webViewUrl = "https://c63730-2.myshopify.com/pages/about"
                    webVC.title = "Track Order"
                    navigationController?.pushViewController(webVC, animated: true)
                }
            case .contactUs:
                if let webVC = StoryBoardHelper.controller(.main, type: WebViewController.self){
                    webVC.webViewUrl = "https://c63730-2.myshopify.com/pages/contact"
                    webVC.title = "Track Order"
                    navigationController?.pushViewController(webVC, animated: true)
                }
            case .disclaimer:
                if let webVC = StoryBoardHelper.controller(.main, type: WebViewController.self){
                    webVC.webViewUrl = "https://c63730-2.myshopify.com/pages/disclaimer"
                    webVC.title = "Track Order"
                    navigationController?.pushViewController(webVC, animated: true)
                }
            case .regulatoryInformation:
                if let webVC = StoryBoardHelper.controller(.main, type: WebViewController.self){
                    webVC.webViewUrl = "https://c63730-2.myshopify.com/pages/regulatory-information"
                    webVC.title = "Track Order"
                    navigationController?.pushViewController(webVC, animated: true)
                }
            case .security:
                if let webVC = StoryBoardHelper.controller(.main, type: WebViewController.self){
                    webVC.webViewUrl = "https://c63730-2.myshopify.com/pages/security-information"
                    webVC.title = "Track Order"
                    navigationController?.pushViewController(webVC, animated: true)
                }
                
            default:
                print("no row is selected")
            }
        }
        else{
            let vc = StoryBoardHelper.controller(.live, type: LoginVC.self)
            vc!.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension AccountViewController:selectDelegate{
    func edit(flag: Bool) {
        if flag{
            let vc = storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController" ) as! EditProfileViewController
            //vc.customer = customerDetail
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            tableView.reloadData()
        }
    }
    
    func signUp(flag: Bool) {
        if flag{
            let vc = StoryBoardHelper.controller(.live, type: SignUpViewController.self)
            vc!.hidesBottomBarWhenPushed = true
            vc!.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: true)
            setUserData()
            tableView.reloadData()
        }
        
    }
    
    func login(flag: Bool) {
        if flag{
            let vc = StoryBoardHelper.controller(.live, type: LoginVC.self)
            vc!.hidesBottomBarWhenPushed = true
            vc!.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: true)
    
        }
    }
    
}

extension AccountViewController: selectLogout {
    func logout(flag: Bool) {
        if flag{
            AppHelper.sharedInstance.showAlertView(title: "HOMEEASSY", message: "Are you sure to logout?", cancelButtonTille: "No", otherButtonTitles: "Yes"){ data in
                if data == "2"{
                    guard let accessToken = AccountController.shared.accessToken else {
                        return
                    }
                    Client.shared.logout(accessToken: accessToken) { [self]success in
                        if success {
                            UserManger.shared.removeAllUserSetting()
                            tableView.reloadData()
                            removeSideMenu()
                            setUserData()
                            addSideMenu()
                        }
                    }
                }
            }
        }
    }
}

extension AccountViewController : NoInternetHandler {
    func retryAction(object : Any?) {
        if NetStatus.shared.isConnected {
        removeNoInternetConnection()
        setUserData()
            tableView.reloadData()
        }
    }
}
