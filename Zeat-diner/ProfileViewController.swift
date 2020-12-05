//
//  ProfileViewController.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 1/29/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DinerService.logout()
        let mainViewController = UIStoryboard(name: "AWSRegistration", bundle: nil).instantiateInitialViewController()
        self.present(mainViewController!, animated: true, completion: nil)

        let pool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolsSigninProviderKey)
        if let user = pool!.currentUser() {
            user.signOut()
        }

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
