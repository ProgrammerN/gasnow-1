//
//  OrdersViewController.swift
//  GasnOw
//
//  Created by Dev iOS on 7/28/20.
//  Copyright © 2020 Team Teklead. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseAuth
class OrdersViewController: UIViewController {
    var settingPopup = SettingPopup()
     @IBOutlet weak var headerView: NavigationBar!
    @IBOutlet weak var OrderTable: UITableView!{
          didSet{
              //DZNEmptyDataSet
              OrderTable.delegate = self
              OrderTable.dataSource = self
          }
      }
    var user = Auth.auth().currentUser
    var orderList: [OrderItems] = []
    var db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        headerView.leftView.isHidden = true
        headerView.navigationBarDelegate = self
        OrderTable.tableFooterView = UIView()
        headerView.user_button.setImage(UIImage(systemName: "person.fill"), for: .normal)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        getOrderList()
    }
    
    func getOrderList(){
        SharedManager.sharedInstance.showProgressHUD(on: self.view)
        if let user = user {
            let userId = user.uid
                db.collection("orders").document(userId).collection("orderlist").getDocuments() { (querySnapshot, err) in
                    SharedManager.sharedInstance.hideProgressHUD()
                   // self.cart_tableView.isHidden = false
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let item = OrderItems()
                            item.total_amount = document.data()["total_amount"] as?  String ?? ""
                            item.delivery_date = document.data()["delivery_date"] as?  String ?? ""
                            item.product_orderid = document.data()["product_orderid"] as! String
                            item.payment_mode = document.data()["payment_mode"] as! String
                            item.product_quantity = document.data()["no_of_items"] as?  Int ?? 0
//                            obj.price = (document.data()["prprice"] as? NSString)?.integerValue ?? 0
//                            obj.name = document.data()["prname"] as! String
//                            obj.image = document.data()["primage"] as! String
//                            obj.documentId =  ((document.documentID as NSString) as String)
                             self.orderList.append(item)
                            print("\(document.documentID) => \(document.data())")
                        }
                    }
                   self.OrderTable.reloadData()
                }
        }
    }
    func addMenuiconAndUserIcon(){
        let labelLeft = UILabel()
        labelLeft.tag =  1
        
        let labelRight = UILabel()
        labelRight.tag =  2
        let negativeSpacerLeft = UIBarButtonItem.init(barButtonSystemItem:.fixedSpace, target: nil, action: nil)
        negativeSpacerLeft.width = 30
        
        let negativeSpacerRight = UIBarButtonItem.init(barButtonSystemItem:.fixedSpace, target: nil, action: nil)
        negativeSpacerRight.width = 40
        self.navigationItem.leftBarButtonItems = [negativeSpacerLeft,UIBarButtonItem(customView: labelLeft),negativeSpacerRight,UIBarButtonItem(customView: labelRight)]
    }
}
extension OrdersViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList.count
}
    //MARK:- Tableview DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = OrderTable.dequeueReusableCell(withIdentifier: OrdersItemCell.stringRepresentation, for:indexPath) as! OrdersItemCell
       // setPsychicsDetails(cell: cell , index: indexPath.row)
        cell.selectionStyle = .none
        cell.lbl_orderNo.text = orderList[indexPath.row].product_orderid
        cell.lbl_payment_mode.text = orderList[indexPath.row].payment_mode.firstLetterUppercased
        cell.lbl_total_amount.text = "R \(orderList[indexPath.row].total_amount)"
        cell.lbl_orderQuantity.text = "\(orderList[indexPath.row].product_quantity)"
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-mm-yyyy-hh:mm:ss"
        let date = dateFormatter.date(from: orderList[indexPath.row].delivery_date)
        dateFormatter.dateFormat = "dd/mm/yyy"
        cell.lbl_delivery_date.text = dateFormatter.string(from: date ?? Date())
        return cell
    }
}
extension OrdersViewController : NavigationBarAction{
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
    func backToview() {
        
    }
    func openCartScreen() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Cart", bundle:nil)
        let cartVC = storyBoard.instantiateViewController(withIdentifier: CartVC.stringRepresentation) as! CartVC
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
}

extension OrdersViewController : SettingPopupDelegate{
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
