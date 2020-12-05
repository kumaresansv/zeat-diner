////
////  RegistrationViewController.swift
////  Zeat-diner
////
////  Created by Kumaresan Sankaranarayanan on 11/22/16.
////  Copyright © 2016 Zeat. All rights reserved.
////
//
//import UIKit
//import NVActivityIndicatorView
//
//class RegistrationViewController: UIViewController, UITextFieldDelegate {
//
//    //MARK: Properties
//    @IBOutlet weak var passwordText: UITextField!
//    @IBOutlet weak var emailText: UITextField!
//    @IBOutlet weak var nextButton: UIButton!
//
//    //MARK: Variables
//    let registrationSegue = "registrationSuccess"
//    var registrationStatus = false
////    var activityIndicatorView: ZeatActivityIndicatorView?
//    var diner: Diner?
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.navigationController?.isNavigationBarHidden = true
//
//        // Do any additional setup after loading the view.
//        nextButton.isEnabled  = false
//        emailText.delegate = self
//        passwordText.delegate = self
//
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegistrationViewController.dismissKeyboard))
//
//        view.addGestureRecognizer(tap)
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//
//
//    func dismissKeyboard() {
//        //Causes the view (or one of its embedded text fields) to resign the first responder status.
//        UIView.animate(withDuration: 0.5, animations: {
//            self.view.endEditing(true)
//        }
//        )
//    }
//
//    // MARK: - Navigation
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        var segueResult = true
//
//        if identifier == "registrationSuccess" {
//            segueResult = registrationStatus
//        }
//
//        return segueResult
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "registrationSuccess" {
//            let registrationUpdateViewController = (segue.destination as! RegistrationUpdateViewController)
//            registrationUpdateViewController.diner = diner
//        }
//    }
//
//
//    //MARK: Actions
//
//    @IBAction func registerWithZeat(_ sender: Any) {
//
//        let activityData = ActivityData()
//        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
//        NVActivityIndicatorPresenter.sharedInstance.setMessage("Registering With Zeat")
//
//        DinerService.register(email: emailText.text!, password: passwordText.text!) { result in
////            self.activityIndicatorView?.hide()
////            self.activityIndicatorView?.removeFromSuperview()
//            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
//
//            switch result {
//            case .success(let diner):
//                self.diner = diner
//                self.registrationStatus = true
//                self.performSegue(withIdentifier: self.registrationSegue, sender: nil)
//
//                guard ZeatUserDefaults.getFCMToken() != ZeatUserDefaults.FCMTokenDefaultValue,
//                    !(ZeatUserDefaults.getFCMTokenRegistrationStatus()) else {
//                        return
//                }
//
//                let dinerToken = DinerToken.init(token: ZeatUserDefaults.getFCMToken())
//
//                DinerService.registerToken(token: dinerToken) { result in
//                    switch result {
//                    case .success:
//                        ZeatUserDefaults.setFCMTokenRegistrationStatus(FCMTokenRegistrationStatus: true)
//                    default: break
//                    }
//                }
//
//            case .failure(let error):
//                var errorMessage: String?
//                switch error {
//                case ZeatLoginError.systemError:
//                    errorMessage = "Unable to reach Zeatservices. Please try again later."
//                case ZeatLoginError.authError(let errorText):
//                    errorMessage = errorText
//                case ZeatLoginError.dinerSerialization(let loginStatus):
//                    guard loginStatus else {
//                        return
//                    }
//
//                default: break
//                }
//
//                // Present alert to user to show login error
//                let alert = UIAlertController(title: ZeatAlerts.registrationErrorTitle, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//                alert.view?.tintColor = ZeatAlerts.alertColor
//                self.present(alert, animated: true, completion: nil)
//                print(error)
//            }
//
//            return
//        }
//
//        self.view.endEditing(true)
//
//    }
//
//    @IBAction func TextValueChanged(_ sender: UITextField) {
//        guard (emailText.text?.characters.count)! > 0,
//            (passwordText.text?.characters.count)! >= 8 else
//        {
//            nextButton.isEnabled  = false
//            return
//        }
//
//        nextButton.isEnabled  = true
//        return
//
//    }
//
//}

