//
//  SettingsVC.swift
//  GasnOw
//
//  Created by Dev iOS on 8/1/20.
//  Copyright © 2020 Team Teklead. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var headerView: NavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.navigationBarDelegate = self
        headerView.title = "Settings"
        headerView.leftView.isHidden = false
        headerView.rightView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
}
extension SettingsVC : NavigationBarAction{
    func backToview() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func openProfileScreen() {
    //    <#code#>
    }
    
    func openSettingScreen() {
       // <#code#>
    }
    
    func openNotificationScreen() {
        
    }
    
    
}
