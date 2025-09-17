//
//  ProductDetailVC.swift
//  Storefront
//
//  Created by Macbook on 14/08/23.
//  Copyright © 2023 Shopify Inc. All rights reserved.
//

import UIKit
import MobileBuySDK

let KProductHighlightCell = "ProductHighlightCell"
let KProductImagesHeader = "ProductImagesHeader"
let KVarientSelectedCell = "VarientSelectedCell"
let KProductDetailHeaderCell = "ProductDetailHeaderCell"
let KAddCartFooterView = "AddCartFooterView"
let KProductDiscriptionHeader = "ProductDiscriptionHeader"
let KProductDescriptionCell = "ProductDescriptionCell"

class ProductDetailVC: BaseVC {
    @IBOutlet weak var btnAddCart: UIButton!
    @IBOutlet weak var btnWishlist: UIButton!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var viewBtn:UIView!
    var productId: String!
    var flagWishlist:Bool!
    var flagCart = true
    var productDetail: ProductObj?
    var isExpand:Bool!
    var id:String!
    var arrFavProductId:[String] = []
    let collectionBaseVM:CollectionBaseDelegate = CollectionBaseVM()
    let productDetailVM:ProductDetailVMDelegate = ProductDetailVM()
    var isQtyAvailable:Bool!
    var varintId:String!
    var qty:Int = 1
    var style = ToastStyle.init()
    var indexImgOpen:Int?
    var selectedVarint:VariantViewModel?
    var userID:String?
    var userAccessTokken:String?
    var images: [String] = []
    var disableCellFlag:Bool = false
    var selName:String?
    var  cartData:[CartItemViewModel]?
    var myCartHelper = CartViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        isExpand = true
        viewBtn.isHidden = true
        setNavigationBarTitle("Product Details",inMiddle: false)
        addCartWishlist()
        tableView.register(UINib.init(nibName: KProductHighlightCell, bundle: nil), forCellReuseIdentifier: KProductHighlightCell)
        tableView.register(UINib.init(nibName: KProductImagesHeader, bundle: nil), forCellReuseIdentifier: KProductImagesHeader)
        tableView.register(UINib.init(nibName: KVarientSelectedCell, bundle: nil), forCellReuseIdentifier: KVarientSelectedCell)
        tableView.registerNibName(KProductDetailHeaderCell, forCellHeaderFooter: KProductDetailHeaderCell)
        tableView.registerNibName(KAddCartFooterView, forCellHeaderFooter: KAddCartFooterView)
        tableView.registerNibName(KProductDiscriptionHeader, forCellHeaderFooter: KProductDiscriptionHeader)
        tableView.register(UINib.init(nibName: KProductDescriptionCell, bundle: nil), forCellReuseIdentifier: KProductDescriptionCell)
        fetchProductDetail(obj: productId)
        style.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        style.messageFont = UIFont(name: NiveauGrotesk.regular.rawValue, size: 16)!
        style.messageColor = .black
        
    }
    
    @IBAction func actionAddWishlist(_ sender: UIButton) {
        if userAccessTokken != nil && userID != nil {
            sender.isSelected = !sender.isSelected
            if sender.isSelected{
                btnWishlist.setTitle("WISHLISTED", for: .normal)
                createWishList()
            }
            else{
                btnWishlist.setTitle("WISHLIST", for: .normal)
                //persistentStorage.Shared.deleteProduct(withProductId: productId)
                persistentStorage.Shared.deleteProduct(withProductId: productId, forUserId: WishListController.shared.userId!)
            }
        }
        else {
            let vc = StoryBoardHelper.controller(.live, type: LoginVC.self)
            vc!.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: true)
          
        }
    }
    
    @IBAction func actionAddToBag(_ sender: Any) {
        if btnAddCart.isSelected{
            tabBarController?.selectedIndex = 4
            navigationController?.popToRootViewController(animated: true)
        }
        else{
            if userAccessTokken != nil && userID != nil {
                if  let varintId = getVarintData()?.id, varintId != ""{
                    let item = CartItem(product: self.productDetail!, variantId: varintId,quantity: self.qty)
                    CartController.shared.add(item)
                    FirebaseAnalytics.shared.sendUserAddCartEvent(item: productDetail?.id ?? productId)
                    //self.view.makeToast("Successfully added",style: style)
                    customToast()
                    btnAddCart.isSelected = true
                    setBadge(for: cartButton, count: CartController.shared.itemCount)
                    btnAddCart.setTitle("Go To Cart", for: .normal)
                }
                else {
                    self.view.makeToast("Please Select Varient",style: style)
                }
            }
            else {
                let vc = StoryBoardHelper.controller(.live, type: LoginVC.self)
                vc!.modalPresentationStyle = .fullScreen
                self.present(vc!, animated: true)
            }
        }
    }

    func fetchProductDetail(obj:String){
        if NetStatus.shared.isConnected{
            showLoader()
        productDetailVM.fetchProducts(id: obj){
            details in
            if details != nil{
                DispatchQueue.main.async { [self] in
                    self.productDetail = details
                    for option in self.productDetail!.option{
                        for item in option.values{
                            option.SelectedValue = item
                            break
                        }
                    }
                    self.dismissLoader()
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    //self.varintId = productDetail?.variants.items[0].id
                    setSelected()
                //self.selectedVarint = self.productDetail?.variants.items[0]
                    self.tableView.reloadData()
                }
            }
            }
        goToCart()
        viewBtn.isHidden = false
        removeNoInternetConnection()
        arrFavProductId = []
        if userAccessTokken != nil && userID != nil {
            collectionBaseVM.fetchFavProduct(){ [self] arrFavProductId in
                self.arrFavProductId = arrFavProductId
                if self.arrFavProductId.contains(productId){
                    flagWishlist = true
                }
                else {
                    flagWishlist = false
                }
            }
        }
        else {
            flagWishlist = false
        }
        }
        else {
            self.handleNoInternetConnection()
        }
    }

    func createWishList(){
        persistentStorage.Shared.insertProduct(productID: productId, userID: WishListController.shared.userId!)
        FirebaseAnalytics.shared.sendLogEventWishlist(item: productDetail?.id ?? productId)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        AccountController.shared
//        WishListController.shared
        userAccessTokken = AccountController.shared.accessToken
        userID = WishListController.shared.userId
        fetchProductDetail(obj: productId)
        setNavigationBarTitle("Product Details",inMiddle: true)
        updatebuttonText()
        
    }
    
    func updatebuttonText(){
        if flagWishlist{
            btnWishlist.isSelected = true
            btnWishlist.setTitle("WISHLISTED", for: .normal)
        }
        else{
            btnWishlist.isSelected = false
            btnWishlist.setTitle("WISHLIST", for: .normal)
        }
        if flagCart{
            btnAddCart.isSelected = true
            btnAddCart.setTitle("Go To Cart", for: .normal)
        }
        else{
            btnAddCart.isSelected = false
            btnAddCart.setTitle("Add To Bag", for: .normal)
        }
    }
    
    func getVarintData() -> VariantViewModel? {
        var selVar:VariantViewModel? = nil
        var arrVarint = self.productDetail?.variants.items
        if let optionData = self.productDetail?.option {
 
            for i in 0..<optionData.count {
                let opt = optionData[i]
                let selectedValue = opt.SelectedValue
                switch i {
                case i:
                    arrVarint = arrVarint?.filter { (varint) -> Bool in
                        let arrV = varint.selectedOption.filter { $0.name == opt.name && $0.value == selectedValue }
                        return arrV.count > 0
                    }
                default:
                    if let selectvalue = opt.SelectedValue {
                        arrVarint = arrVarint?.filter { (varint) -> Bool in
                            let arrV = varint.selectedOption.filter { $0.name == opt.name && $0.value == selectvalue }
                            return arrV.count > 0
                        }
                    }
                }
            }
            selVar = arrVarint?.first
        }
        
        return selVar
    }
    
    func goToCart(){
        let arr =   CartController.shared.items.filter{ $0.product.id == productId
    }
        if arr.contains(where: {$0.variantId == selectedVarint?.id})
        {
            flagCart = true
            //btnAddCart.backgroundColor = UIColor(named: "CustomGreen")
        }
        else{
            flagCart = false
        }
    }
    
    func setSelected(){
        if let varint = getVarintData(){
            disableCellFlag = false
            self.selectedVarint = varint
            if let option = productDetail?.option,option.count >= 1,option.contains(where: { $0.name == "Color"}){
                self.images = getVarintImages()
            }
            else{
                self.images = (productDetail?.images.items.map { $0.url.absoluteString })!
            }
            
            if selectedVarint!.quantityAvailable < 1{
                self.isQtyAvailable = false
                self.btnAddCart.isEnabled = false
                self.btnAddCart.alpha = 0.7
            }
            else {
                self.isQtyAvailable = true
                self.btnAddCart.isEnabled = true
                self.btnAddCart.alpha = 1
            }
            goToCart()
            updatebuttonText()
        }
        else {
            disableCellFlag = true
            self.view.makeToast("Please select another product varient!...this is not available yet")
            self.btnAddCart.isEnabled = false
            self.btnAddCart.alpha = 0.5
            self.btnWishlist.isEnabled = false
            self.btnWishlist.alpha = 0.5
        }
        self.tableView.reloadData()
    }
    
    func getVarintImages() -> [String] {
        var imageArray: [String] = []
        if let optionData = self.productDetail?.option {
            for i in 0..<optionData.count {
                let opt = optionData[i]
                let selectedValue = opt.SelectedValue
                if let variants = self.productDetail?.variants.items {
                    for variant in variants {
                        // Check if the variant's selectedOption contains the color option
                        if variant.selectedOption.contains(where: { $0.name == "Color" && $0.value == selectedValue }) {
                            // Append the images of the matching variant to the imageArray
                            if let images = variant.image?.absoluteString {
                                if !imageArray.contains(images) {
                                    imageArray.append(images)
                                }
                            }
                        }
                    }
                }
            }
        }
//        let selectedValue = opt.SelectedValue
//        let arr = productDetail?.variants.items.filter{$0.selectedOption}
//        if let variants = self.productDetail?.variants.items {
//            for variant in variants {
//                // Check if the variant's selectedOption contains the color option
//                if variant.selectedOption.contains(where: { $0.name == "Color" && $0.value == selectedValue }) {
//                    // Append the images of the matching variant to the imageArray
//                    if let images = variant.image?.absoluteString {
//                        if !imageArray.contains(images) {
//                            imageArray.append(images)
//                        }
//                    }
//                }
//            }
//        }
        return imageArray
    }


    func customToast(){
        let uiview = UIView(frame: .init(x: 0, y: 0, width: UIScreen.width - 100, height: 40))
        uiview.backgroundColor = UIColor(named: "CustomBlack")
        uiview.cornerRadius = 15
        let label = UILabel(frame: .init(x: 25, y: 0, width: 150, height: 40))
        label.text = "Added to Cart"
        label.textColor = .white
        label.font = UIFont(name: NiveauGrotesk.regular.rawValue, size: 15)
        let button = UIButton(frame: .init(x: label.frame.width + 60, y: 0, width: 70, height: 40))
        button.setTitle("Go to Cart", for: .normal)
        button.titleLabel?.font = UIFont(name: NiveauGrotesk.Medium.rawValue, size: 15)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(didTapCartButton), for: .touchUpInside)
        uiview.addSubview(label)
        uiview.addSubview(button)
        self.view.showToast(uiview)
    }
}

