//
//  BaseVC.swift
//  KoovsOnlineFashion
//
//  Created by Koovs on 16/08/16.
//  Copyright © 2016 Koovs. All rights reserved.
//

import Foundation
import UIKit
import DGActivityIndicatorView
import Reachability
protocol BaseVCDElegate {
    func getNetworkStatusChangeData(isConneted:Bool)
}


open class BaseVC: UIViewController {
    var navigationTitle : String?
    var nodataVC : NoDataVC?
    var noInternetVC : NoInternetVC?
    var noInternetVCPresent = false
    var loader = DGActivityIndicatorView(type: .ballSpinFadeLoader, tintColor: UIColor(named: "CustomBlack"), size: 50)!
    var notificationForReachability : NSObjectProtocol?
    var viewaddedd = false
    var cartButton:UIBarButtonItem!
    var wishlistButton:UIBarButtonItem!
    private var sideMenuViewController: SideMenuViewController!
    private var sideMenuShadowView: UIView!
    private var sideMenuRevealWidth: CGFloat = 260
    private let paddingForRotation: CGFloat = 150
    private var isExpanded: Bool = false
    private var draggingIsEnabled: Bool = false
    private var panBaseLocation: CGFloat = 0.0
    var noInternetdelegate:BaseVCDElegate?
    // Expand/Collapse the side menu by changing trailing's constant
    private var sideMenuTrailingConstraint: NSLayoutConstraint!
    var noNetworkView: NoNetworkView = {
        let view = NoNetworkView.init(frame: .zero)
        view.alpha = 0.0
        view.isHidden = true
        return view
    }()
    private var revealSideMenuOnTop: Bool = true
    
