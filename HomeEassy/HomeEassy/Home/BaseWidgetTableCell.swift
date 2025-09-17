//
//  BaseWidgetTableCell.swift
//  HomeEassy
//
//  Created by Macbook on 16/10/23.
//

import UIKit

let kBaseWidgetTableCell = "BaseWidgetTableCell"
let kFlashSellTableCell = "FlashSellTableCell"

protocol BaseWidgetTableCellProtocole {
    var widget : Widget? {get set}
    func reloadData(_ widget : Widget?)
    
}

class BaseWidgetTableCell: UITableViewCell {
    @IBOutlet var colletionView: UICollectionView?
    @IBOutlet var pageControler:UIPageControl?
    var timer: Timer?
    var currentPage = 0
    var totalItems:Int?
    var baseWidgetDataHandler: BaseWidgetDataHandlerProtocole?
    func reloadData(_ widget : Widget?) {
            colletionView?.registerNibName(kBannerCollectionViewCell, forCellWithReuseIdentifier: kBannerCollectionViewCell)
            colletionView?.registerNibName(kTopCategoryCollectionCell, forCellWithReuseIdentifier: kTopCategoryCollectionCell)
        colletionView?.registerNibName(kMidCategoryCollectionCell, forCellWithReuseIdentifier: kMidCategoryCollectionCell)
        colletionView?.registerNibName(kFlashCollectionCell, forCellWithReuseIdentifier: kFlashCollectionCell)
        if let widgetType =  widget?.widgetType, let widgetCount = widget?.widgetData?.count,widgetType == .banner,widgetCount > 1{
            pageControler?.numberOfPages = widgetCount
            pageControler?.isHidden = false
            totalItems = widgetCount
            //timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(scrollToNextPage), userInfo: nil, repeats: true)
        }
        else {
            pageControler?.numberOfPages = 0
            pageControler?.isHidden = true
            totalItems = 1
        }
        
        let dataHandler = BannerWidgetDataHandler()
        dataHandler.widget = widget
        dataHandler.pageConrol = self.pageControler
        baseWidgetDataHandler = dataHandler
        colletionView?.delegate = dataHandler
        
        colletionView?.dataSource = dataHandler
        colletionView?.reloadData()
    }
    
    @objc func scrollToNextPage() {
        currentPage += 1
        pageControler?.currentPage = currentPage
        // Check if we reached the last page, and if so, scroll to the first page
        if currentPage == totalItems {
            currentPage = 0
            pageControler?.currentPage = currentPage
        }
        
        // Scroll to the next page
        let indexPath = IndexPath(item: currentPage, section: 0)
        colletionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
}


