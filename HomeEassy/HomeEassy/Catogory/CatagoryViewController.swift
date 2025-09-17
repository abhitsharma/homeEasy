//
//  CatagoryViewController.swift
//  Storefront
//
//  Created by Macbook on 27/07/23.
//  Copyright © 2023 Shopify Inc. All rights reserved.
//

import UIKit
let kRefreshWishlist = "RefreshWishlist"
class CatagoryViewController: BaseVC {
   let KCatogoryCollectionViewCell = "CatogoryCollectionViewCell"
   @IBOutlet weak var collectionView:UICollectionView!
    var collections: PageableArray<CollectionViewModel>!
    var arrTitle:[String] = []
    var arrImg:[URL] = []
    let columns:  Int = 3
    let collectionBaseVM:CollectionBaseDelegate = CollectionBaseVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib.init(nibName: KCatogoryCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: KCatogoryCollectionViewCell)
        self.fetchCollections()
        collectionView.reloadData()
        addNotificationForViewRefresh()
    }
    
    func addNotificationForViewRefresh() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: kRefreshWishlist), object: nil, queue: OperationQueue.current) { (notification) in
            self.fetchCollections()
        }
    }
        
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.fetchCollections()
        addNoNetworkView()
        self.setNavigationBarTitle("Categories",inMiddle: true)
        collectionView.reloadData()
        addSideMenu()
    }
    
    override func viewDidAppear(_ animated: Bool) {
             fetchCollections()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeSideMenu()
    }
    
    func fetchCollections(after cursor: String? = nil) {
        if NetStatus.shared.isConnected{
            showLoader()
            collectionBaseVM.fetchCollections(after:cursor){ [self] response in
                    if response != nil{
                        dismissLoader()
                        collections =  collectionBaseVM.collections
                        collections.items = collections.items.filter { !$0.title.lowercased().contains("banner") }
                        collectionView.delegate = self
                        collectionView.dataSource = self
                        collectionView.reloadData()
                        removeNoInternetConnection()
                }
                else{
                    fetchCollections()
                }
                
            }
        }
        else {
            self.handleNoInternetConnection()
        }
        
    }
    
}

//extension CatagoryViewController:StorefrontCollectionViewDelegate{
//    func collectionViewShouldBeginPaging(_ collectionView: StorefrontCollectionView) -> Bool {
//        return self.collectionBaseVM.collections?.hasNextPage ?? false
//    }
//
//    func collectionViewWillBeginPaging(_ collectionView: StorefrontCollectionView) {
//        if let collections = self.collections,
//           let lastCollection = collections.items.last {
//            collectionBaseVM.fetchCollections(after: lastCollection.cursor){ collections in
//                if let collections = collections {
//                    self.collections.appendPage(from: collections)
//                    self.collectionView.reloadData()
//
//                }
//            }
//        }
//    }
//
//    func collectionViewDidCompletePaging(_ collectionView: StorefrontCollectionView) {
//
//    }
//}

extension CatagoryViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collections?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KCatogoryCollectionViewCell, for: indexPath) as! CatogoryCollectionViewCell
        let collection = self.collections.items[indexPath.row]
        cell.configureFrom(collection)
        cell.shadow()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let collection         = self.collections.items[indexPath.row]
        let vc = self.storyboard!.instantiateViewController(identifier: "productsVC") as? productsVC
        vc?.collection = collection.id
        vc?.fetchType = 1
        vc!.hidesBottomBarWhenPushed = true
        vc?.titleNav = collection.title
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
}

extension CatagoryViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout         = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let itemSpacing    = layout.minimumInteritemSpacing * CGFloat(self.columns)
        let sectionSpacing = layout.sectionInset.left + layout.sectionInset.right
        let length         = (collectionView.bounds.width - itemSpacing - sectionSpacing) / CGFloat(self.columns)
        return CGSize(
            width:  length,
            height: length + 30.0
        )
    }
}

extension CatagoryViewController : NoInternetHandler {
    func retryAction(object : Any?) {
        if NetStatus.shared.isConnected {
        removeNoInternetConnection()
            self.fetchCollections()
            self.collectionView.reloadData()
        }
    }
}
