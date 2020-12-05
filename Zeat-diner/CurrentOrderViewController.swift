//
//  CurrentOrderViewController.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 11/6/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import UIKit

class CurrentOrderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var currentOrder: Order?
    var dismiss: (() -> Void)?
    
    let orderItemCellIdentifier = "orderItemTableViewCell"
    
//    var lastDinerCount

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var restaurantLabel: UILabel!
    
    var dinerRow: DinerRow?
    
    func getOrderDetails() {
        currentOrder = ZeatUtility.getDinerActiveOrder()
        
        if let restaurant = ZeatSharedData.sharedInstance.orderRestaurant {
            self.restaurantLabel?.text = restaurant.name
        } else {
            self.restaurantLabel?.text = ""
        }
        

        ZeatUtility.getOrderDetails {[weak self] (order) in
            self?.restaurantLabel?.text = order?.restaurant?.name
            self?.currentOrder = order
            self?.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getOrderDetails()

        tableView.register(UINib(nibName: "OrderItemTableViewCell", bundle: nil), forCellReuseIdentifier: orderItemCellIdentifier)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 120.0
        } else if (indexPath.section == 1) {
            return 40.0
        }
        else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        } else if (section == 2) {
            guard let items = currentOrder?.items
                else {
                    return 0
            }
            
            return items.count
        } else {
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.section == 0) {
            return false
        } else {
//            TODO
//            Make it editable if current status is in Cart

            if let currentItem = currentOrder?.items![indexPath.row] {
                if currentItem.itemStatus! > 0 {
                    return false
                } else {
                    return true
                }
            }

            return true
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let cancel = UITableViewRowAction(style: .destructive, title: "Cancel") { action, index in
            //self.isEditing = false
            print("more button tapped")
        }

//        more.backgroundColor = UIColor.lightGray
        
        let order = UITableViewRowAction(style: .normal, title: "Order") { action, index in
            //self.isEditing = false
            print("favorite button tapped")
        }
        order.backgroundColor = UIColor.black
        
        return [cancel, order]
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            
            guard let cell = dinerRow else {
                dinerRow = tableView.dequeueReusableCell(withIdentifier: "dinerRow", for: indexPath) as? DinerRow
                dinerRow?.currentOrder = currentOrder
                return dinerRow!
            }
            
            cell.currentOrder = currentOrder

            cell.dinerCollection?.reloadData()
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: orderItemCellIdentifier, for: indexPath) as? OrderItemTableViewCell
            
            let diner = currentOrder?.diners?.filter{ $0.dinerId == currentOrder?.items![indexPath.row].dinerId }
            
            cell?.itemNameLabel?.text = currentOrder?.items![indexPath.row].itemName
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = Locale.current
            
            if let currentItem = currentOrder?.items![indexPath.row] {
                cell?.itemPriceLabel?.text = numberFormatter.string(from: NSNumber(value: (currentItem.totalPrice?.doubleValue)!))
                cell?.itemCountImageView?.setImage(string: String((currentItem.itemQuantity)!), color: UIColor.colorHash(name: diner![0].nickname), circular: true, textAttributes: nil)
                cell?.itemOptionLabel?.text = currentItem.options()
                cell?.itemStatusLabel?.text = ITEM_STATUS_DESCRIPTION[currentItem.itemStatus!]
                cell?.itemStatusLabel?.textColor = ITEM_STATU_COLOR[currentItem.itemStatus!]
            }
            
            return cell!
        } 
    }

    @IBAction func closeButtonPressed() {
        self.dismiss!()
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
