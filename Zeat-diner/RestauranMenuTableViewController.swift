//
//  RestauranMenuTableViewController.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 10/21/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import AlamofireImage

class RestaurantMenuTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    var gradientLayer: UIView?
    
    var currentMenu: Menu?
    var zeatRestaurant: Restaurant?
    let menuItemCellIdentifier = "menuItemTableCell"
    let sectionIdentifier = "sectionHeader"
    let headerIdentifier = "headerIdentifier"
    var showSectionHeaderFlag: Bool = false
    var navBarHidden: Bool = false
    var currentSectionName: String = ""

    let navBarHeight: CGFloat = 44
    let headerBaseHeight: CGFloat = 300
    var superViewTop: CGFloat = 0
    var statusBarHeight: CGFloat = 20
    var headerMinimumHeight: CGFloat = 84
    var headerHeight: CGFloat = 300
    var sectionHeaderHeight: CGFloat = 24
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var sectionHeaderView: UIView!

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var dineInButton: UIButton!
    @IBOutlet weak var sectionHeaderLabel: UILabel!

    @IBOutlet weak var gradientWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var safeAreaTopToNavBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var navBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sectionHeaderTopToNavBarBottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "MenuItemTableViewCell", bundle: nil), forCellReuseIdentifier: menuItemCellIdentifier)
        tableView.register(UINib(nibName: "MenuSectionHeaderViewCell", bundle: nil), forCellReuseIdentifier: sectionIdentifier)
        tableView.register(UINib(nibName: "RestaurantMenuHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: headerIdentifier)

        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension

        statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        headerHeight = statusBarHeight + headerBaseHeight
        
        safeAreaTopToNavBarTopConstraint.constant = -1 * (navBarHeight + statusBarHeight)
        sectionHeaderTopToNavBarBottomConstraint.constant = -1 * sectionHeaderHeight
        navBarHeightConstraint.constant = statusBarHeight + navBarHeight

        
        self.closeButton.setImage(#imageLiteral(resourceName: "BackWhiteInactive"), for: UIControl.State.normal)
        self.closeButton.setImage(#imageLiteral(resourceName: "BackWhiteActive"), for: UIControl.State.highlighted)
        self.dineInButton.setImage(#imageLiteral(resourceName: "DineinWhiteInactive"), for: UIControl.State.normal)
        self.dineInButton.setImage(#imageLiteral(resourceName: "DineinWhiteActive"), for: UIControl.State.highlighted)

        /* Add a Black gradient to Image so that status bar can be seen clearly */
        gradientLayer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: statusBarHeight + navBarHeight))
        let gradient = CAGradientLayer()
        gradient.frame = self.gradientView!.bounds
        let startColor = UIColor.black.cgColor;
        let endColor = UIColor.clear.cgColor.copy(alpha: 0.05)
        gradient.colors = [startColor as Any, endColor as Any]
        self.gradientView.layer.insertSublayer(gradient, at: 0)
        
        let headerView = Bundle.main.loadNibNamed("RestaurantMenuHeader", owner: nil, options: nil)?.first as? RestaurantMenuHeader
        
        headerView?.frame.size.width = UIScreen.main.bounds.width

        let placeholderImage = UIImage(named: "RestaurantPlaceholder")!
        
        if let imageUrlString = zeatRestaurant?.image {
            let urlRequest = URLRequest(url: URL(string: imageUrlString)!)
            headerView?.restaurantImageView.af_setImage(withURLRequest: urlRequest, placeholderImage: placeholderImage, filter: nil, completion: { (response) -> Void in
            })

        } else {
             headerView?.restaurantImageView.image = placeholderImage
        }
        
        headerView?.restauranNameLabel.text = zeatRestaurant?.name

        tableHeaderView?.addSubview(headerView!)

        NSLayoutConstraint.activate(
            [
                (headerView?.leadingAnchor.constraint(equalTo: (self.tableHeaderView?.leadingAnchor)!, constant: 0.0))!,
                (headerView?.trailingAnchor.constraint(equalTo: (self.tableHeaderView?.trailingAnchor)!, constant: 0.0))!,
                (headerView?.topAnchor.constraint(equalTo: (self.tableHeaderView?.topAnchor)!, constant: 0.0))!,
                (headerView?.bottomAnchor.constraint(equalTo: (self.tableHeaderView?.bottomAnchor)!, constant: 0.0))!
            ]
        )
        
        self.view.layoutIfNeeded()

        getMenu();
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        guard let zeatNavigationController = self.navigationController as? ZeatNavigationController else {
            return
        }

        zeatNavigationController.navigationBar.isHidden = true
        zeatNavigationController.disableMenuButton!()
        zeatNavigationController.hideMenuButton!()
    }

    override func viewDidAppear(_ animated: Bool) {

        guard let zeatNavigationController = self.navigationController as? ZeatNavigationController else {
            return
        }
        
        zeatNavigationController.enableMenuButton!()

        /* Add a Black gradient to Image so that status bar can be seen clearly */
//        gradientLayer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: statusBarHeight + navBarHeight))
//        let gradient = CAGradientLayer()
//        gradient.frame = self.gradientView!.bounds
//        let startColor = UIColor.black.cgColor;
//        let endColor = UIColor.clear.cgColor.copy(alpha: 0.05)
//        gradient.colors = [startColor as Any, endColor as Any]
//        self.gradientView.layer.insertSublayer(gradient, at: 0)

    }
    
    func getMenu() {
        guard let menuUrl = self.zeatRestaurant?.menus?.first?.menuUrl()
            else {
                navigationController?.popViewController(animated: true)
                return
        }

        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        NVActivityIndicatorPresenter.sharedInstance.setMessage("Getting Your Menu")

        RestaurantService.getMenuJson(menuUrl: menuUrl){ [weak self] result in
            switch result {
            case .success(let menu):
                self?.currentMenu = menu
                self?.currentMenu?.calculateSections()
                self?.showTableMenu()
                //                    })
                
            case .failure( _):
                break
            }
            
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            return
        }
        
    }

    func showTableMenu() {
        self.tableView.isHidden = false
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showMenuItemSegue", sender: cell)
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showMenuItemSegue" {
            
            let cell = sender as! MenuItemTableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let sectionIndex = currentMenu?.sectionArray[(indexPath?.row)!]
            let subsectionIndex = currentMenu?.subsectionArray[(indexPath?.row)!]
            let itemIndex = currentMenu?.itemArray[(indexPath?.row)!]
            let item = (currentMenu?.sections![sectionIndex!].subsections[subsectionIndex!])?.items[itemIndex!]
            
            let restaurantItemController = segue.destination as! RestaurantItemController
            restaurantItemController.itemOptionVC.item = item
            
            restaurantItemController.dismiss = {[weak self] () in
//                let activeOrder = ZeatUtility.getDinerActiveOrder()
                
//                if (activeOrder != nil) {
//                    weak var zeatNavigationController = self.navigationController as? ZeatNavigationController
//                    zeatNavigationController?.showCurrentCartView!(activeOrder!)
//                }
                
                self?.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard (self.navBarView) != nil else {
            return .lightContent
        }
        
        if navBarHidden {
            return .lightContent
        } else {
            return .default
        }
        
    }
    

    
    func showNavigationBar() {
//        navBarView.isHidden = false
        navBarHidden = false
        //        self.setNeedsStatusBarAppearanceUpdate()
//        self.view.bringSubview(toFront: tableView)
        // Layout before animation for animation to be correct
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.navigationController?.navigationBar.barStyle = .default
            self.safeAreaTopToNavBarTopConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: { (status) -> Void in
            // Need to move Status Bar Update earlier
            self.closeButton.setImage(#imageLiteral(resourceName: "BackBlackInactive"), for: UIControl.State.normal)
            self.closeButton.setImage(#imageLiteral(resourceName: "BackBlackActive"), for: UIControl.State.highlighted)
            self.dineInButton.setImage(#imageLiteral(resourceName: "DineinBlackInactive"), for: UIControl.State.normal)
            self.dineInButton.setImage(#imageLiteral(resourceName: "DineinBlackActive"), for: UIControl.State.highlighted)
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    func hideNavigationBar() {
        //        self.setNeedsStatusBarAppearanceUpdate()
        //        self.view.bringSubview(toFront: tableView)
        // Layout before animation for animation to be correct
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.navigationController?.navigationBar.barStyle = .default
            self.safeAreaTopToNavBarTopConstraint.constant = -1 * (self.navBarHeight + self.statusBarHeight)
            self.view.layoutIfNeeded()
        }, completion: { (status) -> Void in
            // Need to move Status Bar Update earlier
            self.closeButton.setImage(#imageLiteral(resourceName: "BackWhiteInactive"), for: UIControl.State.normal)
            self.closeButton.setImage(#imageLiteral(resourceName: "BackWhiteActive"), for: UIControl.State.highlighted)
            self.dineInButton.setImage(#imageLiteral(resourceName: "DineinWhiteInactive"), for: UIControl.State.normal)
            self.dineInButton.setImage(#imageLiteral(resourceName: "DineinWhiteActive"), for: UIControl.State.highlighted)
            // Set Right Button Image
            //            self.rightButton.setImage(#imageLiteral(resourceName: "DineinBlackInactive"), for: UIControlState.normal)
            //            self.rightButton.setImage(#imageLiteral(resourceName: "DineinBlackActive"), for: UIControlState.highlighted)
//            self.navBarView.isHidden = true
            self.navBarHidden = true
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var count: Int = 0
        
        if let currentMenu = currentMenu {
            count =  currentMenu.totalItemsAndSections
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionIndex = currentMenu?.sectionArray[indexPath.row]
        let subsectionIndex = currentMenu?.subsectionArray[indexPath.row]
        
        
        if currentMenu?.contentType[indexPath.row] == contentTypeValues.item {
            
            var cell: MenuItemTableViewCell! = tableView.dequeueReusableCell(withIdentifier: menuItemCellIdentifier, for: indexPath) as? MenuItemTableViewCell
            if cell == nil {
                cell = tableView.dequeueReusableCell(withIdentifier: menuItemCellIdentifier) as? MenuItemTableViewCell
            }
            
            let itemIndex = currentMenu?.itemArray[indexPath.row]
            let item = (currentMenu?.sections![sectionIndex!].subsections[subsectionIndex!])?.items[itemIndex!]
            cell.itemNameLabel.text = item?.itemName
            cell.itemDescriptionLabel.text = item?.itemDescription
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = Locale.current
            
            var itemPrice: Float = 0.0
            if let itemPriceString = item?.itemPrice {
                itemPrice = Float(itemPriceString)!
            }
            
            cell.itemPriceLabel.text = numberFormatter.string(from: NSNumber(value: (itemPrice)) )
//            cell.itemPriceLabel.text = item?.itemPrice
            
            return cell
            
        } else {
            
            var cell: MenuSectionHeaderViewCell! = tableView.dequeueReusableCell(withIdentifier: sectionIdentifier, for: indexPath) as? MenuSectionHeaderViewCell
            
            if cell == nil {
                cell = tableView.dequeueReusableCell(withIdentifier: sectionIdentifier) as? MenuSectionHeaderViewCell
            }
            
            if let sectionName = currentMenu?.sections![sectionIndex!].sectionName {
                cell?.sectionNameLabel.text = sectionName
                
                if let subsectionName = (currentMenu?.sections![sectionIndex!].subsections[subsectionIndex!])?.subsectionName {
                    cell?.subsectionNameLabel.isHidden = false
                    cell?.subsectionNameLabel.text = subsectionName
                } else {
                    cell?.subsectionNameLabel.isHidden = true
                }
                
            } else {
                cell?.subsectionNameLabel.isHidden = true
                if let subsectionName = (currentMenu?.sections![sectionIndex!].subsections[subsectionIndex!])?.subsectionName {
                    cell?.sectionNameLabel.text = subsectionName
                } else {
                    cell?.sectionNameLabel.isHidden = true
                }
            }
            
            return cell
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        
        if offset >= navBarHeight + statusBarHeight {
            if (navBarHidden) {
                showNavigationBar()
            }
        } else {
            if (offset < navBarHeight + statusBarHeight - 5) {
                if !(navBarHidden) {
                    hideNavigationBar()
                }
            }
        }

        let visibleCells = tableView.visibleCells
        
        if visibleCells.count == 0 {
            return
        }
        
        guard let _ = visibleCells.first else {
            return
        }
        
        var indexPath: IndexPath?
        
        // Get Location of first Cell that had Section Content Type
        for (_,cell) in visibleCells.enumerated() {
            indexPath = tableView.indexPath(for: cell)
            if currentMenu?.contentType[(indexPath?.row)!] == contentTypeValues.section {
                break;
            }
        }
        
//        let indexPath = tableView.indexPath(for: topCell)
        let sectionIndex = currentMenu?.sectionArray[(indexPath?.row)!]
        let subsectionIndex = currentMenu?.subsectionArray[(indexPath?.row)!]
        
        if let subsectionName = (currentMenu?.sections![sectionIndex!].subsections[subsectionIndex!])?.subsectionName {
            currentSectionName = subsectionName
        } else {
            if let sectionName = currentMenu?.sections![sectionIndex!].sectionName {
                currentSectionName = sectionName
            }
        }
        
        let firstSectionPositionInTableView = tableView.rectForRow(at: indexPath!)

        let firstSectionPositionInSuperView = tableView.convert(firstSectionPositionInTableView, to: tableView.superview).origin.y
        
        if indexPath?.row == 0 {
            if firstSectionPositionInSuperView > navBarHeight + statusBarHeight {
                self.sectionHeaderView.isHidden = true
            } else {
                if (navBarHeight + statusBarHeight - firstSectionPositionInSuperView < sectionHeaderHeight) {
                    self.sectionHeaderView.isHidden = false
                    sectionHeaderLabel.text = currentSectionName
                    self.sectionHeaderTopToNavBarBottomConstraint.constant = -1 * (sectionHeaderHeight - ( navBarHeight + statusBarHeight - firstSectionPositionInSuperView))
                    self.sectionHeaderView.backgroundColor = self.sectionHeaderView.backgroundColor?.withAlphaComponent(1 - (self.sectionHeaderTopToNavBarBottomConstraint.constant/sectionHeaderHeight))
                } else {
                    self.sectionHeaderTopToNavBarBottomConstraint.constant = 0
                    self.sectionHeaderView.backgroundColor = self.sectionHeaderView.backgroundColor?.withAlphaComponent(1)
                }
                self.view.layoutIfNeeded()
            }
        } else {
            if self.sectionHeaderTopToNavBarBottomConstraint.constant != 0 {
                self.sectionHeaderView.isHidden = false
                sectionHeaderLabel.text = currentSectionName
                self.sectionHeaderTopToNavBarBottomConstraint.constant = 0
            }
            
            if firstSectionPositionInSuperView >= navBarHeight + statusBarHeight + sectionHeaderHeight {

                let oldSectionIndex = currentMenu?.sectionArray[((indexPath?.row)! - 1)]
                let oldSubsectionIndex = currentMenu?.subsectionArray[((indexPath?.row)! - 1)]
                
                if let subsectionName = (currentMenu?.sections![oldSectionIndex!].subsections[oldSubsectionIndex!])?.subsectionName {
                    currentSectionName = subsectionName
                } else {
                    if let sectionName = currentMenu?.sections![oldSectionIndex!].sectionName {
                        currentSectionName = sectionName
                    }
                }
                
                sectionHeaderLabel.text = currentSectionName

            
            } else {
                sectionHeaderLabel.text = currentSectionName
            }

        }
    }

    @IBAction func closeMenu(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func dineInButtonPressed(_ sender: Any) {
        
        let orderOptionActionSheet = UIAlertController(title: ZeatAlerts.orderOptionTitle, message: ZeatAlerts.orderOptionMessage, preferredStyle: UIAlertController.Style.actionSheet)
        
        orderOptionActionSheet.addAction(UIAlertAction(title: "Dine In", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.showRestaurantDinein()
        }))
        
        orderOptionActionSheet.addAction(UIAlertAction(title: "Online", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.onlineOrder()
            ZeatSharedData.sharedInstance.orderRestaurant = self.zeatRestaurant
        }))
        
        orderOptionActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(orderOptionActionSheet, animated: true, completion: nil)
    }

    func showRestaurantDinein() {
        let restView = RestaurantDineInController()
        restView.zeatRestaurant = self.zeatRestaurant
        restView.dismiss = {[weak self] () in
            let activeOrder = ZeatUtility.getDinerActiveOrder()
            
            if (activeOrder != nil) {
                if let zeatNavigationController = self?.navigationController as? ZeatNavigationController {
                    zeatNavigationController.showCurrentCartView!(activeOrder!)
                }
            }
            
            self?.dismiss(animated: true, completion: nil)
        }
        
        self.present(restView, animated: true, completion: nil)
        
    }
    
    func onlineOrder() {
        let cart = Cart.init(forRestaurant: (zeatRestaurant?.restaurantId)!)
        ZeatSharedData.sharedInstance.cart = cart
    }
    

    
}
