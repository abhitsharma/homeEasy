//
//  ProductImagesHeader.swift
//  HomeEassy
//
//  Created by Macbook on 20/09/23.
//

import UIKit
protocol imageDetailDelegate{
    func loadImageVC(images: [String], selectedImage: String)
}
let KImageCollectionCell = "ImageCollectionCell"
class ProductImagesHeader: UITableViewCell {

    @IBOutlet weak var imageCollection:UICollectionView!
    @IBOutlet weak var pageControl:UIPageControl!
    var allImages: [String] = []
    var delegate:imageDetailDelegate!
    var swipeDirection = "left"
    let columns:  Int = 1
    var indexImgOpen:Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageCollection.register(UINib.init(nibName: KImageCollectionCell, bundle: nil), forCellWithReuseIdentifier: KImageCollectionCell)
        
        
    }
    
    func setData(obj: [String]){
        self.allImages = obj
        self.pageControl.numberOfPages = obj.count
        //self.pageControl.currentPage = indexImgOpen ?? 0
        imageCollection.isPagingEnabled = true
        imageCollection.delegate = self
        imageCollection.dataSource = self
        self.pageControl.isUserInteractionEnabled = false
        if allImages.count == 1{
            pageControl.isHidden = true
            pageControl.isEnabled = false
        }
        else{
            pageControl.isHidden = false
            pageControl.isEnabled = true
            pageControl.numberOfPages = allImages.count
        }
        imageCollection.reloadData()
    }
    
    
    func updatePageCotrol() {
        
        if allImages.count>1{
            pageControl?.currentPage =  Int(floor(imageCollection.contentOffset.x / imageCollection.frame.size.width))
        }
        else{
            pageControl?.currentPage = Int(floor(imageCollection.contentOffset.x / imageCollection.frame.size.width))
        }
    }
    
    func infinateLoop() {
        if allImages.count>1{
            if let indexItem = self.imageCollection?.indexPathsForVisibleItems{
                if indexItem.count>0{
                    if let index=indexItem.first{
                        if index.row>=(allImages.count-1){
                            imageCollection?.scrollToItem(at: IndexPath(row:1, section: 0)  , at: .centeredHorizontally , animated: false)
                        }
                        else if index.row < 0{
                            imageCollection?.scrollToItem(at: IndexPath(row:allImages.count-2, section: 0)  , at: .centeredHorizontally , animated: false)
                        }
                        
                    }
                }
            }
        }
    }
    
}

extension ProductImagesHeader:UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KImageCollectionCell, for: indexPath) as! ImageCollectionCell
        let obj = allImages[indexPath.item]
        cell.setData(url: obj)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = allImages[indexPath.item] // Get the selected image
        indexImgOpen = indexPath.item
        delegate.loadImageVC(images: allImages, selectedImage: selectedImage)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
           // infinateLoop()
             updatePageCotrol()
     }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

           let length         = (collectionView.bounds.width) / CGFloat(self.columns)
                return CGSize(
                    width: length ,
                    height: length - 50
                )
    }
    
}


