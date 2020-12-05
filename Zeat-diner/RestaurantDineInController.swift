//
//  RestaurantDineInController.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 3/2/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class RestaurantDineInController: UIViewController {
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var restaurantScrollView: UIScrollView!
    @IBOutlet weak var diningTableView: UITableView!
    
    @IBOutlet weak var navBarTopToSafeAreaTop: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var restaurantImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageBottomToScrollTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var diningSegmentedControl: UISegmentedControl!
    @IBOutlet weak var requestNewTableView: UIView!
    @IBOutlet weak var closeButton: UIButton!

    var navBarHeight: CGFloat = 64

    
    var zeatRestaurant: Restaurant?
    var dismiss: (() -> Void)?

    var gradientView: UIView?
    var openOrderList = [Order]()
    var dinerActiveOrder: Order?

    var newTableVC: RestaurantNewTableController = RestaurantNewTableController()

    
    let imageHeight: CGFloat = 200
    let textCellIdentifier = "DineinTableViewCell"
    let restaurantLabelBottomPosition: CGFloat = 35

    override func viewDidLoad() {
        super.viewDidLoad()

        restaurantName.text = zeatRestaurant!.name
        let placeholderImage = UIImage(named: "RestaurantPlaceholder")!
        let urlRequest = URLRequest(url: URL(string: zeatRestaurant!.image!)!)
        restaurantImage.af_setImage(withURLRequest: urlRequest, placeholderImage: placeholderImage, filter: nil, completion: { (response) -> Void in
            
        })

        
        /* Hide Navigation Bar when */
        navBarView.isHidden = true
        
        // Set Close Button Image
        self.closeButton.setImage(#imageLiteral(resourceName: "CloseWhiteInactive"), for: UIControl.State.normal)
        self.closeButton.setImage(#imageLiteral(resourceName: "CloseWhiteActive"), for: UIControl.State.highlighted)
        

        // Set up Dining Table
        diningTableView.register(UINib(nibName: textCellIdentifier, bundle: nil), forCellReuseIdentifier: textCellIdentifier)
        diningTableView.rowHeight = 85
        diningTableView.isScrollEnabled = false
        diningTableView.tableFooterView = UIView(frame: .zero)
        
        // Check for Diner Status
        if let order = ZeatUtility.getDinerActiveOrder() {
            dinerActiveOrder = order
            diningTableView.allowsSelection = false
        }

        newTableVC.zeatId = zeatRestaurant?.restaurantId
        newTableVC.zeatRestaurant = Restaurant.init()
        newTableVC.zeatRestaurant?.address = zeatRestaurant?.address
        newTableVC.zeatRestaurant?.name = zeatRestaurant?.name
        newTableVC.zeatRestaurant?.phone = zeatRestaurant?.phone
        newTableVC.zeatRestaurant?.restaurantId = zeatRestaurant?.restaurantId
        newTableVC.dinerActiveOrder = dinerActiveOrder

        self.addChild(newTableVC)
        newTableVC.view.translatesAutoresizingMaskIntoConstraints =  false
        requestNewTableView.addSubview(newTableVC.view)
        newTableVC.goToJoinTable = { () in
            self.diningSegmentedControl.selectedSegmentIndex = 1
            self.diningIndexChanged("Request Dining Table")
        }

        // Programmatically Added Constraints for the new view as we use constraints in IB
        NSLayoutConstraint.activate(
            [
                newTableVC.view.leadingAnchor.constraint(equalTo: requestNewTableView.leadingAnchor, constant: 0.0),
                newTableVC.view.trailingAnchor.constraint(equalTo: requestNewTableView.trailingAnchor, constant: 0.0),
                newTableVC.view.topAnchor.constraint(equalTo: requestNewTableView.topAnchor, constant: 0.0),
                newTableVC.view.bottomAnchor.constraint(equalTo: requestNewTableView.bottomAnchor, constant: 0.0)
            ]
        )

        newTableVC.didMove(toParent: self)
        
        restaurantScrollView.delegate = self
        restaurantScrollView.delaysContentTouches = false
        
        contentViewHeight.constant = UIScreen.main.bounds.height - navBarHeight + restaurantLabelBottomPosition

    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
        if #available(iOS 11.0, *) {
            navBarHeight = self.view.safeAreaLayoutGuide.layoutFrame.origin.y + 44
            self.navBarTopToSafeAreaTop.constant = (-1 * self.navBarHeight) - self.view.safeAreaLayoutGuide.layoutFrame.origin.y
        } else {
            // Fallback on earlier versions
            navBarHeight = 20.0 + 44
            self.navBarTopToSafeAreaTop.constant = (-1 * self.navBarHeight) - 20.0
        }

        /* Add a Black gradient to Image so that status bar can be seen clearly */
        gradientView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: navBarHeight))
        let gradient = CAGradientLayer()
        gradient.frame = self.gradientView!.bounds
        let startColor = UIColor.black.cgColor;
        let endColor = UIColor.clear.cgColor.copy(alpha: 0.05)
        gradient.colors = [startColor as Any, endColor as Any]
        self.restaurantImage.layer.insertSublayer(gradient, at: 0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if navBarView.isHidden {
            return .lightContent
        } else {
            return .default
        }
        
    }
    
    
    func getDiningTables() {
        ZeatUtility.showActivityIndicator(withMessage: "Getting Active Tables")
        
        RestaurantService.listOrders(forRestaurant: zeatRestaurant!.restaurantId!) { [unowned self] result in
            
            switch result {
            case .success(let orderArray):
                self.openOrderList = orderArray
                self.diningTableView.reloadData()
                
            case .failure( _):
                break
            }
            
            ZeatUtility.stopActivityIndicator()

            return
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
    
    /*
    // MARK: - Action
    */
    
//
//   
    
    @IBAction func closeRestaurantDinein(_ sender: Any) {
        dismiss?()
    }

    
    @IBAction func diningIndexChanged(_ sender: Any) {
        
        switch diningSegmentedControl.selectedSegmentIndex {
        case 0:
            diningTableView.isHidden = true
//            if let order = ZeatUtility.getDinerActiveOrder() {
//                requestNewTableView.
//                dinerActiveOrder = order
                
//                requestNewTableView.order
//            }
            requestNewTableView.isHidden = false
            
            break
        case 1:
            diningTableView.isHidden = false
            requestNewTableView.isHidden = true
            if let order = ZeatUtility.getDinerActiveOrder() {
                dinerActiveOrder = order
                diningTableView.allowsSelection = false
            }
            getDiningTables()
        default:
            break
        }
    }


}

extension RestaurantDineInController: UIScrollViewDelegate {


    func showNavigationBar() {
        self.setNeedsStatusBarAppearanceUpdate()
        self.navBarView.isHidden = false
        self.view.layoutIfNeeded()


        UIView.animate(withDuration: 0.25, animations: {
            if #available(iOS 11.0, *) {
                self.navBarTopToSafeAreaTop.constant = -1 * self.view.safeAreaLayoutGuide.layoutFrame.origin.y
            } else {
                // Fallback on earlier versions
                self.navBarTopToSafeAreaTop.constant = -20.0
            }
            self.view.layoutIfNeeded()

            
        }, completion: { (status) -> Void in
            // Need to move Status Bar Update earlier
            self.view.setNeedsUpdateConstraints()
            self.restaurantImage.isHidden = true
            self.setNeedsStatusBarAppearanceUpdate()
            self.closeButton.setImage(#imageLiteral(resourceName: "CloseBlackInactive"), for: UIControl.State.normal)
            self.closeButton.setImage(#imageLiteral(resourceName: "CloseBlackActive"), for: UIControl.State.highlighted)
        })
    }

    func showRestaurantImage() {
        restaurantImage.isHidden = false
        self.view.layoutIfNeeded()

        UIView.animate(withDuration: 0.25, animations: {

//            self.restaurantImageTopConstraint.constant = 0
            if #available(iOS 11.0, *) {
                self.navBarTopToSafeAreaTop.constant = (-1 * self.navBarHeight) - self.view.safeAreaLayoutGuide.layoutFrame.origin.y
            } else {
                // Fallback on earlier versions
                self.navBarTopToSafeAreaTop.constant = (-1 * self.navBarHeight) - 20.0
            }

            self.view.layoutIfNeeded()

        }, completion: { (status) -> Void in
            self.view.setNeedsUpdateConstraints()
//            self.navBar.isHidden = true
            self.navBarView.isHidden = true

            self.setNeedsStatusBarAppearanceUpdate()
            self.closeButton.setImage(#imageLiteral(resourceName: "CloseWhiteInactive"), for: UIControl.State.normal)
            self.closeButton.setImage(#imageLiteral(resourceName: "CloseWhiteActive"), for: UIControl.State.highlighted)

        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let scrollViewHeight = restaurantScrollView.frame.size.height
        let scrollContentSizeHeight = restaurantScrollView.contentSize.height
        let percentScroll = -1 * restaurantScrollView.contentOffset.y / (scrollContentSizeHeight - scrollViewHeight)

        if restaurantScrollView.contentOffset.y < 0 {
            // Scroll content is moving down w.r.t Origin
            if restaurantScrollView.frame.origin.y < imageHeight {
                // Scrollview Origin was moved up and now has to be brought back to its otriginal
                // height before content in scroll can move further down
                if imageHeightConstraint.constant - restaurantScrollView.contentOffset.y  < imageHeight {
                    // Increase Restaurant Image Height as it has not yet reached its maximum value
                    // Rest Content Offset to ZERO as the content should not scroll down w.r.t the
                    // scroll view
                    imageHeightConstraint.constant  = imageHeightConstraint.constant - restaurantScrollView.contentOffset.y
                    restaurantScrollView.contentOffset.y = 0
                    if restaurantImage.isHidden {
                        showRestaurantImage()
                        diningTableView.isScrollEnabled = false
                    }
                } else {
                    // Set Restaurant Image Height to its maximum permissible value. From
                    // this point onwards, the content within Scroll view would scroll down
                    imageHeightConstraint.constant  = imageHeight
                }
                self.view.setNeedsUpdateConstraints()
                
                //                restaurantScrollView.frame.origin.y = restaurantImage.frame.size.height
            } else {
                // Scroll View is moved down to its lowest level and content is moving
                // down beyond it can. We will increase the image height proportional to
                // how much the user scrolls further down
                let restaurantImageNewHeight = (1 + percentScroll) * imageHeight
                restaurantImage.frame.size.height  = restaurantImageNewHeight
            }
            
        } else {
            
            if imageHeightConstraint.constant > navBarHeight {
                // User is scrolling up but the restaurant image has not reached its lowest value
                // Keep reducing image height until it reaches the lowest point
                // Set Content Offset to ZERO as we are moving the entire Scroll View and not the content
                
                imageHeightConstraint.constant = imageHeightConstraint.constant - restaurantScrollView.contentOffset.y < navBarHeight ? navBarHeight : imageHeightConstraint.constant - restaurantScrollView.contentOffset.y
                restaurantScrollView.contentOffset.y = 0
                self.view.setNeedsUpdateConstraints()
            } else {
                // Show Navigation Bar if it is hidden and the Restaurant Name has gone all the way up
                if restaurantScrollView.contentOffset.y > restaurantLabelBottomPosition && navBarView.isHidden {
                    showNavigationBar()
                    diningTableView.isScrollEnabled = true
                }
            }
        }
    }
}



extension RestaurantDineInController: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return openOrderList.count == 0 ? 0 : 1
//        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return openOrderList.count
//        return openOrderList.count == 0 ? 1 : openOrderList.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: DineinTableViewCell! = diningTableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as? DineinTableViewCell
        
        if cell == nil {
            cell = diningTableView.dequeueReusableCell(withIdentifier: textCellIdentifier) as? DineinTableViewCell
        }
        
        let row = indexPath.row
        let groupName = openOrderList[row].groupName
        
        cell.orderGroupNameLabel.text = groupName
        cell.orderGroupInitialLabel.text = String(groupName![(groupName?.startIndex)!])
        cell.dinerNamesLabel.text = openOrderList[row].dinerNames()
        cell.orderCheckinTimeLabel.text = ZeatUtility.localTime(datetime: openOrderList[row].orderDate!)
        cell.orderGroupCountLabel.text = openOrderList[row].groupCount?.description

        if let activeOrder = dinerActiveOrder {
            if activeOrder.orderId == openOrderList[row].orderId {
                cell?.backgroundColor = UIColor.lightGray
            }
        } else {
            cell?.backgroundColor = UIColor.white
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! DineinTableViewCell!
        
        let row = indexPath.row
        let groupName = openOrderList[row].groupName
        
        let alert = UIAlertController(title: ZeatAlerts.joinTableTitle, message: "Do you wish to join \(String(describing: groupName)) table?", preferredStyle: UIAlertController.Style.alert)
        let joinAction = UIAlertAction(title: "Join", style: .default) { [unowned self] (alertAction) in

            let activityData = ActivityData()
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
            NVActivityIndicatorPresenter.sharedInstance.setMessage("Joining Table")
            
            OrderService.joinDiningTable(forRestaurant: (self.zeatRestaurant?.restaurantId)!, forOrder: self.openOrderList[row].orderId!, preApprovedby: nil) {
                result in
                switch result {
                case .success(_):
                    let alert = UIAlertController(title: "Request Sent", message: "Your request to join table has been sent.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    alert.view?.tintColor = ZeatAlerts.alertColor
                    
                    ZeatSharedData.sharedInstance.orderRestaurant = self.zeatRestaurant
                case .failure(let errorResponse):
                    if let error = errorResponse as? ZeatError {
                        let alert = UIAlertController(title: error.errorTitle, message: error.errorMessage, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        alert.view?.tintColor = ZeatAlerts.alertColor
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
            
            
        }
        
        alert.addAction(joinAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (alertAction) in
            
        }
        alert.addAction(cancelAction)
        alert.view?.tintColor = ZeatAlerts.alertColor
        
        self.present(alert, animated: true) {
            tableView.deselectRow(at: indexPath, animated: true)
        }

//        tableView.deselectRow(at: indexPath, animated: true)

        selectedCell?.orderGroupInitialLabel.backgroundColor = UIColor.black

    }

}

    
//    func gestureRec
    

