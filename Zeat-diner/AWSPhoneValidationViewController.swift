//
//  PhoneValidationController.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 5/19/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

class AWSPhoneValidationViewController: UITableViewController {
    
    
    @IBOutlet weak var phoneToValidate: UILabel!
    @IBOutlet weak var validateButton: UIButton!
    @IBOutlet weak var verificationCode: UITextField!

    var validationCodeSentTo: String?
    var user: AWSCognitoIdentityUser?
    var validationSuccess: Bool = false
    var tempPassword: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        phoneToValidate.text = validationCodeSentTo

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return validationSuccess
    }
    
    func signIn() -> Void {
        self.user?.getSession((user?.username)!, password: tempPassword!, validationData: nil).continueWith {[weak self] (task: AWSTask) -> AnyObject? in
            guard let strongSelf = self else { return nil }
            DispatchQueue.main.async(execute: {
                if let error = task.error as NSError? {
                    let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                            message: error.userInfo["message"] as? String,
                                                            preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    
                    self?.present(alertController, animated: true, completion:  nil)
                } else if let result = task.result {

                    let tokens = NSDictionary(dictionary: [ZeatCognitoIdp : result.idToken!.tokenString])
                    let cognitoProviderManager = ZeatAWSIdentityProviderManager(tokens: tokens)
                    
                    let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USWest2, identityPoolId: ZeatCognitoIdentityPoolId, identityProviderManager: cognitoProviderManager)
                    
                    let configuration = AWSServiceConfiguration(region: .USWest2, credentialsProvider: credentialProvider)
                    AWSServiceManager.default().defaultServiceConfiguration = configuration
                    
                    let identityIdTask = credentialProvider.getIdentityId()
                    
                    identityIdTask.continueWith {(task: AWSTask) -> AnyObject? in
                        if let error = task.error as NSError? {
                            print(error.userInfo["message"]!)
                            
                        } else if let result = task.result {
                            print(result)
                        }
                        
                        return nil
                    }

                    
                    if let accessToken = result.accessToken?.tokenString {
                        print("*******ACCESS TOKEN*********")
                        print(accessToken)
                        ZeatUserDefaults.setAccessToken(accessToken: accessToken)
                    }
                    
                    if let idToken = result.idToken?.tokenString {
                        print("*******ID TOKEN*********")
                        print(idToken)
                        ZeatUserDefaults.setIdToken(idToken: idToken)
                    }

                    if let refreshToken = result.refreshToken?.tokenString {
                        print("*******REFRESH TOKEN*********")
                        print(refreshToken)
                        ZeatUserDefaults.setRefreshToken(refreshToken: refreshToken)
                    }
                    
                    if let expirationTime = result.expirationTime {
                        print("*******EXPIRY TIME*********")
                        print(ZeatUtility.localTime(datetime: expirationTime))
                        ZeatUserDefaults.setExpirationTime(expirationTime: expirationTime)
                        
                    }
                    
                    strongSelf.validationSuccess = true
                    strongSelf.performSegue(withIdentifier: "showRestaurants", sender:nil)
                    
                }
            })
            return nil
        }
    }

    @IBAction func validatePhone(_ sender: Any) {

        guard let confirmationCodeValue = self.verificationCode.text, !confirmationCodeValue.isEmpty else {
            let alertController = UIAlertController(title: "Confirmation code missing.",
                                                    message: "Please enter a valid confirmation code.",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion:  nil)
            return
        }
        self.user?.confirmSignUp(self.verificationCode.text!, forceAliasCreation: true).continueWith {[weak self] (task: AWSTask) -> AnyObject? in
            guard let strongSelf = self else { return nil }
            DispatchQueue.main.async(execute: {
                if let error = task.error as NSError? {
                    let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                            message: error.userInfo["message"] as? String,
                                                            preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    
                    strongSelf.present(alertController, animated: true, completion:  nil)
                } else {

                    strongSelf.signIn()

//                    let _ = strongSelf.navigationController?.popToRootViewController(animated: true)
                }
            })
            return nil
        }
    }

    
    @IBAction func resendCode(_ sender: Any) {
        self.user?.resendConfirmationCode().continueWith {[weak self] (task: AWSTask) -> AnyObject? in
            guard let strongSelf = self else { return nil }
            DispatchQueue.main.async(execute: {
                if let error = task.error as NSError? {
                    let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                            message: error.userInfo["message"] as? String,
                                                            preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    
                    strongSelf.present(alertController, animated: true, completion:  nil)
                } else if let result = task.result {
                    let phoneCodeSentTo = result.codeDeliveryDetails?.destination
                    let phoneOnRecord = "phone on record"
                    let alertController = UIAlertController(title: "Code Resent",
                                                            message: "Code resent to \(phoneCodeSentTo ?? phoneOnRecord)",
                        preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    strongSelf.present(alertController, animated: true, completion: nil)
                }
            })
            return nil
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
