//
//  HomeViewController.swift
//  HomeEassy
//
//  Created by Swatantra singh on 29/07/23.
//

import UIKit
import SkeletonView
class HomeViewController: BaseVC {
    var homeViewModel: HomeViewModelProtocole = HomeViewModel()
    @IBOutlet var tbleView: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        bindDataModel()
        _ = CartController.shared
        homeViewModel.fetchCollections()
        addSearchButton()
//        addHomeMenuView()
        addHeaderView()
        tbleView?.estimatedRowHeight = 20
        tbleView?.register(UINib.init(nibName: kBaseWidgetTableCell, bundle: nil), forCellReuseIdentifier: kBaseWidgetTableCell)
        tbleView?.register(UINib.init(nibName: kFlashSellTableCell, bundle: nil), forCellReuseIdentifier: kFlashSellTableCell)
        // Do any additional setup after loading the view.
    }
    
    
    @objc func itemSelection(info:Notification){
        if let modelINfo = info.userInfo?["model"] as? CollectionModel   {
            let vc = StoryBoardHelper.controller(.category, type: productsVC.self)
            vc?.collection = modelINfo.id
            vc?.fetchType = 1
            vc?.titleNav = modelINfo.title
            vc!.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "notificationName"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        // setNavigationBarTitle("Home",inMiddle: true)
       
        addNoNetworkView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.itemSelection(info:)), name: NSNotification.Name(rawValue: "notificationName"), object: nil)
        self.setNavigationBarTitle("",inMiddle: true)
        addSideMenu()
        cartBadge()
//        self.view?.isSkeletonable = true
//        self.view?.showSkeleton(usingColor: .wisteria,transition: .crossDissolve(2.0))
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
//            self.view.hideSkeleton()
//        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeSideMenu()
    }
    
    func bindDataModel() {
        homeViewModel.apiCallBack = { [weak self] in
            guard let self = self else {return}
            cartBadge()
            self.tbleView?.reloadData()
           
        }
        
    }
   
    func openNewsDetailsWithNewsID(newsId: String) {
        if newsId.contains("Collection") {
            let product  = StoryBoardHelper.controller(.category , type: productsVC.self)!
            product.collection = newsId
            product.fetchType = 1
            product.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(product,animated: true)
        }
        else if newsId.contains("product") {
            if  let notificaton = StoryBoardHelper.controller(.category, type: ProductDetailVC.self){
                notificaton.productId = newsId
                self.navigationController?.pushViewController(notificaton,animated: true)
            }
        }
    }
    
    func addHeaderView() {
        if let image = UIImage(named:"AppImage") {
            let headerView = UIImageView(image: image)
            headerView.frame = CGRect(x: 5, y: 0, width: 53, height: 46)
            headerView.contentMode = .scaleAspectFit//.Left
            self.navigationItem.titleView = headerView
        }
//        let image = UIImage(named: "AppImage")
//        let imageView = UIImageView(image: image)
//        imageView.frame = CGRect(x: 5, y: 0, width: 53, height: 46)
//        let imageItem = UIBarButtonItem(customView: imageView)
//        self.navigationItem.leftBarButtonItem = imageItem
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        homeViewModel.widgets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let widget = homeViewModel.widgets?[indexPath.section],
           widget.hasData() {
            return widget.itemHeight()
        }
        return 1
    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 1
//    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let widget = homeViewModel.widgets?[indexPath.section],
           let identifier = widget.widgetType?.getCellIdentifier {
            cartBadge()
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? BaseWidgetTableCell {
                cell.reloadData(widget)
                return cell
            }
            
        }
        return UITableViewCell()
    }
    
    
//    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
//        if let widget = homeViewModel.widgets?[section], widget.widgetType == .banner{
//            return 0
//        }
//
//        return UITableView.automaticDimension
//    }
//    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let lab =  homeViewModel.widgets?[section].label, lab != ""{
            return 40
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let veiw1 = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 30))
        let lab = UILabel(frame: CGRect(x: 15, y: 5, width: SCREEN_WIDTH-30, height: 30))
        lab.textColor = .black
        lab.font = UIFont(name: NiveauGrotesk.Medium.rawValue, size: 15)
        veiw1.addSubview(lab)
        if let widget = homeViewModel.widgets?[section]
        {
            if let labText =  widget.label{
                lab.text = labText
                return veiw1
            }
        }
        return nil
    }
    
}

//extension HomeViewController :NoInternetHandler{
//    func retryAction(object: Any?) {
//        
//    }
//    
//}
