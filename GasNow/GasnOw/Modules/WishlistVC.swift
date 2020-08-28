//
//  WishlistVC.swift
//  GasnOw
//
//  Created by Dev iOS on 8/14/20.
//  Copyright © 2020 Team Teklead. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
class WishlistVC: UIViewController {
    @IBOutlet weak var headerView: NavigationBar!
     var user = Auth.auth().currentUser
     var productList: [ProductInformation] = []
    var db = Firestore.firestore()
    @IBOutlet weak var tbl_wishlist: UITableView!{
        didSet{
            tbl_wishlist.delegate = self
            tbl_wishlist.dataSource = self
            tbl_wishlist.isHidden = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       headerView.navigationBarDelegate = self
        headerView.leftView.isHidden = false
        headerView.rightView.isHidden = true
        headerView.title = "Wishlist"
        // Do any additional setup after loading the view.
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        getWishList()
        
    }
    func getWishList(){
           SharedManager.sharedInstance.showProgressHUD(on: self.view)
           if let user = user {
               let userId = user.uid
                   db.collection("user-data").document(userId).collection("wishlist").getDocuments() { (querySnapshot, err) in
                       SharedManager.sharedInstance.hideProgressHUD()
                       self.tbl_wishlist.isHidden = false
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
                       self.tbl_wishlist.reloadData()
                   }
           }
       }
}
extension WishlistVC:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return productList.count
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl_wishlist.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! CartCell
        cell.lbl_product_name.text = productList[indexPath.row].name
        cell.lbl_product_quantity.text = "\(productList[indexPath.row].product_quantity)"
        cell.img_product?.sd_setImage(with: URL(string:productList[indexPath.row].image) , completed: nil)
        cell.lbl_product_price.text = "\(productList[indexPath.row].price)"
        //cell.btn_delete_item.addTarget(self, action: #selector(self.deleteItem), for: .touchUpInside)
        cell.btn_delete_item.tag = indexPath.row
        cell.btn_add_to_cart.isHidden = false
       // cell.btn_delete_item.addTarget(self, action: #selector(self.remove_item_from_wishlist:Bool), for: .touchUpInside)
        cell.btn_delete_item.tag = indexPath.row
        cell.btn_add_to_cart.addTarget(self, action: #selector(self.itemAddtoCart), for: .touchUpInside)
        cell.btn_add_to_cart.tag = indexPath.row
        cell.btn_add_to_cart.isHidden = false
        return cell
    }
    @objc func itemAddtoCart(_sender:UIButton) {
        let item_inforemation = productList[_sender.tag]
        SharedManager.sharedInstance.showProgressHUD(on: self.view)
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        let userId = user?.uid ?? ""
        let userMailId = user?.email ?? ""
        let docData: [String: Any] = [  "no_of_items": item_inforemation.product_quantity,
                                        "prdesc":"Gas Description",
                                        "prid" :"3",
                                        "primage":item_inforemation.image,
                                        "prname": item_inforemation.name,
                                        "prprice":"\(item_inforemation.price)",
                                        "useremail": userMailId,
                                        "message_body": "Test Items"]
        db.collection("user-data").document(userId).collection("cart").document().setData(docData) { err in
            SharedManager.sharedInstance.hideProgressHUD()
            if let err = err {
                 print("Error adding document: \(err)")
            } else {
                self.remove_item_from_wishlist(_sender: _sender)
                UIAlertController.showErrorDailog(message: "Your item added successfully to your cart", in: self, handler:
                    {(alert: UIAlertAction!) in
                        // return
                })
                print("Document added with ID:")
            }
            
        }
        
        
    }
    @objc func remove_item_from_wishlist(_sender:UIButton) {
        let indexPath = NSIndexPath(row: _sender.tag, section: 0)
        
        let cell = tbl_wishlist.cellForRow(at: indexPath as IndexPath) as! CartCell
        if cell.btn_add_to_cart == _sender {
            removeItemAPI(index: _sender.tag)
        }else {
            UIAlertController.popupAlert(title:"Alert!", message:"Are you sure you want remove this item from wishlist?", actionTitles: [UIAlertController.deleteAction,UIAlertController.cancelActionLocalized], actions: [{action1 in
                self.removeItemAPI(index: _sender.tag)
            },{action2 in
                
            }, nil])
        }
    }
    func removeItemAPI(index : Int)  {
        SharedManager.sharedInstance.showProgressHUD(on: self.view)
        let documentId = (self.productList[index].documentId)
        let userId = self.user?.uid ?? ""
        self.db.collection("user-data").document(userId).collection("wishlist").document(documentId).delete(){ err in
            SharedManager.sharedInstance.hideProgressHUD()
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                self.productList.remove(at: index)
                self.tbl_wishlist.reloadData()
                print("Document successfully removed!")
            }
        }
        
    }
}
extension WishlistVC: NavigationBarAction{
     func backToview() {
           self.navigationController?.popViewController(animated: true)
       }
}
