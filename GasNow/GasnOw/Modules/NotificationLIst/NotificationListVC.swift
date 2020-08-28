//
//  NotificationListVC.swift
//  GasnOw
//
//  Created by Dev iOS on 8/14/20.
//  Copyright © 2020 Team Teklead. All rights reserved.
//

import UIKit
import FirebaseAuth

class NotificationListVC: UIViewController {
    @IBOutlet weak var headerView: NavigationBar!
    var settingPopup = SettingPopup()
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.navigationBarDelegate = self
        headerView.title = "Notifications"
        headerView.leftView.isHidden = false
        headerView.rightView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          self.tabBarController?.tabBar.isHidden = true
    }
}
extension NotificationListVC: SettingPopupDelegate {
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
           let splashVC = storyBoard.instantiateViewController(withIdentifier: SplashViewController.stringRepresentation) as! SplashViewController
           self.navigationController?.pushViewController(splashVC, animated: true)
           
       }
       func settingAction(){
           let storyBoard : UIStoryboard = UIStoryboard(name: "Notification", bundle:nil)
           let notificationVC = storyBoard.instantiateViewController(withIdentifier: NotificationVC.stringRepresentation) as! NotificationVC
           self.navigationController?.pushViewController(notificationVC, animated: true)
           
       }
}
extension NotificationListVC: NavigationBarAction {
    func backToview() {
        self.navigationController?.popViewController(animated: true)
    }
}
