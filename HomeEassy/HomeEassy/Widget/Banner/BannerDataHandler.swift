//
//  BannerDataHandler.swift
//  HomeEassy
//
//  Created by Swatantra singh on 11/10/23.
//

import Foundation
import UIKit
import Kingfisher
import SkeletonView
protocol BaseWidgetDataHandlerProtocole {
    var widget : Widget? {get set}
}

class BannerWidgetDataHandler: NSObject, BaseWidgetDataHandlerProtocole {
    var widget: Widget?
    var pageConrol:UIPageControl?
    
}

extension BannerWidgetDataHandler: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        widget?.widgetData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = widget?.widgetSubType ?? widget?.widgetType
        switch  type {
        case .banner:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kBannerCollectionViewCell, for: indexPath) as! BannerCollectionViewCell
            let itemCount = (widget?.widgetData?.count)!
            if itemCount > 1 {
                if let wData = widget?.widgetData?[indexPath.row] as? CollectionModel {
                    cell.imgView?.kf.setImage(with: wData.imageURL, placeholder: UIImage())
                    cell.imgView?.contentMode = .scaleToFill
                }
                return cell
            }
            else {
                if let wData = widget?.widgetData?[indexPath.row] as? CollectionModel {
                    cell.imgView?.kf.setImage(with: wData.imageURL, placeholder: UIImage())
                    cell.imgView?.contentMode = .scaleToFill
                    cell.cornerRadius = 10
                }
                return cell
            }
          
        case .category_1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kTopCategoryCollectionCell, for: indexPath) as! TopCategoryCollectionCell
            if let wData = widget?.widgetData?[indexPath.row] as? CollectionModel {
                cell.imgView?.kf.setImage(with: wData.imageURL, placeholder: UIImage())
                cell.imgView?.contentMode = .scaleToFill
                cell.nameLab.text = wData.title
            }
            return cell
        case .category_2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kMidCategoryCollectionCell, for: indexPath) as! MidCategoryCollectionCell
            if let wData = widget?.widgetData?[indexPath.row] as? CollectionModel {
                cell.imgView?.kf.setImage(with: wData.imageURL, placeholder: UIImage())
                cell.imgView?.contentMode = .scaleToFill
                cell.nameLab.text = wData.title
            }
            return cell
        
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kBannerCollectionViewCell, for: indexPath) as! BannerCollectionViewCell
            if let wData = widget?.widgetData?[indexPath.row] as? CollectionModel {
                cell.imgView?.kf.setImage(with: wData.imageURL, placeholder: UIImage())
                cell.imgView?.contentMode = .scaleToFill
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return widget?.itemSize(widget?.widgetSubType) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch self.widget?.widgetType {
        case .banner:
            return 0
        default:
            return kpaddingForPLPImage
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch self.widget?.widgetType {
        case .banner:
            return 0
        default:
            return kpaddingForPLPImage
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch self.widget?.widgetType {
        case .banner:
              return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            return UIEdgeInsets(top: 0, left: kpaddingForPLPImage, bottom: 0, right: kpaddingForPLPImage)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let wData = widget?.widgetData?[indexPath.row] as? CollectionModel
    let userInfo = ["model":wData]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: userInfo as [AnyHashable : Any])
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            
        if  widget?.widgetData?.count ?? 0>1{
                self.pageConrol?.currentPage =  Int(floor(scrollView.contentOffset.x / scrollView.frame.size.width))
            }
            else{
                self.pageConrol?.currentPage = Int(floor(scrollView.contentOffset.x / scrollView.frame.size.width))
            }
        
    }
}
