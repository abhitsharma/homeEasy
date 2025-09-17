//
//  UICollectionView+Extention.swift
//  CLG
//
//  Created by Aravind Kumar on 04/09/21.
//

import Foundation
import UIKit

extension UICollectionView {
    func registerForCell(with cellIdnteifer:String,usingDataSource dataSource:UICollectionViewDataSource,forDelegat delegate:UICollectionViewDelegate?)  {
        
        self.register(UINib.init(nibName: cellIdnteifer, bundle: nil), forCellWithReuseIdentifier: cellIdnteifer)
        self.dataSource = dataSource
        self.delegate = delegate

 }
}

extension UITableView {
    func updateHeaderViewHeight() {
            if let header = self.tableHeaderView {
                let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
                var headerFrame = header.frame
                //Comparison necessary to avoid infinite loop
                if height != headerFrame.size.height {
                    headerFrame.size.height = height+10
                    header.frame = headerFrame
                    self.tableHeaderView = header
                }
            }
    }
}

extension UITableView {
    func registerNibName(_ nibName : String, forCellWithReuseIdentifier identifier : String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
    func registerNibName(_ nibName : String, forCellHeaderFooter identifier : String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier:identifier)
    }
    
}


extension UICollectionView {
    
    func registerNibName(_ nibName : String, forCellWithReuseIdentifier identifier : String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        
        self.register(nib, forCellWithReuseIdentifier: identifier)
    }
    func registerNibName(_ nibName : String, withReuseIdentifier identifier : String,forSupplementaryViewOfKind type: String ) {
        let nib = UINib(nibName: nibName, bundle: nil)
        self.register(nib, forSupplementaryViewOfKind: type, withReuseIdentifier: identifier)
    }
}

extension UIViewController {
    
    func dismissModalStack(_ animated: Bool, completion: (() -> Void)?) {
        if let fullscreenSnapshot = UIApplication.shared.delegate?.window??.snapshotView(afterScreenUpdates: false) {
            presentedViewController?.view.addSubview(fullscreenSnapshot)
        }
        if !isBeingDismissed {
            dismiss(animated: animated, completion: completion)
        }
    }
    
}
