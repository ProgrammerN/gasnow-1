//
//  LoginViewController.swift
//  GasnOw
//
//  Created by Dev iOS on 7/27/20.
//  Copyright © 2020 Team Teklead. All rights reserved.
//

import UIKit
import FirebaseCoreDiagnostics
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController {
    @IBOutlet weak var txt_emailId: CustomTextFieldLayout!
    @IBOutlet weak var txt_psw: CustomTextFieldLayout!
    var handle: AuthStateDidChangeListenerHandle?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    @IBAction func registerBtnTapped(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Register", bundle:nil)
        let registerVC = storyBoard.instantiateViewController(withIdentifier: RegisterVC.stringRepresentation) as! RegisterVC
        self.navigationController?.pushViewController(registerVC, animated:true)
    }
    
    @IBAction func forgotBtnTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "ForgotPassword", bundle:nil)
        let forgotPsw = storyBoard.instantiateViewController(withIdentifier: ForgotPasswordVC.stringRepresentation) as! ForgotPasswordVC
        self.navigationController?.pushViewController(forgotPsw, animated:true)
        }
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        if txt_emailId.text?.isValidEmail() == true {
            SharedManager.sharedInstance.showProgressHUD(on: self.view)
            Auth.auth().signIn(withEmail: txt_emailId.text!, password: txt_psw.text!) { [weak self] authResult, error in
                SharedManager.sharedInstance.hideProgressHUD()
                guard self != nil else { return }
                guard let _ = authResult?.user, error == nil else {
                    UIAlertController.showErrorDailog(message: error!.localizedDescription, in: self, handler:
                        {(alert: UIAlertAction!) in
                            return
                    })
                    print(error!.localizedDescription)
                    return
                }
                self?.navigationController?.navigationBar.isHidden = false

              //  self?.navigationController?.navigationBar.isHidden = false
                let storyBoard : UIStoryboard = UIStoryboard(name: "Location", bundle:nil)
                let locationVC = storyBoard.instantiateViewController(withIdentifier: LocationVC.stringRepresentation) as! LocationVC
                self?.navigationController?.pushViewController(locationVC, animated:true)

            }
        }else{

        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
       // self.navigationController?.navigationBar.isHidden = true
        Auth.auth().removeStateDidChangeListener(handle!)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
          // ...
        }
    }
    
}
