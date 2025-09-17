//
//  PresentionHandler.swift
//  FITOPPO
//
//  Created by swatantra on 2/8/17.
//  Copyright © 2017 swatantra. All rights reserved.
//

import Foundation
import UIKit
class CustomPresentationController: UIPresentationController {
    
    var dimmingView: UIView!
    // faded view
    var pView: UIView!
    var preferedSize = CGSize.zero
    // prefered content size. view over diming view
    var btnClose: UIButton!
    // close btn.
    var widthPercentage: CGFloat = 0.0
    var heighPercentage: CGFloat = 0.0
    
     init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController, withPreferedSize pSize: CGSize) {
            // set prefered size of content view
            self.preferedSize = pSize
            self.widthPercentage = self.preferedSize.width / UIScreen.main.bounds.size.width
            self.heighPercentage = self.preferedSize.height / UIScreen.main.bounds.size.height
            // set up dimming view and close button
            self.pView = presentedViewController.view
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        //return self after initialisation
        
    }
    func prepareDimmingView() {
        self.dimmingView = UIView()
        self.dimmingView.backgroundColor = UIColor.clear
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            self.dimmingView.alpha = 0.9
        })
      self.containerView?.insertSubview(self.dimmingView, at: 0)

      
        self.btnClose = UIButton(type: .custom)
      self.btnClose.backgroundColor = UIColor.clear
 self.btnClose.addTarget(self, action: #selector(self.dimmingViewTapped), for: .touchUpInside)

       /* self.btnClose.setTitle("✕", for: .normal)
        self.btnClose.isHidden = true
        self.btnClose.backgroundColor = UIColor.red
        self.btnClose.layer.cornerRadius = 10.0
        self.btnClose.clipsToBounds = true
        self.btnClose.setTitleColor(UIColor(red: CGFloat(9.0 / 255), green: CGFloat(22.0 / 255.0), blue: CGFloat(144.0 / 255), alpha: CGFloat(1.0)), for: .normal)
        //[self.btnClose setImage:[UIImage imageNamed:@"closebtn"] forState:UIControlStateNormal];
        dimmingView.addSubview(self.btnClose)
        self.btnClose.addTarget(self, action: #selector(self.dimmingViewTapped), for: .touchUpInside)
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dimmingViewTapped))
//        self.dimmingView.addGestureRecognizer(tap)
 */
    }
    
    @objc func dimmingViewTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            self.dimmingView.alpha = 0.0
        }, completion: {(_ finished: Bool) -> Void in
                       self.presentedViewController.dismiss(animated: true, completion: {  })
        })
    }

     func AframeOfPresentedViewInContainerView() -> CGRect {
        let  width: Float = Float( UIScreen.main.bounds.size.width) * Float( self.widthPercentage)
        let height: Float = Float(UIScreen.main.bounds.size.height) * Float(self.heighPercentage)
        return CGRect(x: CGFloat(Float((self.containerView?.center.x)!) - width / 2), y: CGFloat(Float((self.containerView?.center.y)!) - height / 2), width: CGFloat(width), height: CGFloat(height))

    }
 
    override func containerViewWillLayoutSubviews() {
        // Before layout, make sure our dimmingView and presentedView have the correct frame
       self.dimmingView.frame = CGRect.init(x: 0, y: 0, width: self.containerView!.bounds.size.width, height: self.containerView!.bounds.size.height)
      self.addingBlurEffect()
   
        let rectD = AframeOfPresentedViewInContainerView()
        self.presentedView?.frame = rectD
      self.btnClose.frame = rectD
      self.pView.insertSubview(btnClose, at: 0)
       self.presentedView?.backgroundColor=UIColor.clear
       /* let rect = self.frameOfPresentedViewInContainerView
        self.btnClose.frame = CGRect(x: rect.size.width - 30, y: rectD.origin.y-5, width: 20, height:20)
        self.btnClose.layer.cornerRadius = 10.0
     //   self.pView.bringSubview(toFront: btnClose)
 */
    }
    
    override func presentationTransitionWillBegin() {
        self.prepareDimmingView()
    }
    
    override func dismissalTransitionWillBegin() {
      UIView.animate(withDuration: 0.25, animations: {() -> Void in
        self.dimmingView.alpha = 0.0
      })
    }
  func addingBlurEffect()   {
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = self.dimmingView.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.dimmingView.addSubview(blurEffectView)

  }
}
class PresentionHandler: NSObject, UIAdaptivePresentationControllerDelegate, UIPopoverPresentationControllerDelegate, UIViewControllerTransitioningDelegate {
    var presentationStyle = UIModalPresentationStyle(rawValue: 0)
    var presenteddViewController: UIViewController!
    var presentinggViewController: UIViewController!
    var pcm: CustomPresentationController!
    var preferedSize = CGSize.zero
    var senderView: Any?

     init(viewControllerToBePresented VC: UIViewController, fromPresentingViewController pVC: UIViewController, withStyle style: UIModalPresentationStyle, fromView view: Any?, andPreferedSize size: CGSize) {
       
        
        self.presentationStyle = style
        self.presenteddViewController = VC
        self.presentinggViewController = pVC
        self.senderView = view
        self.preferedSize = size
        
        super.init()

        preparePresntedViewController()
    }
    
    func preparePresntedViewController() {
        self.presenteddViewController.modalPresentationStyle = self.presentationStyle!
        self.presenteddViewController!.transitioningDelegate = self

        if self.presentationStyle == UIModalPresentationStyle.popover {

            let obj = self.presenteddViewController!.popoverPresentationController!
           // obj.backgroundColor = UIColor.black
         // obj.containerView?.backgroundColor=UIColor.red
            obj.delegate = self
            if let vd = self.senderView as? UIBarButtonItem{
                obj.barButtonItem = vd
            }
            if let vd = self.senderView as? UIView{
                obj.sourceView = vd.superview
              obj.sourceRect = vd.frame ?? CGRect.zero
            }
           
            obj.permittedArrowDirections = .any
            if !self.preferedSize.equalTo(CGSize.zero) {
                self.presenteddViewController.preferredContentSize = self.preferedSize
            }
            self.presenteddViewController.popoverPresentationController?.backgroundColor = UIColor.white

        }
        else {
            let obj = self.presenteddViewController!.presentationController!
            obj.delegate = self
            self.presenteddViewController.view.layer.cornerRadius = 5.0
        }
        self.presentinggViewController.present(self.presenteddViewController, animated: true, completion: {  })
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle{
      
            if self.presentationStyle == .popover {
                return UIModalPresentationStyle.none
            }
            return self.presentationStyle!
        
    }
  
 func  presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    return CustomPresentationController(presentedViewController : self.presenteddViewController , presenting : self.presentinggViewController , withPreferedSize: preferedSize)
    }
    func popoverPresentationController(_ popoverPresentationController: UIPopoverPresentationController, willRepositionPopoverTo rect: UnsafeMutablePointer<CGRect>, in view: AutoreleasingUnsafeMutablePointer<UIView>){
       // var btn: UIButton? = (self.senderView as? UIButton)
      //  rect = btn?.frame
       // view = self.senderView.superview

    }

    
      }
