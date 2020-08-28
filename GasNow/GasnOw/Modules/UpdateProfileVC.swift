//
//  UpdateProfileVC.swift
//  GasnOw
//
//  Created by Dev iOS on 8/5/20.
//  Copyright © 2020 Team Teklead. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
import FirebaseStorage
class UpdateProfileVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    var imagePicker: ImagePicker!
    var dataBaseRef: DatabaseReference!{
        return Database.database().reference()
    }
//    var storageRef: StorageReference!{
//        return Storage.storage().reference()
//    }
    @IBOutlet weak var lbl_name_error: UILabel!{
        didSet{
            lbl_name_error.isHidden = true
        }
    }
    @IBOutlet weak var lbl_phone_number_error: UILabel!{
        didSet{
            lbl_phone_number_error.isHidden = true
        }
    }
     @IBOutlet weak var txt_phone_number: UITextField!
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var headerView: NavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.navigationBarDelegate = self
        headerView.title = "Profile"
        headerView.leftView.isHidden = false
        headerView.rightView.isHidden = true
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           self.tabBarController?.tabBar.isHidden = true
        if let user =  Auth.auth().currentUser {
            txt_name.text = user.displayName
            txt_email.text = user.email
            imageView.sd_setImage(with: user.photoURL, placeholderImage: UIImage(named: "user"))
        }
          // setUp()
       }
    
    @IBAction func EditingTextField(_ field: UITextField) {
        if field == txt_name {
            if field.text!.count < 4 {
                self.lbl_name_error.isHidden = false
            }else {
                self.lbl_name_error.isHidden = true
            }
        }else if field == txt_phone_number {
            if field.text!.count < 10 {
                lbl_phone_number_error.text = "Number should be 10 digits"
                self.lbl_phone_number_error.isHidden = false
            }else if field.text!.count == 10 {
                self.lbl_phone_number_error.isHidden = true
            }else if field.text!.count > 10 {
                self.lbl_phone_number_error.isHidden = false
                lbl_phone_number_error.text = "Number can not be greater than 10 digits"
            }
        }
    }
    
    @IBAction func updateProfileAction(_ sender: Any) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = txt_name.text
        changeRequest?.commitChanges { (error) in
            if error == nil{
                print("Name updated successfully")
            }
        }
    }
}
extension UpdateProfileVC : NavigationBarAction {
    func backToview() {
    self.navigationController?.popViewController(animated: true)

    }
    }
extension UpdateProfileVC: ImagePickerDelegate{
    @IBAction func showImagePicker(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    func didSelect(image: UIImage?, imageUrl: URL?) {
        self.imageView.image = image
        updatePhoto()
    }
    func updateProfileImage(imageURL: URL) {
        SharedManager.sharedInstance.showProgressHUD(on: self.view)
        if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
            changeRequest.photoURL = imageURL
            changeRequest.commitChanges(completion: { (error) in
                SharedManager.sharedInstance.hideProgressHUD()
                if let error = error {
                    print("Failed to change the profile image: \(error.localizedDescription)")
                }else {
                    print("Changed user profile image")
                }
            })
            
        }
    }
    func updatePhoto(){
        let user =  Auth.auth().currentUser
        SharedManager.sharedInstance.showProgressHUD(on: self.view)
        let storageRef = Storage.storage().reference(forURL: "gs://gasnow-442eb.appspot.com")
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child("Profile").child("photo_\(String(describing: user!.uid))")
        let metadataType = StorageMetadata()
        metadataType.contentType = "image/jpg"
       
        guard let data = imageView.image?.jpegData(compressionQuality: 0.5) else {
            print("not converted")
            return
        }
       riversRef.putData(data, metadata: metadataType) { (metadata, error) in
          riversRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              return
            }
            SharedManager.sharedInstance.hideProgressHUD()
            self.updateProfileImage(imageURL: downloadURL)
          }
        }
    }
}
