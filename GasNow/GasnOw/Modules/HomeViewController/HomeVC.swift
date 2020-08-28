//
//  HomeVC.swift
//  GasnOw
//
//  Created by Dev iOS on 7/28/20.
//  Copyright © 2020 Team Teklead. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore
import FirebaseAuth
import SDWebImage


class HomeVC: UIViewController {
    //var navBar = NavigationBar()
    var productList: [ProductInformation] = []
    @IBOutlet weak var productCollectionView: UICollectionView!{
        didSet{
            productCollectionView.delegate = self
            productCollectionView.dataSource = self
        }
    }
    var settingPopup = SettingPopup()
    @IBOutlet weak var headerView: NavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.hideNavigationLine()
        headerView.leftView.isHidden = true
        headerView.navigationBarDelegate = self
        headerView.user_button.setImage(UIImage(systemName: "person.fill"), for: .normal)
        if let layout = productCollectionView?.collectionViewLayout as? PinterestLayout {
          layout.delegate = self
        }
        SharedManager.sharedInstance.showProgressHUD(on: self.view)
        getproductList()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    func getproductList() {
        let db = Firestore.firestore()
        db.collection("products").getDocuments() { (querySnapshot, err) in
            SharedManager.sharedInstance.hideProgressHUD()
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let obj = ProductInformation()
                    obj.name = document.data()["name"] as! String
                    obj.price = document.data()["price"] as! Int
                    obj.description = document.data()["description"] as! String
                    obj.image = document.data()["image"] as! String
                    self.productList.append(obj)
                    print("\(document.documentID) => \(document.data())")
                }
                self.productCollectionView.reloadData()
            }
        }
        
    }
}
extension HomeVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productCell.identifier, for: indexPath) as! productCell
        cell.contentView.layoutIfNeeded()
        cell.lbl_product_name.text = productList[indexPath.row].name
        cell.lbl_product_price.text = "\(productList[indexPath.row].price)"
        //cell.img_produc.
        cell.img_produc.sd_setImage(with: URL(string: productList[indexPath.row].image), placeholderImage: UIImage(named: ""))

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "ProductDetail", bundle:nil)
               let productDetailsVC = storyBoard.instantiateViewController(withIdentifier: ProductDetailsVC.stringRepresentation) as! ProductDetailsVC
        productDetailsVC.productItemInfo = productList[indexPath.row]
               self.navigationController?.pushViewController(productDetailsVC, animated: true)
    }
    func collectionView(
      _ collectionView: UICollectionView,
      heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
      return 305
    }
    
}
extension HomeVC:NavigationBarAction{
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
extension HomeVC: SettingPopupDelegate{
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