extension ProductDetailVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else if section == 1{
            if let cellReturn = productDetail?.option.count,productDetail?.option[0].name != "Title"{
                return cellReturn
            }
            else {
                return 0
            }
        }
        else if section == 2{
            return 1
        }
        else if section == 3{
            return 1
        }
         return 0
     }
     
     func numberOfSections(in tableView: UITableView) -> Int {
         return 4
         
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 300.0
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                return 80
            }
            else if indexPath.row == 1{
                return 80
            }
            else if indexPath.row == 2{
                return 80
            }
        }
        if indexPath.section == 2 {
            if isExpand{
                return UITableView.automaticDimension
            }
            else {
                return 0
            }
        }
        else if indexPath.section == 3{
            return 262.0
        }
        
        else{
           return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if productDetail != nil{
            if indexPath.section == 0{
                let header = tableView.dequeueReusableCell(withIdentifier: KProductImagesHeader) as! ProductImagesHeader
                header.setData(obj: self.images)
                header.delegate = self
                return header
            }
            if indexPath.section == 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier: KVarientSelectedCell) as! VarientSelectedCell
                cell.lblTitle.text = productDetail?.option[indexPath.row].name
                cell.options = productDetail!.option[indexPath.row]
                cell.delegate = self
                cell.setData(currentIndex:indexPath.row,flag: disableCellFlag)
                    return cell

            }
         
            if indexPath.section == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: KProductDescriptionCell) as! ProductDescriptionCell
                cell.setObj(obj: (productDetail!.summary.convertToAttributedFromHTML())!)
                return cell
                
            }
            
            else if indexPath.section == 3{
                let cell = tableView.dequeueReusableCell(withIdentifier: KProductHighlightCell) as! ProductHighlightCell
                cell.delegate = self
                cell.fetchRecommendations(obj: productDetail!)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if productDetail != nil{
            switch section {
            case 0:
                let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: KProductDiscriptionHeader) as! ProductDiscriptionHeader
                header.lblTitle.text = ""
                return header

            case 1:
                let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: KProductDetailHeaderCell) as! ProductDetailHeaderCell
                header.delegate = self
                header.delegateCheckout = self
                header.delegateQty = self
                header.setData(obj: selectedVarint!, qty: self.qty, product: productDetail )
                return header
                
            case 2:
                let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: KProductDiscriptionHeader) as! ProductDiscriptionHeader
                header.lblTitle.text = "Top Highlights"
                header.delegate = self
                if isExpand{
                    header.btnOpen.isSelected = true
                }
                else {
                    header.btnOpen.isSelected = false
                }
                header.btnOpen.isHidden = false
                header.btnOpen.isEnabled = true
                return header
            case 3:
                let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: KProductDiscriptionHeader) as! ProductDiscriptionHeader
                header.lblTitle.text = "You may also like"
                header.btnOpen.isHidden = true
                header.btnOpen.isEnabled = false
                return header
            default:
                print("nothing")
            }
        }
           return UIView()
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            if section == 0{
                return 0
            }
            else if section == 1{
                return UITableView.automaticDimension
            }
            else if section == 2{
                return 22
            }
            else if section == 3
            {
                return 22
            }
            else{
                return 0
            }
           
        }
}

