//
//  ZeatTabBarController.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 10/29/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import UIKit

class ZeatTabBarViewController: UIViewController {
    
    @IBOutlet weak var currentOrderView: UIView?
    @IBOutlet weak var currentOrderViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet weak var currentOrderTrailingToSuperViewCenterX: NSLayoutConstraint!

    @IBOutlet weak var currentCartButton: UIButton?
    @IBOutlet weak var menuButton: UIButton?

    weak var zeatNavigationController: ZeatNavigationController?
    
    var currentOrder: Order?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentOrderView?.isHidden = true
        self.currentOrderViewHeightConstraint?.constant = 0

        ZeatUtility.getDinerActiveOrder() { order in
            if(order != nil) {
                self.showCurrentOrderView(forOrder: order!)
            } else {
                self.hideCurrentOrderView()
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showCurrentOrderView(forOrder: Order) {
        UIView.animate(withDuration: 0.25, animations: {
            self.currentOrderView?.isHidden = false
            self.currentOrderViewHeightConstraint?.constant = 40
            self.currentOrder = forOrder
            self.view.layoutIfNeeded()

        }, completion: nil)
    }
    
    func hideCurrentOrderView() {
        UIView.animate(withDuration: 0.25, animations: {
            self.currentOrderView?.isHidden = true
            self.currentOrderViewHeightConstraint?.constant = 0
            self.view.layoutIfNeeded()

        }, completion: nil)

    }
    
//    func hideMenuButton() {
//        UIView.animate(withDuration: 0.25, animations: {
//            self.menuButton?.isHidden = true
//            self.view.layoutIfNeeded()
//        }, completion: nil)
//    }

    func showMenuButton() {
        UIView.animate(withDuration: 0.25, animations: {
            self.menuButton?.isHidden = false
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navigationController" {
            
            zeatNavigationController = segue.destination as? ZeatNavigationController
            zeatNavigationController?.showCurrentCartView = { [weak self] (order) in
                
                self!.currentOrder = order

                UIView.animate(withDuration: 0.25, animations: {
                    self!.currentOrderView?.isHidden = false
                    self!.currentOrderViewHeightConstraint?.constant = 40
                }, completion: nil)

            }

            zeatNavigationController?.hideCurrentCartView = { [weak self] () in
                UIView.animate(withDuration: 0.25, animations: {
                    self!.currentOrderView?.isHidden = true
                    self!.currentOrderViewHeightConstraint?.constant = 0
                }, completion: nil)
            }

            zeatNavigationController?.hideMenuButton = {[weak self] () in
                UIView.animate(withDuration: 0.25, animations: {
                    self!.currentOrderTrailingToSuperViewCenterX.constant = (self!.currentOrderView?.frame.size.width)!/2
                    self!.view.layoutIfNeeded()
                }, completion: nil)
            }

            zeatNavigationController?.showMenuButton = {[weak self] () in
                UIView.animate(withDuration: 0.25, animations: {
                    self!.currentOrderTrailingToSuperViewCenterX.constant = 0
                    self!.view.layoutIfNeeded()
                }, completion: nil)
            }

            zeatNavigationController?.enableMenuButton = {[weak self] () in
                self?.menuButton?.isEnabled = true
            }

            zeatNavigationController?.disableMenuButton = {[weak self] () in
                self?.menuButton?.isEnabled = false
            }
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func showCurrentMenu(_ sender: UIButton) {
        
        ZeatUtility.getRestaurantDetailsForActiveOrder { (restaurant) in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let currentMenuController = storyboard.instantiateViewController(withIdentifier :"restaurantMenuViewController") as! RestaurantMenuTableViewController
            
            currentMenuController.zeatRestaurant = restaurant
            DispatchQueue.main.async {
                self.zeatNavigationController?.pushViewController(currentMenuController, animated: true)
            }
        }

    }

    
    @IBAction func showCurrentOrder(_ sender: UIButton) {
        
        ZeatUtility.getRestaurantDetailsForActiveOrder { (restaurant) in

            let storyboard = UIStoryboard(name: "Order", bundle: nil)
            let currentOrderNavController = storyboard.instantiateViewController(withIdentifier :"currentOrderNavigationController") as! UINavigationController
            
            if let orderController = currentOrderNavController.topViewController as? CurrentOrderViewController {
                orderController.currentOrder = self.currentOrder

                orderController.dismiss = {[unowned self] () in
                    self.dismiss(animated: true, completion: nil)
                }

            }

            
            DispatchQueue.main.async {
                self.present(currentOrderNavController, animated: true, completion: nil)
            }
        }
        
        
    }

    
}
