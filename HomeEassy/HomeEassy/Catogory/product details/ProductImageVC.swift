//
//  ProductImageVC.swift
//  HomeEassy
//
//  Created by Macbook on 22/09/23.
//



import UIKit
let KImageDetailCell = "ImageDetailCell"
class ProductImageVC: BaseVC {
    let columns:  Int = 1
      var hide = true
      @IBOutlet weak var collectionView:UICollectionView!
      @IBOutlet weak var pageControl:UIPageControl!
      var images: [String]!
      var selectedImage: String!
      var activityIndicator: UIActivityIndicatorView!
      @IBOutlet weak var Btndismiss:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib.init(nibName: KImageDetailCell, bundle: nil), forCellWithReuseIdentifier: KImageDetailCell)
        collectionView.delegate = self
        collectionView.dataSource = self
        self.pageControl.currentPage = images.firstIndex(of: selectedImage)!
        collectionView.isPagingEnabled = true

        if images.count == 1{
            pageControl.isHidden = true
            pageControl.isEnabled = false
        }
        else{
            pageControl.isHidden = false
            pageControl.isEnabled = true
            pageControl.numberOfPages = images.count
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if images.count <= 1{
            hide = false
            collectionView.reloadData()
        }
        else{
            if let selectedIndex = images.firstIndex(of: selectedImage) {
                let indexPath = IndexPath(item: selectedIndex, section: 0)
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                //self.dismissLoader()
                self.pageControl.currentPage = indexPath.row
                hide = false
                if indexPath.row == 0{
                    collectionView.reloadData()
                }
            }
        }
    }
    
    @IBAction func actionDismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func updatePageCotrol() {
        if images.count>1{
            pageControl?.currentPage =  Int(floor(collectionView.contentOffset.x / collectionView.frame.size.width))
        }
        else{
            pageControl?.currentPage = Int(floor(collectionView.contentOffset.x / collectionView.frame.size.width))
        }
        
        if pageControl?.currentPage == 0{
            hide = false
            collectionView.reloadData()
        }
    }

}

extension ProductImageVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KImageDetailCell, for: indexPath) as! ImageDetailCell
        let obj = images[indexPath.item]
        cell.setData(url: obj,hide: hide)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let length = (collectionView.bounds.width) / CGFloat(self.columns)
        return CGSize(
            width: length,
            height: length
        )
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
             updatePageCotrol()
     }
    
}
    


