//
//  CurrentOrderTableViewController.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 11/5/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import UIKit

class CurrentOrderTableViewController: UITableViewController {
    
    var currentOrder: Order?
    var dismiss: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "MenuItemTableViewCell", bundle: nil), forCellReuseIdentifier: "test")
        
        self.title = currentOrder?.restaurant?.name
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "CloseBlackInactive"), style: .plain, target: self, action: #selector(closeButtonPressed))

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if (section == 1) {
            return 1
        } else {
            guard let items = currentOrder?.items
                else {
                    return 0
            }

            return items.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dinerRow", for: indexPath) as? DinerRow
            
            cell?.currentOrder = currentOrder
            
            return cell!
            

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "test", for: indexPath)
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 1) {
            return 120.0
        }else {
            return 100.0
        }

    }
    
    @objc func closeButtonPressed() {
        self.dismiss!()
    }

    @IBAction func showCurrentMenu(_ sender: UIButton) {
        
        ZeatUtility.getRestaurantDetailsForActiveOrder { (restaurant) in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let currentMenuController = storyboard.instantiateViewController(withIdentifier :"restaurantMenuViewController") as! RestaurantMenuTableViewController

            currentMenuController.zeatRestaurant = restaurant
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(currentMenuController, animated: true)
            }
        }
    }

    
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


//extension CurrentOrderTableViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return (currentOrder?.diners?.count)!
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dinerCell", for: indexPath)
//        return cell
//    }
//
//
//}

