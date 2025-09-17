//
//  CLGTabBarViewController.swift
//  CLG
//
//  Created by Aravind Kumar on 31/08/21.
//

import UIKit
private let scale  = "transform.scale"
class CLGTabBar : UITabBar {
  override open func sizeThatFits(_ size: CGSize) -> CGSize {
    var sizeThatFits = super.sizeThatFits(size)
    sizeThatFits.height = sizeThatFits.height+10 // adjust your size here
    return sizeThatFits
  }
}

class CLGTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: AppColor.appDarkColor, size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count * 2), height: tabBar.frame.height), lineHeight: 2.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
   
 
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
    override internal func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
 
    }
    func playBounceAnimation(_ icon : UIImageView) {
      let duration = 0.325
      let bounceAnimation = CAKeyframeAnimation(keyPath: scale)
      bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
      bounceAnimation.duration = TimeInterval(duration)
      bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
      icon.layer.add(bounceAnimation, forKey: nil)
    }
    
    func updateBadgeCount(value : Int?) {
      if let items = self.tabBar.items,let value=value {
        if items.count > 1 && value>0 {
          items[1].badgeValue = String(value)
        }
        else{
            items[1].badgeValue = nil
        }
       }
    }
}



class HideTabBar {
  var isEnable=true
  var maxTabHeight: CGFloat = 0;
  var minTabHeight: CGFloat = 0
  var previousScrollOffset: CGFloat = 0;
  var tabBarcontroler:UITabBarController?
    var bottomInset: CGFloat = 0;
  init(tab:UITabBarController) {
    self.tabBarcontroler=tab
      self.bottomInset = tab.tabBar.frame.height - (self.tabBarcontroler?.view.safeAreaInsets.bottom ?? 0.0)
    self.maxTabHeight = SCREEN_HEIGHT
    self.minTabHeight = (self.tabBarcontroler?.tabBar.frame.origin.y ?? 618)
      
  }
  func hideTabBar(_ scrollView: UIScrollView) {
    let (isScrollingDown,isScrollingUp,scrollDiff)=getScrollDirection(scrollView)
    
    var framTabBar=self.tabBarcontroler?.tabBar.frame ?? CGRect.zero
    var tabValue:CGFloat=0.0
    
    if isScrollingDown{
      tabValue=min(self.maxTabHeight, framTabBar.origin.y + abs(scrollDiff))

      framTabBar.origin.y=tabValue
      self.tabBarcontroler?.tabBar.frame=framTabBar
    }
    if isScrollingUp{
      tabValue=max(self.minTabHeight, framTabBar.origin.y - abs(scrollDiff))
      framTabBar.origin.y=tabValue
      self.tabBarcontroler?.tabBar.frame=framTabBar
    }
    
  }
  
  func resetTabBar() {
    var framTabBar=self.tabBarcontroler?.tabBar.frame ?? CGRect.zero
    let tabValue:CGFloat=self.minTabHeight//stausbar
    framTabBar.origin.y=tabValue
    self.tabBarcontroler?.tabBar.frame=framTabBar
    
  }
  
  func getScrollDirection(_ scrollView: UIScrollView) -> (Bool,Bool,CGFloat) {
    let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
    let absoluteTop: CGFloat = 0;
    let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;
    let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
    let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
    self.previousScrollOffset=scrollView.contentOffset.y
    return(isScrollingDown,isScrollingUp,scrollDiff)
  }
  
  
}
