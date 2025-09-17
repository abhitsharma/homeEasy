//
//  ProductVC.swift
//  KoovsOnlineFashion
//
//  Created by Koovs on 16/08/16.
//  Copyright © 2016 Koovs. All rights reserved.
//

import UIKit
import MobileBuySDK

protocol ProductListDataSource:AnyObject {
  func productlistIsLoadingNextPage() -> Bool
    func productListnumberOfItems() -> Int
  
}

extension ProductListDataSource {
    func productlistIsLoadingNextPage() -> Bool{
      return false
    }
   
}

protocol ProductListDelegate:AnyObject {
   func loadNextPage() -> Bool
  
}

extension ProductListDelegate{
    func loadNextPage() -> Bool{
        return false
    }
}

import UIKit
let KProductCollectionViewCell = "ProductCollectionViewCell"
class productsVC: BaseVC {
    var collections: ProductViewModel!
    var graph: Graph!
    @IBOutlet weak var collectionView: StorefrontCollectionView!
    @IBOutlet weak var lblnumOfProduct: UILabel!
    @IBOutlet weak var btnSort: UIButton!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var sortFilterStack: UIStackView!
    var collection: String!
    let columns: Int = 2
    var filtersProducts: [ProductFilter]?
    weak var delegate: ProductListDelegate?
    weak var dataSource: ProductListDataSource?
    var products: PageableArray<ProductViewModel>!
    let collectionBaseVM: CollectionBaseDelegate = CollectionBaseVM()
    var selectSortOption: SortOption = SortOption.getAllSortOption().first!
    var sortVC: SortVC?
    @IBOutlet weak var lblNoProduct:UILabel!
    var isLoading = false
    var flagWishlist: Bool!
    var arrFavProductId: [String] = []
    var searchQuery: String = ""
    var fetchType: Int!
    var page:Int = 1
    var titleNav:String!
    var selectedFilters = [String:[String]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.collectionView.register(UINib.init(nibName: KProductCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: KProductCollectionViewCell)
    }

    override func viewWillAppear(_ animated: Bool) {
        var title = titleNav ?? searchQuery
        if title == ""{
            title = "Products"
        }
        setNavigationBarTitle(title, inMiddle: false)
        page = 1
        setData()
        collectionView.reloadData()
        //getFilterData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
          if  isLoading{
                collectionView.willBeginPaging()
        }
    }

    private func configureCollectionView() {
        self.collectionView.paginationDelegate = self
        if self.traitCollection.forceTouchCapability == .available {
            self.registerForPreviewing(with: self, sourceView: self.collectionView)
        }
    }

    @IBAction func actionSortVc(_ sender: Any) {
            if let vc = StoryBoardHelper.controller(.category, type: SortVC.self) {
                vc.delegate = self
                vc.setData(seleted: self.selectSortOption)
                navigationController?.present(vc, animated: true)
            }
    }

    func setData(seleted: SortOption?) {
        selectSortOption = seleted!
    }

    @IBAction func actionFilterVC(_ sender: Any) {
        if self.collectionBaseVM.filters.isEmpty == false{
            if let vc = StoryBoardHelper.controller(.category, type: FilterViewControler.self) {
                vc.filterHandler = self
                // vc.setData(filters: filters, selectedFilters: sele)
                vc.filters = self.collectionBaseVM.filters
                vc.selectedFilters=self.selectedFilters
                vc.setData(filters: self.collectionBaseVM.filters, selectedFilters: self.selectedFilters)
                vc.modalPresentationStyle = .overCurrentContext
                navigationController?.present(vc, animated: true)
            }
        }
        else{
            self.view.makeToast("You can't apply filters! No products to show")
        }
    }

    func setData() {
        if NetStatus.shared.isConnected{
        showLoader()
        if fetchType == 1 {
            loadData(page: 1)
        } else if fetchType == 2 {
            loadData(page: 1)
        }
        }
        else {
            self.handleNoInternetConnection()
        }
    }
    
    func checkQuantity() -> Bool{
        let outOfStockFlag:Bool = false
        let inStockFlag:Bool = false
//        if let products = self.products{
//            products.items.first(where: { $0
//                .productDtl?.variants.items.first(where: )?.quantityAvailable == 0
//            })
//        }
        return outOfStockFlag && inStockFlag
    }
    
    func loadData(page: Int,after:String? = nil) {
        if fetchType == 1 {
            collectionBaseVM.fetchProducts(collection: self.collection, after: after, selectedFilters: selectedFilters, sortOption: selectSortOption) { [self] collection in
                if let fetchedCollection = collection {
                    dismissLoader()
                    if page == 1 {
                        self.products = fetchedCollection
                    } else {
                        self.products = fetchedCollection
                    }
                    if self.products.items.isEmpty{
        
                        lblNoProduct.text = "No Products To Show"
                    }
                    else{
                        lblNoProduct.text = ""
                    }
                    self.collectionView.reloadData()
                }
            }
        } else if fetchType == 2 {
            Client.shared.searchAllProduct(after:after,sortOption: selectSortOption,query: searchQuery) { [self] products in
                if let fetchedProducts = products {
                    dismissLoader()
                    if page == 1 {
                        self.products = fetchedProducts
                    } else {
                        self.products?.appendPage(from: fetchedProducts)
                    }
                    if self.products.items.isEmpty{

                        lblNoProduct.text = "No Products To Show"
                    }
                    else{
                        lblNoProduct.text = ""
                    }
                    self.collectionView.reloadData()
                }
            }
        }
            //wishlist Products
        arrFavProductId = []
               if AccountController.shared.accessToken != nil && WishListController.shared.userId != nil {
                   collectionBaseVM.fetchFavProduct(){ arrFavProductId in
                       self.arrFavProductId = arrFavProductId
                       self.collectionView.reloadData()
                   }
               }
    }

    func productDetailsViewControllerWith(_ product: ProductViewModel) -> ProductDetailVC {
        let controller: ProductDetailVC = self.storyboard!.instantiateViewController(identifier: "ProductDetailVC")
        controller.hidesBottomBarWhenPushed = true
        controller.productId = product.id
        return controller
    }
    
    func customToast(){
        let uiview = UIView(frame: .init(x: 0, y: 0, width: UIScreen.width - 100, height: 40))
        uiview.backgroundColor = UIColor(named: "CustomBlack")
        uiview.cornerRadius = 15
        let label = UILabel(frame: .init(x: 25, y: 0, width: 150, height: 40))
        label.text = "Added to wishlist"
        label.textColor = .white
        label.font = UIFont(name: NiveauGrotesk.regular.rawValue, size: 15)
        let button = UIButton(frame: .init(x: label.frame.width + 60, y: 0, width: 70, height: 40))
        button.setTitle("Go to WishList", for: .normal)
        button.titleLabel?.font = UIFont(name: NiveauGrotesk.Medium.rawValue, size: 15)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(didTapWishlistButton), for: .touchUpInside)
        uiview.addSubview(label)
        uiview.addSubview(button)
        self.view.showToast(uiview)
    }
}