    var gestureEnabled: Bool = true
    //var reachability = try! Reachability()
    private var reachability = CLReachability()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        trnasparentNaviagtion()
        cartBadge()
        self.view.backgroundColor = AppColor.appHeaderBgColor
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        if (self.navigationController?.viewControllers.count ?? 0) > 1 {
            self.addBackButton()
        }
    }
    deinit {
        self.reachability?.stopNotifier()
        self.reachability = nil
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let hndler = self as? NoInternetHandler{
            noInternetVC?.delegate = hndler
        }
        cartBadge()
        NetStatus.shared.netStatusChangeHandler = { path in
            DispatchQueue.main.async { [weak self] in
                if path.status == .satisfied {
                    print("We're connected!")
                    self?.handleReachabilityChange()
                   self?.refeshNoNetworkData(isConneted: true)
                    self?.noInternetdelegate?.getNetworkStatusChangeData(isConneted: true)
                } else {
                    
                    self?.showNetworkView(isConneted: false)
              self?.refeshNoNetworkData(isConneted: false)
                    self?.noInternetdelegate?.getNetworkStatusChangeData(isConneted: false)
                }
            }
        }
    }
    
    func trnasparentNaviagtion() {
        guard let _ =  self.navigationController else {
            return
        }
      //  self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.view.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppColor.appDarkColor]

    }
    
    func cartBadge(){
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                if CartController.shared.itemCount > 0 && AccountController.shared.accessToken != nil{
                    self.tabBarController?.tabBar.items?[4].badgeValue = "\(CartController.shared.itemCount)"
                }
                else{
                    self.tabBarController?.tabBar.items?[4].badgeValue = nil
                }
            }}
    }
    
    final func showLoader() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loader.alpha = 0
            strongSelf.loader.center = strongSelf.view.center
            strongSelf.view.bringSubviewToFront(strongSelf.loader)
            UIView.animate(withDuration: 0.3) {
                strongSelf.view.addSubview(strongSelf.loader)
                strongSelf.loader.alpha = 1
                strongSelf.loader.startAnimating()
                self?.cartBadge()
            }
        }
    }
    
    final func dismissLoader() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            UIView.animate(withDuration: 0.3, animations: {
                strongSelf.loader.alpha = 0
            }) { [weak self] (_) in
                guard let strongSelf = self else { return }
                strongSelf.loader.stopAnimating()
                strongSelf.loader.removeFromSuperview()
            }
        }
    }
    
    func addHomeMenuView() {
        let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        leftButton.setImage(UIImage(named: "menu"), for: .normal)
        leftButton.addTarget(self, action: #selector(toggleLeft), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
    }
    
    @objc func toggleLeft() {
        
    }
    
    func handleReachabilityChange() {
        // DispatchQueue.main.async {[weak self] in
        self.noInternetVC?.view.removeFromSuperview()
        if let delget = self.noInternetVC?.delegate{
            delget.retryAction(object: nil)
        }
    }
    
 
    
    func addBackButton(){
        let barButton = UIBarButtonItem(image: UIImage(named: AppImage.BackButtonImage)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal) , style: .plain, target: self, action: #selector(BaseVC.backButton))
        self.navigationItem.leftBarButtonItems = [barButton]
        self.navigationItem.backBarButtonItem = nil
        tabBarController?.tabBar.items?[4].badgeValue = "\(CartController.shared.itemCount)"

    }
    
    func updateHeaderTitle(_ inMiddle: Bool) {
        let title = self.navigationTitle ?? ""
        (self.navigationController as? KVSNavigationController)?.setBarTitle(title.uppercased(),inMiddle: inMiddle)
    }
    
    func setNavigationBarTitle(_ barTitle : String, inMiddle: Bool = false) {
        self.navigationTitle = barTitle
        updateHeaderTitle(inMiddle)
    }
    
    func addSearchButton() {
        let barButton = UIButton(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        barButton.setBackgroundImage(UIImage(named: "searchProducts"), for: .normal)
        barButton.addTarget(self, action: #selector(self.initiateSearch), for: .touchUpInside)
        let barButton1 = UIBarButtonItem(customView: barButton)
        self.navigationItem.rightBarButtonItems = [barButton1]
    }
    
    func addCartWishlist() {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        cartButton = createBarButton(image: UIImage(named: "tab_bag")!, action: #selector(didTapCartButton))
        wishlistButton = createBarButton(image: UIImage(named: "tab_wishlist")!, action: #selector(didTapWishlistButton))
        let buttonFontSize: CGFloat = 18
        cartButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: buttonFontSize)], for: .normal)
        wishlistButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: buttonFontSize)], for: .normal)
        if CartController.shared.itemCount > 0 && AccountController.shared.accessToken != nil {
            setBadge(for: cartButton, count: CartController.shared.itemCount)
        } else {
            removeBadge(for: cartButton)
        }
        
        navigationItem.rightBarButtonItems = [cartButton, flexibleSpace,wishlistButton]
    }
    
    @objc func didTapCartButton() {
                tabBarController?.selectedIndex = 4
                navigationController?.popToRootViewController(animated: true)
        
    }
    
    @objc func didTapWishlistButton() {
                tabBarController?.selectedIndex = 3
                navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func initiateSearch() {
        let searchVC = StoryBoardHelper.controller(.home, type: SearchViewControler.self)
        searchVC!.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(searchVC!, animated: false)
    }
    
    func addSideMenu(){
        let barButton = UIButton(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        barButton.setBackgroundImage(UIImage(named: "menu"), for: .normal)
        barButton.addTarget(self, action: #selector(self.initiateMenu), for: .touchUpInside)
        let barButton1 = UIBarButtonItem(customView: barButton)
        self.navigationItem.leftBarButtonItem = barButton1
        self.sideMenuShadowView = UIView(frame: self.view.bounds)
        self.sideMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.sideMenuShadowView.backgroundColor = .black
        self.sideMenuShadowView.alpha = 0.0
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapGestureRecognizer))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        self.sideMenuShadowView.addGestureRecognizer(tapGestureRecognizer)
        if self.revealSideMenuOnTop {
            view.insertSubview(self.sideMenuShadowView, at: 1)
            view.bringSubviewToFront(self.sideMenuShadowView)
                    }

        // Side Menu
        let storyboard = StoryBoardHelper.controller(.main, type: SideMenuViewController.self)
        self.sideMenuViewController = storyboard
        
        self.sideMenuViewController.defaultHighlightedCell = 0 // Default Highlighted Cell
        self.sideMenuViewController.delegate = self
        view.insertSubview(self.sideMenuViewController!.view, at: self.revealSideMenuOnTop ? 2 : 0)
        view.bringSubviewToFront(self.sideMenuViewController.view)

        addChild(self.sideMenuViewController!)
        self.sideMenuViewController!.didMove(toParent: self)

        // Side Menu AutoLayout

        self.sideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false

        if self.revealSideMenuOnTop {
            self.sideMenuTrailingConstraint = self.sideMenuViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -self.sideMenuRevealWidth - self.paddingForRotation)
            self.sideMenuTrailingConstraint.isActive = true
        }
        NSLayoutConstraint.activate([
            self.sideMenuViewController.view.widthAnchor.constraint(equalToConstant: self.sideMenuRevealWidth),
            self.sideMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.sideMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])

        // Side Menu Gestures
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func initiateMenu() {
        revealSideMenu()
    }
    
    func addNodataView() {
        if nodataVC == nil {
            nodataVC = StoryBoardHelper.controller(.main, type: NoDataVC.self)
            nodataVC?.delegate = (self as? NoDataVCDelegate)
            nodataVC?.dataSource = (self as? NoDataVCDataSource)
            self.addChild(nodataVC!)
            nodataVC?.view.frame = (self as? NoDataVCDataSource)?.noDataViewFrame?() ?? self.view.bounds
            self.view.addSubview(nodataVC!.view)
        }
    }
    
    func removeNoDataView() {
        if nodataVC != nil {
            nodataVC?.removeFromParent()
            nodataVC?.view.removeFromSuperview()
            nodataVC?.delegate = nil
            nodataVC?.dataSource = nil
            nodataVC = nil
        }
    }
    
    
    @IBAction func backButton() {
        if (self.navigationController?.viewControllers.count ?? 0) > 1 {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    override open var prefersStatusBarHidden : Bool {
        return false
    }
    
    func refeshNoNetworkData(isConneted:Bool) {
     print(isConneted)
        noInternetdelegate?.getNetworkStatusChangeData(isConneted:isConneted)
        
    }
    
    func handleNoInternetConnection() {
        if noInternetVC == nil {
            noInternetVC = StoryBoardHelper.controller(.main, type: NoInternetVC.self)
            noInternetVC?.delegate = (self as?   NoInternetHandler )
            noInternetVC?.dataSource = (self as? NoInternetVCDataSource)
            self.addChild(noInternetVC!)
            noInternetVC?.view.frame = (self as? NoInternetVCDataSource)?.noDataViewFrame?() ?? self.view.bounds
            self.view.addSubview(noInternetVC!.view)
        }
    }

    
    
    func removeNoInternetConnection() {
        if noInternetVC != nil {
            noInternetVC?.removeFromParent()
            noInternetVC?.view.removeFromSuperview()
            noInternetVC?.delegate = nil
            noInternetVC?.dataSource = nil
            noInternetVC = nil
        }
    }
    

}

class KVSNavigationController : UINavigationController, UIGestureRecognizerDelegate {
    var titleLabel : UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    func setBarTitle(_ title : String, inMiddle: Bool) {
        if titleLabel == nil {
            let bounds = self.navigationBar.bounds
            titleLabel = UILabel(frame:CGRect(x: 50.0, y: 0, width: bounds.width-130, height: bounds.height))//(frame: bounds.insetBy(dx: 100, dy: 0))
            titleLabel?.textAlignment = .left
            if inMiddle {
                titleLabel?.frame=bounds.insetBy(dx: 100, dy: 0)
                titleLabel?.textAlignment = .center
            }
           
            titleLabel?.backgroundColor = UIColor.clear
            titleLabel?.numberOfLines=0
            titleLabel?.textColor = AppColor.appDarkColor
            self.navigationBar.addSubview(titleLabel!)
            titleLabel?.font = UIFont(name: NiveauGrotesk.Medium.rawValue, size: 15)
            titleLabel?.text = title
        }
        titleLabel?.text = title
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer is UIScreenEdgePanGestureRecognizer else { return true }
        return (viewControllers.count > 1)
    }
    
}

class StoryBoardHelper : NSObject {
    
    class func controller<T>(_ storyBoardType : StoryBoardType, type : T.Type ) -> T? {
        let storyboard = UIStoryboard(name: storyBoardType.rawValue , bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: type)) as? T
    }
    
}

extension BaseVC {
    func addNoNetworkView() {
        if !viewaddedd {
            let margins=self.view.layoutMarginsGuide
            view.addSubview(noNetworkView)
            noNetworkView.translatesAutoresizingMaskIntoConstraints = false
            self.noNetworkView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            self.noNetworkView.heightAnchor.constraint(equalToConstant: 60).isActive = true
            noNetworkView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            noNetworkView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 30).isActive = true
            startReachabilityObserver()
            self.view.bringSubviewToFront(noNetworkView)
        }
    }
    
    func showNetworkView(isConneted:Bool) {
        DispatchQueue.main.async {
            self.view.bringSubviewToFront(self.noNetworkView)
            if isConneted {
                self.handleReachabilityChange()

            } else {
                self.removeNoDataView()
            }
        }
    }
}

