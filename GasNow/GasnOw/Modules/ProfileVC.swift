//
//  ProfileVC.swift
//  GasnOw
//
//  Created by Dev iOS on 8/1/20.
//  Copyright © 2020 Team Teklead. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileVC: UIViewController {

    @IBOutlet weak var user_mailId: UILabel!
    @IBOutlet weak var user_phoneNumber: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var headerView: NavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        SharedManager.sharedInstance.showProgressHUD(on: self.view)
        headerView.navigationBarDelegate = self
        headerView.title = "Profile"
        headerView.leftView.isHidden = false
        headerView.user_button.setImage(UIImage(named: "editIcons"), for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        let user = Auth.auth().currentUser
        if let user = user {
            SharedManager.sharedInstance.hideProgressHUD()
            user_mailId.text = user.email
            user_phoneNumber.text = user.phoneNumber ?? ""
            userPhoto.sd_setImage(with: user.photoURL, placeholderImage: UIImage(named: "user"))
        }
    }
    
    @IBAction func withlist_action_button(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Wishlist", bundle:nil)
        let updateProfileVc = storyBoard.instantiateViewController(withIdentifier: WishlistVC.stringRepresentation) as! WishlistVC
        self.navigationController?.pushViewController(updateProfileVc, animated: true)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
extension ProfileVC: NavigationBarAction{
    func openProfileScreen() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "UpdateProfile", bundle:nil)
        let updateProfileVc = storyBoard.instantiateViewController(withIdentifier: UpdateProfileVC.stringRepresentation) as! UpdateProfileVC
        self.navigationController?.pushViewController(updateProfileVc, animated: true)
    }
    
    func openSettingScreen() {
        //<#code#>
    }
    
    func openNotificationScreen() {
       // <#code#>
    }
    func openCartScreen() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Cart", bundle:nil)
        let cartVC = storyBoard.instantiateViewController(withIdentifier: CartVC.stringRepresentation) as! CartVC
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    
    func backToview() {
        print("ProfileVC backToview")
        self.navigationController?.popViewController(animated: true)
    }
}
