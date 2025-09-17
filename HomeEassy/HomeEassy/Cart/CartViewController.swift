//
//  CartViewController.swift
//  HomeEassy
//
//  Created by Swatantra singh on 29/07/23.
//

import UIKit
let KCartViewCell = "CartViewCell"
let KTotalFooterView = "TotalFooterView"

class CartViewController: BaseVC{
    var compareSaving:String = ""
    var TotalPrice:String = ""
    @IBOutlet weak var tableView:UITableView!
    var cartSubTotal = [[String:String]]()
    var  cartData:[CartItemViewModel]?
    var myCartHelper = CartViewModel()
    let collectionBaseVM: CollectionBaseDelegate = CollectionBaseVM()
    @IBOutlet weak var btnShopping:UIButton!
    @IBOutlet weak var viewNoData:UIView!
    @IBOutlet weak var lblSubtitle:UILabel!
    var arrFavProductId: [String] = []
    var flagWishlist: Bool!
    var proccedCartFlag:Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewNoData.isHidden = true
        tableView.register(UINib.init(nibName: KCartViewCell, bundle: nil), forCellReuseIdentifier: KCartViewCell)
        tableView.registerNibName(KTotalFooterView, forCellHeaderFooter: KTotalFooterView)
            fetchData()
      
    }
   
    func fetchData(){
        if NetStatus.shared.isConnected{
            showLoader()
            if AccountController.shared.accessToken != nil{
                myCartHelper.fetchCartItems { [self] type in
                    self.cartData=self.myCartHelper.myCart
                    let cartTotal = self.cartData?.filter{$0.qtyAvailable! > 0}
                    let totalPrice = cartTotal?.compactMap{$0.price}
                    proccedCartFlag = true
                    if self.myCartHelper.myCart.count>0{
                        viewNoData.isHidden = true
                        self.cartSubTotal = CartViewModel.gettingAllCartSubTotalCel(myCartData: self.myCartHelper.subtotal)
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                        self.tableView.reloadData()
                        dismissLoader()
                    }
                    else{
                        viewNoData.isHidden = false
                        lblSubtitle.text = "Add items you want to shop"
                        self.tableView.tableFooterView = nil
                        self.tableView.reloadData()
                        dismissLoader()
                    }
                }
                
                fetchFav()
                removeNoInternetConnection()
            }
            else{
                viewNoData.isHidden = false
                dismissLoader()
                lblSubtitle.text = "If you have some items in your cart,Please LOGIN to see items in your cart"
                removeNoInternetConnection()
            }
        }else {
            self.handleNoInternetConnection()
        }
        
    }
    
    func fetchFav(){
        arrFavProductId = []
               if AccountController.shared.accessToken != nil && WishListController.shared.userId != nil {
                   collectionBaseVM.fetchFavProduct(){ arrFavProductId in
                       self.arrFavProductId = arrFavProductId
                       self.tableView.reloadData()
                   }
               }
    }
    
    @IBAction func actionStartShopping(_ sender: Any) {
        tabBarController?.selectedIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        addNoNetworkView()
        setNavigationBarTitle("My Bag",inMiddle: true)
        addSideMenu()
        //tabBarController?.tabBar.items?[4].badgeValue = "\(CartController.shared.itemCount)"
    }
    
    func calculate(){
        let cartFilter = cartData?.filter({
            $0.comparePrice! > $0.price
        })
        let comparePrice = cartFilter?.map({
            $0.comparePrice!
        })
        let price = cartFilter?.map({
            $0.price
        })
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeSideMenu()
    }
    
    @IBAction func actionClearAllCart(_ sender: Any) {
        AppHelper.sharedInstance.showAlertView(title: "HOMEEASSY", message: "Are you sure to remove all product?", cancelButtonTille: "No", otherButtonTitles: "Yes"){ [self] data in
            if data == "2"{
                CartController.shared.removeAllItem()
                fetchData()
            }
        }
       
    }
    
}