public extension BaseVC {
    func startReachabilityObserver() -> Void {
        guard let reachability = self.reachability else { return }
        reachability.startNotifier()

        reachability.onUnreachable = {[weak self] reachability in
            self?.showNetworkView(isConneted: false)
        }
        reachability.onReachable = { [weak self] reachability in
            guard let self = self else { return }
            self.showNetworkView(isConneted: true)
        }
    }

    func stopReachabilityObserver() -> Void {
        self.reachability?.stopNotifier()
    }

    /// Public Method to check the network  status
    /// - Returns: Boolean
    func connectivityAvailable() -> Bool {
        guard let reachability = self.reachability else { return false}
        return reachability.isReachable
    }
}


// left menu
public extension BaseVC{
    // Keep the state of the side menu (expanded or collapse) in rotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint.constant = self.isExpanded ? 0 : (-self.sideMenuRevealWidth - self.paddingForRotation)
            }
        }
    }

    func animateShadow(targetPosition: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            // When targetPosition is 0, which means side menu is expanded, the shadow opacity is 0.6
            self.sideMenuShadowView.alpha = (targetPosition == 0) ? 0.6 : 0.0
        }
    }

    // Call this Button Action from the View Controller you want to Expand/Collapse when you tap a button
    func revealSideMenu() {
        self.sideMenuState(expanded: self.isExpanded ? false : true)
    }
    
    func removeSideMenu(){
        sideMenuState(expanded: false)
    }

    func sideMenuState(expanded: Bool) {
        if expanded {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? 0 : self.sideMenuRevealWidth) { _ in
                self.isExpanded = true
            }
            // Animate Shadow (Fade In)
            UIView.animate(withDuration: 0.5) { self.sideMenuShadowView.alpha = 0.6 }
        }
        else {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? (-self.sideMenuRevealWidth - self.paddingForRotation) : 0) { _ in
                self.isExpanded = false
            }
            // Animate Shadow (Fade Out)
            UIView.animate(withDuration: 0.5) { self.sideMenuShadowView.alpha = 0.0 }
        }
    }
    
    func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint.constant = targetPosition
                self.view.layoutIfNeeded()
            }
            else {
                self.view.subviews[1].frame.origin.x = targetPosition
            }
        }, completion: completion)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension BaseVC: SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int, id: String, title: String) {
        let vc = StoryBoardHelper.controller(.category, type: productsVC.self)
        vc?.collection = id
        vc?.fetchType = 1
        vc!.hidesBottomBarWhenPushed = true
        vc?.titleNav = title
        DispatchQueue.main.async { self.sideMenuState(expanded: false) }
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func showViewController<T: UIViewController>(viewController: T.Type, storyboardId: String) -> () {
        // Remove the previous View
        for subview in view.subviews {
            if subview.tag == 99 {
                subview.removeFromSuperview()
            }
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
        vc.view.tag = 99
        view.insertSubview(vc.view, at: self.revealSideMenuOnTop ? 0 : 1)
        addChild(vc)
        DispatchQueue.main.async {
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                vc.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                vc.view.topAnchor.constraint(equalTo: self.view.topAnchor),
                vc.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                vc.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
        }
        if !self.revealSideMenuOnTop {
            if isExpanded {
                vc.view.frame.origin.x = self.sideMenuRevealWidth
            }
            if self.sideMenuShadowView != nil {
                vc.view.addSubview(self.sideMenuShadowView)
            }
        }
        vc.didMove(toParent: self)
    }
}

extension BaseVC: UIGestureRecognizerDelegate {
    @objc func TapGestureRecognizer(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if self.isExpanded {
                self.sideMenuState(expanded: false)
            }
        }
    }

    // Close side menu when you tap on the shadow background view
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.sideMenuViewController.view))! {
            return false
        }
        return true
    }
    
    // Dragging Side Menu
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
        guard gestureEnabled == true else { return }
        let position: CGFloat = sender.translation(in: self.view).x
        let velocity: CGFloat = sender.velocity(in: self.view).x
        switch sender.state {
        case .began:

            // If the user tries to expand the menu more than the reveal width, then cancel the pan gesture
            if velocity > 0, self.isExpanded {
                sender.state = .cancelled
            }

            // If the user swipes right but the side menu hasn't expanded yet, enable dragging
            if velocity > 0, !self.isExpanded {
                self.draggingIsEnabled = true
            }
            // If user swipes left and the side menu is already expanded, enable dragging
            else if velocity < 0, self.isExpanded {
                self.draggingIsEnabled = true
            }

            if self.draggingIsEnabled {
                // If swipe is fast, Expand/Collapse the side menu with animation instead of dragging
                let velocityThreshold: CGFloat = 550
                if abs(velocity) > velocityThreshold {
                    self.sideMenuState(expanded: self.isExpanded ? false : true)
                    self.draggingIsEnabled = false
                    return
                }

                if self.revealSideMenuOnTop {
                    self.panBaseLocation = 0.0
                    if self.isExpanded {
                        self.panBaseLocation = self.sideMenuRevealWidth
                    }
                }
            }

        case .changed:

            // Expand/Collapse side menu while dragging
            if self.draggingIsEnabled {
                if self.revealSideMenuOnTop {
                    // Show/Hide shadow background view while dragging
                    let xLocation: CGFloat = self.panBaseLocation + position
                    let percentage = (xLocation * 150 / self.sideMenuRevealWidth) / self.sideMenuRevealWidth

                    let alpha = percentage >= 0.6 ? 0.6 : percentage
                    self.sideMenuShadowView.alpha = alpha

                    // Move side menu while dragging
                    if xLocation <= self.sideMenuRevealWidth {
                        self.sideMenuTrailingConstraint.constant = xLocation - self.sideMenuRevealWidth
                    }
                }
                else {
                    if let recogView = sender.view?.subviews[1] {
                        // Show/Hide shadow background view while dragging
                        let percentage = (recogView.frame.origin.x * 150 / self.sideMenuRevealWidth) / self.sideMenuRevealWidth

                        let alpha = percentage >= 0.6 ? 0.6 : percentage
                        self.sideMenuShadowView.alpha = alpha

                        // Move side menu while dragging
                        if recogView.frame.origin.x <= self.sideMenuRevealWidth, recogView.frame.origin.x >= 0 {
                            recogView.frame.origin.x = recogView.frame.origin.x + position
                            sender.setTranslation(CGPoint.zero, in: view)
                        }
                    }
                }
            }
        case .ended:
            self.draggingIsEnabled = false
            // If the side menu is half Open/Close, then Expand/Collapse with animation
            if self.revealSideMenuOnTop {
                let movedMoreThanHalf = self.sideMenuTrailingConstraint.constant > -(self.sideMenuRevealWidth * 0.5)
                self.sideMenuState(expanded: movedMoreThanHalf)
            }
            else {
                if let recogView = sender.view?.subviews[1] {
                    let movedMoreThanHalf = recogView.frame.origin.x > self.sideMenuRevealWidth * 0.5
                    self.sideMenuState(expanded: movedMoreThanHalf)
                }
            }
        default:
            break
        }
    }
}

extension BaseVC{
    func createBarButton(image: UIImage, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 15)
        //button.
        button.addTarget(self, action: action, for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        return barButton
    }

    func setBadge(for barButton: UIBarButtonItem, count: Int) {
        let badgeLabel = UILabel()
        badgeLabel.text = "\(count)"
        badgeLabel.textColor = UIColor.white
        badgeLabel.backgroundColor = UIColor.red
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 8
        badgeLabel.layer.masksToBounds = true
        badgeLabel.font = UIFont.systemFont(ofSize: 12) // Adjust font size
        badgeLabel.frame = CGRect(x: 15, y: -5, width: 16, height: 16) // Adjust frame size

        if let customView = barButton.customView {
            customView.addSubview(badgeLabel)
        }
    }


    func removeBadge(for barButton: UIBarButtonItem) {
        if let customView = barButton.customView {
            customView.subviews.forEach { $0.removeFromSuperview() }
        }
    }
}

