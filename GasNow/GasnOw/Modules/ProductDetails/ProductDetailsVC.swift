//
//  ProductDetailsVC.swift
//  GasnOw
//
//  Created by Dev iOS on 8/2/20.
//  Copyright © 2020 Team Teklead. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ProductDetailsVC: UIViewController {
    
   @IBOutlet weak var headerView: NavigationBar!
    var settingPopup = SettingPopup()
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var lblProductQuantity: UILabel!
    @IBOutlet weak var product_description: UILabel!



    @IBOutlet weak var productImage: UIImageView!
    var productItemInfo = ProductInformation()
       override func viewDidLoad() {
           super.viewDidLoad()
           headerView.navigationBarDelegate = self
           headerView.title = "Product"
           headerView.leftView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        setUp()
    }
    func setUp(){
        lblProductQuantity.text = "1"
        productName.text = productItemInfo.name
        //productImage.sd
         productImage.sd_setImage(with: URL(string: productItemInfo.image), placeholderImage: UIImage(named: ""))
        productPrice.text = "\(productItemInfo.price)"
        product_description.text = productItemInfo.description
    }
    @IBAction func remove_product(_ sender: Any) {
        var qty = (lblProductQuantity.text! as NSString).integerValue
        if qty > 1 {
            qty -= 1
            lblProductQuantity.text = "\(qty)"
        }
    }
    @IBAction func add_product(_ sender: Any) {
        var qty = (lblProductQuantity.text! as NSString).integerValue
         qty += 1
         lblProductQuantity.text = "\(qty)"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    @IBAction func add_to_cart(_ sender: UIButton) {
        SharedManager.sharedInstance.showProgressHUD(on: self.view)
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        let userId = user?.uid ?? ""
        let userMailId = user?.email ?? ""
        let docData: [String: Any] = [  "no_of_items": (lblProductQuantity.text! as NSString).integerValue,
                                        "prdesc":"Gas Description",
                                        "prid" :"3",
                                        "primage":productItemInfo.image,
                                        "prname": productName.text!,
                                        "prprice":productPrice.text!,
                                        "useremail": userMailId,
                                        "message_body": "Test Items"]
        db.collection("user-data").document(userId).collection("cart").document().setData(docData) { err in
            SharedManager.sharedInstance.hideProgressHUD()
            if let err = err {
                 print("Error adding document: \(err)")
            } else {
                UIAlertController.showErrorDailog(message: "Your item added successfully to your cart", in: self, handler:
                    {(alert: UIAlertAction!) in
                        // return
                })
                print("Document added with ID:")
            }
            
        }
    }
    
    @IBAction func buy_now_action(_ sender: UIButton) {
       // place_order()
        let storyBoard : UIStoryboard = UIStoryboard(name: "OrderDetails", bundle:nil)
        let orderDetailsVc = storyBoard.instantiateViewController(withIdentifier: OrderDetails.stringRepresentation) as! OrderDetails
        productItemInfo.product_quantity = (lblProductQuantity.text! as NSString).integerValue
         var obj : [ProductInformation] = []
        obj.append(productItemInfo)
        orderDetailsVc.orderItems = obj //productItemInfo
       // orderDetailsVc.product_quantity = 1
       // orderDetailsVc.total_no_of_items = lblProductQuantity.text ?? "0"
        self.navigationController?.pushViewController(orderDetailsVc, animated: true)
    }
    
    
    @IBAction func wishlist_button_action(_ sender: UIButton) {
        SharedManager.sharedInstance.showProgressHUD(on: self.view)
               let db = Firestore.firestore()
               let user = Auth.auth().currentUser
               let userId = user?.uid ?? ""
               let userMailId = user?.email ?? ""
               let docData: [String: Any] = [  "no_of_items": (lblProductQuantity.text! as NSString).integerValue,
                                               "prdesc":"Gas Description",
                                               "prid" :"3",
                                               "primage":productItemInfo.image,
                                               "prname": productName.text!,
                                               "prprice":productPrice.text!,
                                               "useremail": userMailId,
                                               "message_body": "Test Items"]
               db.collection("user-data").document(userId).collection("wishlist").document().setData(docData) { err in
                   SharedManager.sharedInstance.hideProgressHUD()
                   if let err = err {
                        print("Error adding document: \(err)")
                   } else {
                       UIAlertController.showErrorDailog(message: "Your item added successfully to wishlist cart", in: self, handler:
                           {(alert: UIAlertAction!) in
                               // return
                       })
                       print("Document added with ID:")
                   }
               }
        
    }
    @IBAction func share_button_action(_ sender: UIButton) {
        let text = productItemInfo.image
           let textShare = [ text ]
           let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
           activityViewController.popoverPresentationController?.sourceView = self.view
           self.present(activityViewController, animated: true, completion: nil)
    }

    @IBAction func similar_button_action(_ sender: UIButton) {
        self.backToview()
    }
}
extension ProductDetailsVC : NavigationBarAction{
    func backToview() {
        self.navigationController?.popViewController(animated: true)
    }
    func openCartScreen() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Cart", bundle:nil)
        let cartVC = storyBoard.instantiateViewController(withIdentifier: CartVC.stringRepresentation) as! CartVC
        self.navigationController?.pushViewController(cartVC, animated: true)
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
            let storyBoard : UIStoryboard = UIStoryboard(name: "Notification", bundle:nil)
            let notificationVC = storyBoard.instantiateViewController(withIdentifier: NotificationVC.stringRepresentation) as! NotificationVC
            self.navigationController?.pushViewController(notificationVC, animated: true)
        }
}

extension ProductDetailsVC: SettingPopupDelegate {
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
        let storyBoard : UIStoryboard = UIStoryboard(name: "Notification", bundle:nil)
        let notificationVC = storyBoard.instantiateViewController(withIdentifier: NotificationVC.stringRepresentation) as! NotificationVC
        self.navigationController?.pushViewController(notificationVC, animated: true)
        
    }
}
extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
