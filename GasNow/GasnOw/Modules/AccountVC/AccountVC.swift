//
//  AccountVC.swift
//  GasnOw
//
//  Created by Dev iOS on 7/29/20.
//  Copyright © 2020 Team Teklead. All rights reserved.
//

import UIKit

class AccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
       // self.navigationController?.hideNavigationLine()
        
    }
    

    @IBAction func btn_create_account_tapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Register", bundle:nil)
        let registerVC = storyBoard.instantiateViewController(withIdentifier: RegisterVC.stringRepresentation) as! RegisterVC
        self.navigationController?.pushViewController(registerVC, animated:true)
    }
    @IBAction func btn_have_an_account_tapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Login", bundle:nil)
               let loginVC = storyBoard.instantiateViewController(withIdentifier: LoginViewController.stringRepresentation) as! LoginViewController
               self.navigationController?.pushViewController(loginVC, animated:true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.removeBottomNavigationbarSeparator()
        navigationController?.hideNavigationLine()
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
