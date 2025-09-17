//
//  ImageDetailCell.swift
//  HomeEassy
//
//  Created by Macbook on 22/09/23.
//

import UIKit

class ImageDetailCell: UICollectionViewCell, UIScrollViewDelegate {
    @IBOutlet weak var imageProduct:UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    override func awakeFromNib() {
        super.awakeFromNib()

        // Set up the UIScrollView
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 1.3 // Adjust as needed
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.zoomScale = 1.0
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentInset = .zero
        scrollView.contentOffset = .zero

        // Enable tap gesture for dismissing the zoomed view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        scrollView.addGestureRecognizer(tapGesture)
        tapGesture.numberOfTapsRequired = 2 // Double-tap to zoom
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Ensure that the image can be scrolled both horizontally and vertically
        adjustContentInset()
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        // Return the UIImageView to be zoomed
        return imageProduct
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // Ensure that the image can be scrolled both horizontally and vertically
        //adjustContentInset()
    }

    private func adjustContentInset() {
        let imageViewSize = imageProduct.frame.size
        scrollView.contentSize = imageViewSize // Set the content size based on the image size
        
        let scrollViewSize = scrollView.bounds.size

        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0

        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }


  
    @objc private func handleDoubleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            // Zoom in on double-tap
            let location = gestureRecognizer.location(in: imageProduct)
            let zoomRect = CGRect(x: location.x, y: location.y, width: 40, height: 40) // Adjust the zoom rectangle size as needed
            scrollView.zoom(to: zoomRect, animated: true)
        } else {
            // Zoom out to the minimum scale
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
    }


    func setData(url:String,hide:Bool){
        let url = URL(string: url)
        imageProduct.kf.setImage(with: url)
        if hide{
            imageProduct.isHidden = true
        }
        else{
            imageProduct.isHidden = false
        }
        imageProduct.contentMode = .scaleToFill
    }

}
