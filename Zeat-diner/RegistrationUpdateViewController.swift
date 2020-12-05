////
////  RegistrationUpdateViewController.swift
////  Zeat-diner
////
////  Created by Kumaresan Sankaranarayanan on 11/23/16.
////  Copyright © 2016 Zeat. All rights reserved.
////
//
//import UIKit
//import NVActivityIndicatorView
//
//class RegistrationUpdateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, NVActivityIndicatorViewable {
//
//    // MARK: Properties
//
//    @IBOutlet weak var nameText: UITextField!
//    @IBOutlet weak var phoneText: UITextField!
//    @IBOutlet weak var doneButton: UIButton!
//    @IBOutlet weak var profileImageView: UIImageView!
//
//    var diner: Diner?
//    var updateStatus = false
//    let updateSegue = "updateSuccess"
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        phoneText.delegate = self
//        nameText.delegate = self
//
//        profileImageView.layer.backgroundColor = UIColor.white.cgColor
//        profileImageView.layer.masksToBounds = true
//        profileImageView.layer.cornerRadius = profileImageView.frame.width/4
//
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RegistrationUpdateViewController.imageTapped))
//        profileImageView.addGestureRecognizer(tapGesture)
//
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegistrationViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//
//
//    func imageTapped(gesture:UIGestureRecognizer) {
//        if (gesture.view as? UIImageView) != nil {
//            let imagePicketActionSheet = UIAlertController(title: ZeatAlerts.avatarPickerTitle, message: ZeatAlerts.avatarPickerMessage, preferredStyle: UIAlertControllerStyle.actionSheet)
//
//            imagePicketActionSheet.addAction(UIAlertAction(title: "Pick From Gallery", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
//                self.photoLibrary()
//            }))
//
//            imagePicketActionSheet.addAction(UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
//                self.camera()
//            }))
//
//            imagePicketActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
//
//            self.present(imagePicketActionSheet, animated: true, completion: nil)
//        }
//    }
//
//    func dismissKeyboard() {
//        //Causes the view (or one of its embedded text fields) to resign the first responder status.
//        UIView.animate(withDuration: 0.5, animations: {
//            self.view.endEditing(true)
//        }
//        )
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
//        profileImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
//        self.dismiss(animated: true, completion: nil)
//    }
//
//
//    func photoLibrary()
//    {
//
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self;
//        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
//
//        self.present(imagePicker, animated: true, completion: nil)
//    }
//
//    func camera()
//    {
//        let imagePicker = UIImagePickerController()
//
//        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
//            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
//            imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: UIImagePickerControllerSourceType.camera)!
//        } else {
//            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
//            imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: UIImagePickerControllerSourceType.photoLibrary)!
//        }
//
//        imagePicker.delegate = self;
//        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
//        self.present(imagePicker, animated: true, completion: nil)
//
//    }
//
//    // MARK: - Actions
//
//    @IBAction func uploadProfileImage(_ sender: Any) {
//        let imagePicketActionSheet = UIAlertController(title: ZeatAlerts.avatarPickerTitle, message: ZeatAlerts.avatarPickerMessage, preferredStyle: UIAlertControllerStyle.actionSheet)
//
//        imagePicketActionSheet.addAction(UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
//            self.photoLibrary()
//        }))
//
//        imagePicketActionSheet.addAction(UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
//            self.camera()
//        }))
//
//        imagePicketActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
//
//        self.present(imagePicketActionSheet, animated: true, completion: nil)
//    }
//
//
//    @IBAction func updateProfile(_ sender: Any) {
//
//        if let diner = diner {
//            diner.nickName = nameText.text!
//            diner.phone = phoneText.text!
////            diner.profileImage = profileImageView.image!
//
//            let activityData = ActivityData()
//            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
//            NVActivityIndicatorPresenter.sharedInstance.setMessage("Updating Your Profile")
//
//            DinerService.updateProfile(diner: diner) { result in
//                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
//
//                switch result {
//                case .success( _):
//                    self.updateStatus = true
//                    self.performSegue(withIdentifier: self.updateSegue, sender: nil)
//
//
//                case .failure(let error):
//                    var errorMessage: String?
//                    switch error {
//                    case ZeatLoginError.systemError:
//                        errorMessage = "Unable to reach Zeatservices. Please try again later."
//                    case ZeatLoginError.authError(let errorText):
//                        errorMessage = errorText
//                    case ZeatLoginError.dinerSerialization(let loginStatus):
//                        guard loginStatus else {
//                            return
//                        }
//
//                    default: break
//                    }
//
//                    // Present alert to user to show login error
//                    let alert = UIAlertController(title: ZeatAlerts.updateErrorTitle, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//                    alert.view?.tintColor = ZeatAlerts.alertColor
//                    self.present(alert, animated: true, completion: nil)
//                    print(error)
//                }
//
//                return
//            }
//            self.view.endEditing(true)
//        }
//
//
//
//    }
//
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    // MARK: - Navigation
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        var segueResult = true
//
//        if identifier == updateSegue {
//            segueResult = updateStatus
//        }
//
//        return segueResult
//    }
//
//}

