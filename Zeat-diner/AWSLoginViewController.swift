//
//  AWSLoginViewController.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 5/22/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider
import AWSCore

class AWSLoginViewController: UITableViewController {
    
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var user: AWSCognitoIdentityUser?
    var pool: AWSCognitoIdentityUserPool?
    var loginSuccess: Bool = false

    var passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolsSigninProviderKey)
        if (self.user == nil) {
            
            if let user = self.pool?.currentUser() {
                self.user = user
                self.userName.text = user.username
            }
        }
        
        
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
        return 9
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "showRestaurants" {
            return loginSuccess
        } else {
            return true
        }
    }
    
    @IBAction func login(_ sender: Any) {
        
        self.user = self.pool?.getUser(self.userName.text!)
        


        self.user?.getSession(self.userName.text!, password: self.password.text!, validationData: nil).continueWith {[weak self] (task: AWSTask) -> AnyObject? in
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
                    
                    // Register User WIth Identity Pool
                    
                    let tokens = NSDictionary(dictionary: [ZeatCognitoIdp : result.idToken!.tokenString])
                    let cognitoProviderManager = ZeatAWSIdentityProviderManager(tokens: tokens)
                    
                    let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USWest2, identityPoolId: ZeatCognitoIdentityPoolId, identityProviderManager: cognitoProviderManager)
                    
                    let configuration = AWSServiceConfiguration(region: .USWest2, credentialsProvider: credentialProvider)
                    AWSServiceManager.default().defaultServiceConfiguration = configuration
                    
                    let identityIdTask = credentialProvider.getIdentityId()
                    
                    identityIdTask.continueWith { (task: AWSTask) -> AnyObject? in
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
                    
                    strongSelf.loginSuccess = true
                    strongSelf.performSegue(withIdentifier: "showRestaurants", sender:nil)
                    
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


extension AWSLoginViewController: AWSCognitoIdentityPasswordAuthentication {
    
    
    func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
        self.passwordAuthenticationCompletionSource = passwordAuthenticationCompletionSource
        
        DispatchQueue.main.async {
            if (self.userName.text?.isEmpty)! {
                self.userName.text = authenticationInput.lastKnownUsername
            }
        }
    }
    
    func didCompleteStepWithError(_ error: Error?) {
        DispatchQueue.main.async(execute: {

            if let error = error as NSError? {
                let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                        message: error.userInfo["message"] as? String,
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion:  nil)
            } else {
                self.userName.text = nil
            }
        })
    }
    
}