extension CartViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KCartViewCell) as! CartViewCell
        let obj = cartData?[indexPath.row]
        cell.delegate = self
       
        if arrFavProductId.contains((obj?.productID)!) {
            flagWishlist = true
        } else {
            flagWishlist = false
        }
        if (obj?.qtyAvailable)! < 1{
            proccedCartFlag = false
           
        }
        cell.setData(obj:obj!,index: indexPath.row, flagWishlist: flagWishlist)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = StoryBoardHelper.controller(.category, type: ProductDetailVC.self)
        let obj = cartData?[indexPath.row]
        controller?.productId = obj?.productID
        controller?.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
            return 170
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
            let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: KTotalFooterView) as! TotalFooterView
        footer.delegate = self
      
        footer.setData(cartSubTotal: cartSubTotal,proccedCartFlag: proccedCartFlag)
            return footer
    }
}

extension CartViewController:UpdateCartDelegate{
    
    func EditProduct(productId: String, index: Int) {
        let controller = StoryBoardHelper.controller(.cart, type: EditCartViewController.self)
        controller?.fetchProductDetail(obj: productId)
        controller?.index = index
        controller?.delegate = self
        controller?.hidesBottomBarWhenPushed = true
        navigationController?.present(controller!, animated: true)
    }
    
    func EditCartItem(cartItem: CartItemViewModel!, indexCart: Int!, qty: Int!, maxQty: Int32) {
        let controller = StoryBoardHelper.controller(.cart, type: EditCartVC.self)
        controller?.index = indexCart
        controller?.delegate = self
        controller?.qty = qty
        controller?.maxQty = maxQty
        controller?.hidesBottomBarWhenPushed = true
        navigationController?.present(controller!, animated: true)
    }
    
    
    func UpdateCart(flag: Bool,favFlag:Bool, index: Int?) {
        if flag{
            AppHelper.sharedInstance.showAlertView(title: "HOMEEASSY", message: "Are you sure to remove this product?", cancelButtonTille: "No", otherButtonTitles: "Yes"){ data in
                if data == "2"{
                    CartController.shared.removeAllQuantitiesFor(CartController.shared.items[index!])
                    self.fetchData()
                    self.tableView.reloadData()
                }
            }
            self.fetchData()
            self.tableView.reloadData()
        }
        if favFlag{
            fetchFav()
            self.tableView.reloadData()
        }
        
    }
    
}

extension CartViewController:proceedCartDelegate,paymentDelegate,SuccessPayment {
    func moveToTrackOrder() {
        tabBarController?.selectedIndex = 0
//        let vc = StoryBoardHelper.controller(.live, type: OrderHistoryVC.self)
//        vc!.hidesBottomBarWhenPushed = true
//        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func succussFullyPaid() {
        fetchData()
        self.tableView.reloadData()
        let vc = StoryBoardHelper.controller(.cart, type: ThankYouVC.self)
        vc?.delegate = self
        self.present(vc!, animated: true)
    }
    
    func createCart() {
        if AccountController.shared.accessToken != nil{
            myCartHelper.proceedToCheckOutAction(){ [self] url in
                if let webViewVC = StoryBoardHelper.controller(.cart , type: WebViewVC.self) {
                    webViewVC.urlString = url?.absoluteString
                    webViewVC.payment = self
                    for dict in cartSubTotal {
                            if let lbl = dict["lbl"], let amount = dict["amount"] {
                                //FirebaseAnalytics.shared.sendUserCartEvent(price:amount)
                            }
                        }
                    
                    webViewVC.checkOut = myCartHelper.checkOut
                    webViewVC.hidesBottomBarWhenPushed = true
                    //webViewVC.navigationTitle = "PAYMENT"
                    webViewVC.modalPresentationStyle = .fullScreen
                    self.present(webViewVC, animated: true)
                    //(webViewVC, sender: Any?.self)
                }
            }
        }
        else{
            self.view.makeToast("Cant procced please login again")
        }
    }
}

extension CartViewController : NoInternetHandler {
    func retryAction(object : Any?) {
        if NetStatus.shared.isConnected {
            removeNoInternetConnection()
            fetchData()
            tableView.reloadData()
        }
    }
}