extension ProductDetailVC:btnSelected{
    func Selected(bool: Bool) {
        isExpand = bool
        tableView.reloadData()
    }
}

extension ProductDetailVC:selCollection{
    func selHighLight(id: String) {
        productId = id

    }
    
    func selProduct(id: String) {
        let controller: ProductDetailVC = self.storyboard!.instantiateViewController(identifier: "ProductDetailVC")
        controller.productId = id
        navigationController?.pushViewController(controller, animated: true)
    }
    
}


extension ProductDetailVC:ProductCheckoutDelegate{
    func productAddCart(varintId: String) {
        self.varintId = varintId
    }
}



extension ProductDetailVC :ProductEditQtyDelegate,productEditDelegate{
    func edit(qty: Int) {
        self.qty = qty
        tableView.reloadData()
        
    }
    
    func editProduct(qty: Int, max: Int) {
        let vc = StoryBoardHelper.controller(.category, type: EditQtyVC.self)
        vc?.qty = qty
        vc?.maxQty = Int32(max)
        vc?.delegateQty = self
        self.present(vc!, animated: true)
    }
    
    
}

extension ProductDetailVC:imageDetailDelegate{
    func loadImageVC(images: [String], selectedImage: String) {
        let vc = StoryBoardHelper.controller(.category, type: ProductImageVC.self)
        vc?.images = images
        vc?.selectedImage = selectedImage
        vc!.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true)
    }

}



extension ProductDetailVC :upDateSelectedDelegate{
    func selectedVarint(selctedIndex: Int, selName: String!) {
        self.productDetail?.option[selctedIndex].SelectedValue = selName
         _ = setSelected()
    }
  
}

extension ProductDetailVC : NoInternetHandler {
    func retryAction(object : Any?) {
        if NetStatus.shared.isConnected {
        removeNoInternetConnection()
            self.fetchProductDetail(obj: productId)
            self.tableView.reloadData()
        }
    }
}
