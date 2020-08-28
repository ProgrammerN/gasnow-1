//
//  ViewController.swift
//  GasnOw
//
//  Created by Dev iOS on 7/27/20.
//  Copyright © 2020 Team Teklead. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RegisterVC: UIViewController {

    @IBOutlet weak var lbl_emailId: UITextField!
    @IBOutlet weak var lbl_password: UITextField!
    @IBOutlet weak var lbl_name: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.removeBottomNavigationbarSeparator()
        navigationController?.hideNavigationLine()
        //lbl_password.text = "Test@123"
        // Do any additional setup after loading the view.
    }
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        if lbl_name.text!.isEmpty {
            showAlertMessage(message: "Please enter full name ")
        }else if lbl_emailId.text!.isEmpty {
            showAlertMessage(message: "Please enter Email id")
        }else if !lbl_emailId.text!.isValidEmail(){
            showAlertMessage(message: "Please enter valid Email id")
        }else if lbl_password.text!.isEmpty {
            showAlertMessage(message: "Please enter password")
        }else if lbl_password.text!.count < 6 {
            showAlertMessage(message: "Password must be 6 characters")
        }else {
            SharedManager.sharedInstance.showProgressHUD(on: self.view)
            singnUpAPI()
        }
    }
    func showAlertMessage(message: String){
        UIAlertController.showErrorDailog(message: message, in: self, handler:
                           {(alert: UIAlertAction!) in
                               return
                       })
    }
    func singnUpAPI(){
        Auth.auth().createUser(withEmail: lbl_emailId.text!, password: lbl_password.text!) { (authResult, error) in
            SharedManager.sharedInstance.hideProgressHUD()
            guard let _ = authResult?.user, error == nil else {
                UIAlertController.showErrorDailog(message: error!.localizedDescription, in: self, handler:
                    {(alert: UIAlertAction!) in
                        return
                })
                print(error!.localizedDescription)
                return
            } 
            
            self.navigationController?.navigationBar.isHidden = false
            let storyBoard : UIStoryboard = UIStoryboard(name: "Location", bundle:nil)
            let locationVC = storyBoard.instantiateViewController(withIdentifier: LocationVC.stringRepresentation) as! LocationVC
            self.navigationController?.pushViewController(locationVC, animated:true)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = .white
        // self.navigationController?.navigationBar.isHidden = true
    }

}

