//
//  NotificationVC.swift
//  GasnOw
//
//  Created by Dev iOS on 7/29/20.
//  Copyright © 2020 Team Teklead. All rights reserved.
//

import UIKit
import FirebaseAuth

class NotificationVC: UIViewController {

    @IBOutlet weak var headerView: NavigationBar!
    var settingPopup = SettingPopup()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        headerView.leftView.isHidden = true
        headerView.navigationBarDelegate = self
        headerView.user_button.setImage(UIImage(systemName: "person.fill"), for: .normal)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

}
extension NotificationVC : NavigationBarAction{
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
extension NotificationVC : SettingPopupDelegate{
    func signOutAction() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        self.settingPopup.removeFromSuperview()
        self.tabBarController?.tabBar.isHidden = true
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
