//
//  CartVC.swift
//  GasnOw
//
//  Created by Dev iOS on 8/2/20.
//  Copyright © 2020 Team Teklead. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class CartVC: UIViewController {
    @IBOutlet weak var headerView: NavigationBar!
    @IBOutlet weak var cart_tableView: UITableView!{
        didSet{
            cart_tableView.delegate = self
            cart_tableView.dataSource = self
            cart_tableView.isHidden = true
        }
    }
     var settingPopup = SettingPopup()
     var user = Auth.auth().currentUser
     var productList: [ProductInformation] = []
     var db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.navigationBarDelegate = self
        cart_tableView.tableFooterView = UIView()
        cart_tableView.reloadData()
    }
    func getCartList(){
        SharedManager.sharedInstance.showProgressHUD(on: self.view)
        if let user = user {
            let userId = user.uid
                db.collection("user-data").document(userId).collection("cart").getDocuments() { (querySnapshot, err) in
                    SharedManager.sharedInstance.hideProgressHUD()
                    self.cart_tableView.isHidden = false
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let obj = ProductInformation()
                            obj.product_quantity = document.data()["no_of_items"] as! Int
                            obj.price = (document.data()["prprice"] as? NSString)?.integerValue ?? 0
                            obj.name = document.data()["prname"] as! String
                            obj.image = document.data()["primage"] as! String
                            obj.documentId =  ((document.documentID as NSString) as String)
                            self.productList.append(obj)
                            print("\(document.documentID) => \(document.data())")
                        }
                    }
                    self.cart_tableView.reloadData()
                }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
         getCartList()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        productList.removeAll()
        self.tabBarController?.tabBar.isHidden = false
    }
}
extension CartVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = cart_tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! CartCell
        cell.lbl_product_name.text = productList[indexPath.row].name
        cell.lbl_product_quantity.text = "\(productList[indexPath.row].product_quantity)"
        cell.img_product?.sd_setImage(with: URL(string:productList[indexPath.row].image) , completed: nil)
        cell.lbl_product_price.text = "\(productList[indexPath.row].price)"
         cell.btn_delete_item.addTarget(self, action: #selector(self.deleteItem), for: .touchUpInside)
        cell.btn_delete_item.tag = indexPath.row
        cell.btn_add_to_cart.isHidden = true
        return cell
    }
    
    @objc func deleteItem(_sender:UIButton) {
        
        UIAlertController.popupAlert(title:"Alert!", message:"Are you sure you want remove this item from cart?", actionTitles: [UIAlertController.deleteAction,UIAlertController.cancelActionLocalized], actions: [{action1 in
            SharedManager.sharedInstance.showProgressHUD(on: self.view)
            let documentId = (self.productList[_sender.tag].documentId)
            let userId = self.user?.uid ?? ""
            self.db.collection("user-data").document(userId).collection("cart").document(documentId).delete(){ err in
                SharedManager.sharedInstance.hideProgressHUD()
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    self.productList.remove(at: _sender.tag)
                    self.cart_tableView.reloadData()
                    print("Document successfully removed!")
                }
            }
            },{action2 in
               
                
            }, nil])
 
    }
    @IBAction func check_out_now(_ sender: UIButton) {
        
        for object in productList {
            
        }
        /*
         orderDetailsVc.orderItems = productItemInfo
          orderDetailsVc.total_no_of_items = lblProductQuantity.text ?? "0"
         */
        let storyBoard : UIStoryboard = UIStoryboard(name: "OrderDetails", bundle:nil)
        let orderDetailsVc = storyBoard.instantiateViewController(withIdentifier: OrderDetails.stringRepresentation) as! OrderDetails
         orderDetailsVc.orderItems = productList
        self.navigationController?.pushViewController(orderDetailsVc, animated: true)
    }
    
}
extension CartVC : NavigationBarAction{
    func backToview() {
        self.navigationController?.popViewController(animated: true)
    }
    func openProfileScreen() {
           let storyBoard : UIStoryboard = UIStoryboard(name: "Profile", bundle:nil)
           let nextViewController = storyBoard.instantiateViewController(withIdentifier: ProfileVC.stringRepresentation) as! ProfileVC
           self.navigationController?.pushViewController(nextViewController, animated: true)
       }
       
       func openSettingScreen() {
           self.settingPopup = UINib(nibName: SettingPopup.stringRepresentation, bundle: .main).instantiate(withOwner: nil, options: nil).first as! SettingPopup
           self.settingPopup.settingPopupDelegate = self
           self.settingPopup.frame = CGRect(x:0,y:0, width:self.view.frame.size.width,height:self.view.frame.size.height)
           self.view.addSubview(self.settingPopup)
       }
       
       func openNotificationScreen() {
           let storyBoard : UIStoryboard = UIStoryboard(name: "NotificationList", bundle:nil)
           let notificationVC = storyBoard.instantiateViewController(withIdentifier: NotificationListVC.stringRepresentation) as! NotificationListVC
           self.navigationController?.pushViewController(notificationVC, animated: true)
       }
       func openCartScreen() {
           let storyBoard : UIStoryboard = UIStoryboard(name: "Cart", bundle:nil)
           let cartVC = storyBoard.instantiateViewController(withIdentifier: CartVC.stringRepresentation) as! CartVC
           self.navigationController?.pushViewController(cartVC, animated: true)
       }
}
extension CartVC: SettingPopupDelegate{
    func signOutAction() {
           let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        self.settingPopup.removeFromSuperview()
        self.tabBarController?.tabBar.isHidden = true
        let storyBoard : UIStoryboard = UIStoryboard(name: "SplashViewController", bundle:nil)
        let splashVC = storyBoard.instantiateViewController(withIdentifier: SplashPagingViewController.stringRepresentation) as! SplashPagingViewController
        self.navigationController?.pushViewController(splashVC, animated: true)
        
    }
    func settingAction(){
        self.settingPopup.removeFromSuperview()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Setting", bundle:nil)
        let notificationVC = storyBoard.instantiateViewController(withIdentifier: SettingsVC.stringRepresentation) as! SettingsVC
        self.navigationController?.pushViewController(notificationVC, animated: true)
    }
}
