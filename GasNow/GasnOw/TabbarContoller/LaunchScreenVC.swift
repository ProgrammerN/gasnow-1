//
//  LaunchScreenVC.swift
//  GasnOw
//
//  Created by Dev iOS on 8/14/20.
//  Copyright © 2020 Team Teklead. All rights reserved.
//

import UIKit
import FirebaseAuth

class LaunchScreenVC: UIViewController {
    @IBOutlet weak var img : UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        img.image = UIImage.gif(name: "loading_icon")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
           // if Auth.auth().currentUser == nil {
                let storyBoard : UIStoryboard = UIStoryboard(name: "SplashViewController", bundle:nil)
                let accountVC = storyBoard.instantiateViewController(withIdentifier: SplashPagingViewController.stringRepresentation) as! SplashPagingViewController
                self.navigationController?.pushViewController(accountVC, animated:true)
           // }else {
                
          //  }
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
