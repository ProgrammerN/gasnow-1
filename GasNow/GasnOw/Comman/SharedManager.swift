//
//  SharedManager.swift
//  Psychic Connections
//
//  Created by Mac PC 2 on 4/2/18.
//  Copyright © 2018 Office Mac. All rights reserved.
//

import Foundation
import MBProgressHUD

final class SharedManager {
    
    static let sharedInstance = SharedManager()
    var progressHUDView = MBProgressHUD()
    private init() {  }
    //MBProgressHUD Show Hide methods
    func showProgressHUD(on baseView: UIView) {
        if progressHUDView != nil {
            hideProgressHUD()
        }
        progressHUDView = MBProgressHUD.showAdded(to: baseView, animated: true)
    }
    
    func showProgressHUDWithTitle(on baseView: UIView,title: String, subTitle: String) {
        if progressHUDView != nil {
            hideProgressHUD()
        }
         progressHUDView = MBProgressHUD.showAdded(to: baseView, animated: true)
        progressHUDView.label.text = title
        progressHUDView.detailsLabel.text = subTitle
    }
    
    func hideProgressHUD() {
        print("hideProgressHUD")
        progressHUDView.hide(animated: true)
    }

    
}
