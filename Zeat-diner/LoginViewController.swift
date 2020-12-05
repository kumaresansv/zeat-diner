////
////  LoginViewController.swift
////  Zeat-diner
////
////  Created by Kumaresan Sankaranarayanan on 11/17/16.
////  Copyright © 2016 Zeat. All rights reserved.
////
//
//import UIKit
//import NVActivityIndicatorView
////import ActivityData
////import ZeatActiv
////import NV
//
//class LoginViewController: UIViewController, NVActivityIndicatorViewable, UITextFieldDelegate {
//
//    //MARK: Properties
//
//    @IBOutlet weak var emailTextField: UITextField!
//    @IBOutlet weak var passwordTextField: UITextField!
//    @IBOutlet weak var loginButton: UIButton!
//
//    //MARK: Variables
//    let loginSegue = "loginSuccess"
//    var loginStatus = false
////    var activityIndicatorView: ZeatActivityIndicatorView?
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        loginButton.isEnabled  = false
//        emailTextField.delegate = self
//        passwordTextField.delegate = self
//
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
//
//        view.addGestureRecognizer(tap)
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
//        if identifier == "loginSuccess" {
//            segueResult = loginStatus
//        }
//
//        return segueResult
//    }
//
//    //MARK: Actions
//    @IBAction func loginToZeat(_ sender: UIButton) {
//
//        let activityData = ActivityData()
//        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
//        NVActivityIndicatorPresenter.sharedInstance.setMessage("Updating Your Profile")
//
//        DinerService.login(email: emailTextField.text!, password: passwordTextField.text!) { result in
//
//            switch result {
//            case .success(_):
//                self.loginStatus = true
//                self.performSegue(withIdentifier: self.loginSegue, sender: nil)
//
//                guard ZeatUserDefaults.getFCMToken() != ZeatUserDefaults.FCMTokenDefaultValue,
//                      !(ZeatUserDefaults.getFCMTokenRegistrationStatus()) else {
//                    return
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
//                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
//
//                // Present alert to user to show login error
//                let alert = UIAlertController(title: ZeatAlerts.loginErrorTitle, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//                alert.view?.tintColor = ZeatAlerts.alertColor
//                self.present(alert, animated: true, completion: nil)
//                print(error)
//            }
//        }
//
//
////        activityIndicatorView = ZeatActivityIndicatorView.init(frame: self.view.bounds)
////        self.view.addSubview(activityIndicatorView!)
//        self.view.endEditing(true)
//
//    }
//
//    @IBAction func TextValueChanged(_ sender: UITextField) {
//        guard (emailTextField.text?.characters.count)! > 0,
//            (passwordTextField.text?.characters.count)! >= 8 else
//        {
//            loginButton.isEnabled  = false
//            return
//        }
//
//        loginButton.isEnabled  = true
//        return
//
//    }
//
//
//
//}

