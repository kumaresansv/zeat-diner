//
//  RegistrationMainViewController.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 5/19/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider


class AWSRegistrationViewController: UITableViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var pool: AWSCognitoIdentityUserPool?
    var codeSentTo: String?
    var registrationSuccess: Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pool = AWSCognitoIdentityUserPool.init(forKey: AWSCognitoUserPoolsSigninProviderKey)
        self.tableView.bounces = false
        
        registerButton.isEnabled = false
        

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AWSRegistrationViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)

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
        return 10
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        UIView.animate(withDuration: 0.5, animations: {
            self.view.endEditing(true)
        }
        )
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "confirmPhoneSegue" {
            return registrationSuccess
        } else {
            return true
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let phoneValidationVC = segue.destination as? AWSPhoneValidationViewController {
            phoneValidationVC.validationCodeSentTo = self.codeSentTo
            phoneValidationVC.tempPassword = self.password.text
            phoneValidationVC.user = self.pool?.getUser((self.userName.text?.lowercased())!)
        }
        
    }
    
    @IBAction func TextValueChanged(_ sender: UITextField) {
        guard (userName.text?.count)! > 0,
            (password.text?.count)! >= 8,
            (phoneNumber.text?.count)! == 10 else
        {
            registerButton.isEnabled  = false
  //          registerButton.backgroundColor = UIColor.gray
            return
        }
        
        registerButton.isEnabled  = true
//        registerButton.backgroundColor = UIColor.black
        return
        
    }
    
    
    @IBAction func registerWithZeat(_ sender: Any) {
        var attributes = [AWSCognitoIdentityUserAttributeType]()
        
        guard let userNameValue = userName.text
             ,let passwordValue = password.text
            ,let phoneNumberValue = phoneNumber.text
            else {
            return
        }
        
        
        let phoneAttribute = AWSCognitoIdentityUserAttributeType()
        phoneAttribute?.name = "phone_number"
        phoneAttribute?.value = "+1" + phoneNumberValue
        
        attributes.append(phoneAttribute!)
        
        self.pool?.signUp(userNameValue.lowercased(), password: passwordValue, userAttributes: attributes, validationData: nil).continueWith {[weak self] (task) -> Any? in
            guard let strongSelf = self else { return nil}
            DispatchQueue.main.async {
                if let error = task.error as NSError? {
                    let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                            message: error.userInfo["message"] as? String,
                                                            preferredStyle: .alert)
                    let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
                    alertController.addAction(retryAction)
                    
                    self?.present(alertController, animated: true, completion:  nil)
                } else if let result = task.result  {
                    // handle the case where user has to confirm his identity via email / SMS
                    ZeatUserDefaults.setPhone(phone: (phoneAttribute?.value)!)
                    
                    if (result.user.confirmedStatus != AWSCognitoIdentityUserStatus.confirmed) {
                        // Store Phone Number in Defaults
                        strongSelf.codeSentTo = result.codeDeliveryDetails?.destination
                        strongSelf.registrationSuccess = true
                        strongSelf.performSegue(withIdentifier: "confirmPhoneSegue", sender:nil)
                    } else {
                        let _ = strongSelf.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
            
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

