//
//  SplashViewController.swift
//  GasnOw
//
//  Created by Dev iOS on 7/29/20.
//  Copyright © 2020 Team Teklead. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    weak var pagingViewController: SplashPagingViewController?
      weak var coordinatorDelegate: SplashPagingViewControllerDelegate?
       @IBOutlet weak var titleLabel: UILabel!
       @IBOutlet weak var img: UIImageView!
       @IBOutlet weak var lbl_description: UILabel!
    
        override func viewDidLoad() {
        super.viewDidLoad()
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
