//
//  WishlistViewController.swift
//  HomeEassy
//
//  Created by Swatantra singh on 29/07/23.
//

import UIKit
import MobileBuySDK
let KWishListViewCell = "WishListViewCell"
class WishlistViewController: BaseVC {
    var arrProductId:[String] = []
    var products: [ProductObj]!
    var arrCart :[String] = []
    let wishlistVM:WishlistVMDelegate = WishlistVM()
    @IBOutlet weak var viewNoData:UIView!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var btnShopping:UIButton!
    @IBOutlet weak var lblSubtitle:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewNoData.isHidden = true
        fetchWishList()
        tableView.register(UINib.init(nibName: KWishListViewCell, bundle: nil), forCellReuseIdentifier: KWishListViewCell)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBarTitle("Wishlist",inMiddle: true)
        addSideMenu()
        updateWishlist()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeSideMenu()
    }
    
    func fetchWishList(){
        if NetStatus.shared.isConnected{
        if AccountController.shared.accessToken != nil{
            showLoader()
            wishlistVM.fetchWishList(){ [self] products in
                if products!.count < 1{
                   viewNoData.isHidden = false
                    lblSubtitle.text = "Explore more and shortlist items."
                    dismissLoader()
                }
                else{
                        viewNoData.isHidden = true
                        self.products = products
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                        self.tableView.reloadData()
                    dismissLoader()
                }
                
            }
            removeNoInternetConnection()
            
        }
        else{
            viewNoData.isHidden = false
            lblSubtitle.text = "If you have some items in your Wishlist,Please LOGIN to see items in your Wishlist"
            removeNoInternetConnection()
        }
        }
        else {
            self.handleNoInternetConnection()
        }
    }
    
    @IBAction func actionStartShopping(_ sender: Any) {
        tabBarController?.selectedIndex = 0
    }
    
    func updateWishlist(){
        fetchWishList()
        fetchCart()
        tableView.reloadData()
    }
    
    func fetchCart(){
        arrCart =  CartController.shared.items.compactMap{$0.product.id}
    }
    
}

extension WishlistViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KWishListViewCell) as! WishListViewCell
        let obj = products[indexPath.row]
        cell.delegate = self
        let cartflag:Bool
        if arrCart.contains(obj.id){
        cartflag = true
        }
        else
        {
        cartflag = false
        }
        cell.btnAddCart.isSelected = cartflag
        cell.setData(obj: obj, addedCartFlag: cartflag)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = StoryBoardHelper.controller(.category, type: ProductDetailVC.self)
        let obj = products[indexPath.row]
        controller?.productId = obj.id
        controller?.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller!, animated: true)
    }
    
}

extension WishlistViewController:WishListDelegate{
    func addedCart(product: ProductObj) {
        if product.availableForSale{
            if arrCart.contains(product.id){
                self.view.makeToast("Item is already in cart")
            }
            else{
                let item = CartItem(product: product, variantId: product.variant!.id,quantity: 1)
                CartController.shared.add(item,qty: 1)
                self.view.makeToast("Added To Cart")
            }
        }
        else{
            self.view.makeToast("Product is not available")
        }
        updateWishlist()
    }
    
    func removeProduct(productId: String) {
        if let index = arrProductId.firstIndex(of: productId) {
                   arrProductId.remove(at: index)
               }
        persistentStorage.Shared.deleteProduct(withProductId: productId, forUserId: WishListController.shared.userId!)
        updateWishlist()
    }
}

extension WishlistViewController : NoInternetHandler {
    func retryAction(object : Any?) {
        if NetStatus.shared.isConnected {
            removeNoInternetConnection()
            updateWishlist()
        }
    }
}