extension productsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products?.items.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KProductCollectionViewCell, for: indexPath) as! ProductCollectionViewCell
        let product = self.products.items[indexPath.item]
        cell.delegate = self

        if arrFavProductId.contains(product.id) {
            flagWishlist = true
        } else {
            flagWishlist = false
        }
        cell.configureFrom(product, flagWishlist: flagWishlist)
        cell.layer.transform = CATransform3DMakeScale(0.7,0.7,1)
                        ç.animate(withDuration: 0.3, animations: {
                               cell.layer.transform = CATransform3DMakeScale(1.03,1.03,1)
                               },completion: { finished in
                                   UIView.animate(withDuration: 0.3, animations: {
                                       cell.layer.transform = CATransform3DMakeScale(1,1,1)
                                   })
                           })
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        weak var weakCollectionViewCell: UICollectionViewCell? = cell

        if let countData = dataSource?.productListnumberOfItems() {
            if countData - indexPath.row == 1 {
                let _ = delegate?.loadNextPage()
            }
        }
        cell.layer.cornerRadius = 4.0
        cell.layer.masksToBounds = true
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = self.products.items[indexPath.item]
        let controller = self.productDetailsViewControllerWith(product)
        FirebaseAnalytics.shared.sendLogEventProduct(name: product.productDtl!.title, id: product.productDtl!.id, varint: (product.productDtl?.variant!.title)!)
        self.navigationController!.show(controller, sender: self)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension productsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let itemSpacing = layout.minimumInteritemSpacing * CGFloat(self.columns - 1)
        let sectionSpacing = layout.sectionInset.left + layout.sectionInset.right
        let length = (collectionView.bounds.width - itemSpacing - sectionSpacing) / CGFloat(self.columns)

        return CGSize(
            width: length - 10,
            height: length + 65.0
        )
    }
}

