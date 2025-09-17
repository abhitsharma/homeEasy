//
//  NoNetworkView.swift
//  CLG
//
//  Created by Aravind Kumar on 15/12/21.
//

import UIKit

class NoNetworkView: UIView {
    var view: UIView!
   
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
        bringSubviewToFront(view)
    }
    
    func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: "NoNetworkView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
}
