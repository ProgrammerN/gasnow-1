//
//  ForgotPasswordVC.swift
//  GasnOw
//
//  Created by Dev iOS on 8/2/20.
//  Copyright © 2020 Team Teklead. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var txt_emailId: CustomTextFieldLayout!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backto(_ sender: Any) {
self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitButtonPressed(_ sender: Any) {
        if txt_emailId.text!.isEmpty {
            UIAlertController.showErrorDailog(message: "Enter your mail id", in: self, handler:
                {(alert: UIAlertAction!) in
                    return
            })
        }else if !txt_emailId.text!.isValidEmail() {
            UIAlertController.showErrorDailog(message: "Please enter a valid email id", in: self, handler:
                {(alert: UIAlertAction!) in
                    return
            })
            
        }else {
            SharedManager.sharedInstance.showProgressHUD(on: self.view)
            Auth.auth().sendPasswordReset(withEmail: txt_emailId.text!) { error in
                SharedManager.sharedInstance.hideProgressHUD()
                if error == nil {
                    print("linke send to email")
                    UIAlertController.showErrorDailog(message: "Reset password link send to your mail id \n \(self.txt_emailId.text ?? "")", in: self, handler:
                        {(alert: UIAlertAction!) in
                            return
                    })
                }
                // Your code here
            }
            
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
