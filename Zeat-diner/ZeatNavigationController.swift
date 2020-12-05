//
//  ZeatNavigationController.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 10/29/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import UIKit

class ZeatNavigationController: UINavigationController, UIGestureRecognizerDelegate {

    var cartView: UIView?

    var hideCurrentCartView: (() -> Void)?

    var showCurrentCartView: ((Order) -> Void)?
    
    var hideMenuButton: (() -> Void)?

    var showMenuButton: (() -> Void)?

    var enableMenuButton: (() -> Void)?

    var disableMenuButton: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

//        addCartView();

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var tabBarController: UITabBarController? {
        // https://stackoverflow.com/questions/28608817/uinavigationcontroller-embedded-in-a-container-view-displays-a-table-view-contr
        
        return nil
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
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
