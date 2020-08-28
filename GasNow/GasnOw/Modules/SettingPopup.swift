//
//  SettingPopup.swift
//  GasnOw
//
//  Created by Dev iOS on 8/9/20.
//  Copyright © 2020 Team Teklead. All rights reserved.
//

import UIKit
protocol SettingPopupDelegate : class {
    func settingAction()
    func signOutAction()
//func successfullyApplyPromoCodeView(promocode:String)
//func removePromoCodeView()
}

class SettingPopup: UIView {
    weak var settingPopupDelegate : SettingPopupDelegate!
    @IBOutlet weak var shadowView: UIView!
    @IBAction func btn_setting_tapped(_ sender: UIButton) {
        settingPopupDelegate.settingAction()
        
    }
    override func awakeFromNib() {
           //initWithNib()
        shadowInView(shadowView: shadowView)
       }
    
    func shadowInView(shadowView:UIView)  {
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        shadowView.layer.shadowRadius = 10
        shadowView.layer.shadowOpacity = 1.5
        shadowView.layer.masksToBounds = false
    }
    @IBAction func btnSignOutTapped(_ sender: UIButton) {
        settingPopupDelegate.signOutAction()
    }
    
}
