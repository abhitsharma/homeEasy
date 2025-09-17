//
//  EditCartViewController.swift
//  HomeEassy
//
//  Created by Macbook on 21/11/23.
//

import UIKit
let KProductDetailEditCell = "ProductDetailCell"
let KProductQtyEditCell = "QtyTableViewCell"
let KProductUpdateFooter = "EditCartFooter"
class EditCartViewController: ViewController{
    @IBOutlet weak var tableView:UITableView!
    var productId: String!
    var qty:Int = 1
    var maxQty:Int!
    var index:Int!
    let productDetailVM:ProductDetailVMDelegate = ProductDetailVM()
    var productDetail: ProductObj?
    var selectedVarint:VariantViewModel?
    var delegate:UpdateCartDelegate!
    var disableCellFlag:Bool = false
    var emptyQTY:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: KVarientSelectedCell, bundle: nil), forCellReuseIdentifier: KVarientSelectedCell)
        tableView.register(UINib.init(nibName: KProductQtyEditCell, bundle: nil), forCellReuseIdentifier: KProductQtyEditCell)
        tableView.registerNibName(KProductDetailEditCell, forCellHeaderFooter: KProductDetailEditCell)
        tableView.registerNibName(KProductUpdateFooter, forCellHeaderFooter: KProductUpdateFooter)

        //fetchProductDetail(obj: productId)
        
    }
    
    func fetchProductDetail(obj:String){
        if NetStatus.shared.isConnected{
        productDetailVM.fetchProducts(id: obj){
            details in
            if details != nil{
                DispatchQueue.main.async { [self] in
                    self.productDetail = details
                    for option in self.productDetail!.option{
                        for item in option.values{
                            option.SelectedValue = item
                            break
                        }
                    }
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    //self.varintId = productDetail?.variants.items[0].id
                    //setSelected()
                self.selectedVarint = self.productDetail?.variants.items[0]
                    self.tableView.reloadData()
                }
            }
            }
        }
    }
    
    func setSelected(){
        if let varint = getVarintData(){
            disableCellFlag = false
            self.selectedVarint = varint
            if selectedVarint!.quantityAvailable < 1{
                self.emptyQTY = true
            }
            else {
                self.emptyQTY = false
            }
        }
        else {
            disableCellFlag = true
            self.view.makeToast("Please select another product varient!...this is not available yet")
//            self.btnAddCart.isEnabled = false
//            self.btnAddCart.alpha = 0.5
//            self.btnWishlist.isEnabled = false
//            self.btnWishlist.alpha = 0.5
        }
        qty = 1
        self.tableView.reloadData()
    }
    
    func getVarintData() -> VariantViewModel? {
        var selVar:VariantViewModel? = nil
        var arrVarint = self.productDetail?.variants.items
        if let optionData = self.productDetail?.option {
 
            for i in 0..<optionData.count {
                let opt = optionData[i]
                let selectedValue = opt.SelectedValue
                switch i {
                case i:
                    arrVarint = arrVarint?.filter { (varint) -> Bool in
                        let arrV = varint.selectedOption.filter { $0.name == opt.name && $0.value == selectedValue }
                        return arrV.count > 0
                    }
                default:
                    if let selectvalue = opt.SelectedValue {
                        arrVarint = arrVarint?.filter { (varint) -> Bool in
                            let arrV = varint.selectedOption.filter { $0.name == opt.name && $0.value == selectvalue }
                            return arrV.count > 0
                        }
                    }
                }
            }
            selVar = arrVarint?.first
        }
        
        return selVar
    }
    
 
}

extension EditCartViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if section == 0{
            if let cellReturn = productDetail?.option.count,productDetail?.option[0].name != "Title"{
                return cellReturn
            }
            else {
                return 0
            }
        }
       else  if section == 1{
       return 1
       }
         return 0
     }
     
     func numberOfSections(in tableView: UITableView) -> Int {
         return 2
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 80
        }
       else if indexPath.section == 1{
           if indexPath.row == 0 {
               return UITableView.automaticDimension
           }
        }
        
           return 0
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if productDetail != nil{
            if indexPath.section == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: KVarientSelectedCell) as! VarientSelectedCell
                cell.lblTitle.text = productDetail?.option[indexPath.row].name
                cell.options = productDetail!.option[indexPath.row]
                cell.delegate = self
                cell.setData(currentIndex:indexPath.row,flag: disableCellFlag)
                    return cell
            }
            if indexPath.section == 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier: KProductQtyEditCell) as! QtyTableViewCell
                cell.qty = qty
                cell.lblQty?.text = "\(qty)"
                cell.delegate = self
                cell.maxQty = selectedVarint?.quantityAvailable
                    return cell
            }
            
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if productDetail != nil{
            switch section {
            case 0:
                let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: KProductDetailEditCell) as! ProductDetailCell
                header.delegate = self
                header.setData(obj: selectedVarint!, qty: self.qty, product: productDetail )
                return header
                
            default:
                print("nothing")
            }
        }
           return UIView()
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
          
            if section == 0{
                return UITableView.automaticDimension
            }
            else{
                return 0
            }
           
        }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if productDetail != nil{
            switch section {
            case 1:
                let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: KProductUpdateFooter) as! EditCartFooter
                footer.delegate = self
                if selectedVarint?.quantityAvailable == 0 || disableCellFlag == true || emptyQTY == true{
                    footer.btnUpdate?.isEnabled = false
                    footer.btnUpdate?.alpha = 0.7
                }
                else{
                    footer.btnUpdate?.isEnabled = true
                    footer.btnUpdate?.alpha = 1
                }
                return footer
                
            default:
                print("nothing")
            }
        }
           return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1{
            return UITableView.automaticDimension
        }
        else{
            return 0
        }
    }
}

extension EditCartViewController:upDateSelectedDelegate {
    func selectedVarint(selctedIndex: Int, selName: String!) {
        self.productDetail?.option[selctedIndex].SelectedValue = selName
         _ = setSelected()
    }
    
}

extension EditCartViewController:EditQtyCartProtocol,UpdateCartBtnFooter{
    func updateBtn(flag:Bool) {
        if flag{
            if  let varintId = getVarintData()?.id, varintId != ""{
                //CartController.shared.removeAllQuantitiesFor(CartController.shared.items[self.index])
                let item = CartItem(product: self.productDetail!, variantId: varintId,quantity: self.qty)
                CartController.shared.updateItem(quantity: self.qty, at: index, cartItem: item)
                //CartController.shared.add(item,qty: qty)
                delegate.UpdateCart(flag: true, favFlag: false, index: index)
                self.dismiss(animated: true)
            }}
        else{
            self.dismiss(animated: true)
        }
    }
    
    func updateQTY(qty: Int) {
        self.qty = qty
    }
    
    
}