extension productsVC: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let collectionView = previewingContext.sourceView as! UICollectionView
        if let indexPath = collectionView.indexPathForItem(at: location) {
            let cell = collectionView.cellForItem(at: indexPath) as! ProductCollectionViewCell
            return self.productDetailsViewControllerWith(cell.product!)
        }
        return nil
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController!.show(viewControllerToCommit, sender: self)
    }
}

// MARK: - PaginationDelegate

extension productsVC: StorefrontCollectionViewDelegate {
    func collectionViewShouldBeginPaging(_ collectionView: StorefrontCollectionView) -> Bool {
        isLoading = self.products?.hasNextPage ?? false
        return isLoading
    }

    func collectionViewWillBeginPaging(_ collectionView: StorefrontCollectionView) {
        if let lastProduct = self.products?.items.last?.cursor {
            if fetchType == 1 {
                loadData(page: self.page+1,after: lastProduct)
            } else if fetchType == 2 {
                loadData(page: self.page+1, after: lastProduct)
            }
        }
    }

    func collectionViewDidCompletePaging(_ collectionView: StorefrontCollectionView) {
        self.collectionView.completePaging()
    }
}

extension productsVC: SortDelegate {
    func didSelectSort(_ sortId: SortOption?) {
        if let sortId = sortId {
            if selectSortOption != sortId {
                selectSortOption = sortId
                products = nil
                loadData(page: 1)
                self.collectionView.paginationDelegate = self
                isLoading = self.products?.hasNextPage ?? false
                if isLoading{
                    collectionView.willBeginPaging()
                }
            }
        }
    }
}

extension productsVC: wishlistUpdateDelegate {
    func updateWishlist(flag: Bool, reFlag: Bool) {
        if flag {
            if reFlag {
                self.view.makeToast("Removed from Wishlist")
            } else {
                customToast()
            }
        } else {
            let vc = StoryBoardHelper.controller(.live, type: LoginVC.self)
            vc!.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: true)
        }
    }
    
   
}

extension productsVC : NoInternetHandler {
    func retryAction(object : Any?) {
        if NetStatus.shared.isConnected {
        removeNoInternetConnection()
            self.setData()
            self.collectionView.reloadData()
        }
    }
}


extension productsVC: FilterHandler{
    func applyFilters(_ filters: [String : [String]], flag: Bool) {
        self.selectedFilters=filters
        if filters.isEmpty{
           
        }
        else{
            
        }
        //self.updateFilterCount()
          if let _ = self.collection{
              products = nil
              loadData(page: 1)
              self.collectionView.paginationDelegate = self
              isLoading = self.products?.hasNextPage ?? false
              if isLoading{
                  collectionView.willBeginPaging()
              }
//              collectionView.reloadData()
          }
          else{
              setData()
              collectionView.reloadData()
        }
    }
}
