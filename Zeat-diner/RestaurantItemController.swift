//
//  RestaurantItemController.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 5/5/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import UIKit

class RestaurantItemController: UIViewController {

    /*
     // MARK: - IB Outlets
     */
    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var itemHeaderView: UIView!
    @IBOutlet weak var navBar: UIView!

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var itemNameLabel: UILabel!

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var itemImageTopToItemHeaderTop: NSLayoutConstraint!

    @IBOutlet weak var navBarTopToSuperView: NSLayoutConstraint!
    
    let initialHeaderMaximumHeight: CGFloat = 220
    var headerMaximumHeight: CGFloat = 220
    let headerMinimumHeight: CGFloat = 84
    let scrollOffsetForNavbarToTrigger: CGFloat = 40

    var isNavBarVisible: Bool = false
    var itemOptionVC: RestaurantItemOptionController = RestaurantItemOptionController()
    var dismiss: (() -> Void)?
    var gradientView: UIView?
    var orderItem: OrderItem = OrderItem()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //

//        headerMaximumHeight = headerMinimumHeight + scrollOffsetForNavbarToTrigger
        headerHeight.constant = headerMaximumHeight

        
        self.navBar.isHidden = true
        self.isNavBarVisible = false
        itemNameLabel.text = itemOptionVC.item?.itemName
        
        ZeatUtility.getDinerActiveOrder { [weak self] (order) in
            if let order = order {
                self?.orderItem.orderId = order.orderId
                self?.orderItem.restaurantId = order.restaurant?.restaurantId
            }
        }
        
    
        orderItem.orderId = ZeatSharedData.sharedInstance.activeOrder?.orderId
        orderItem.itemId = itemOptionVC.item?.id
        orderItem.itemName = itemOptionVC.item?.itemName
        orderItem.itemPrice =  itemOptionVC.item?.itemPrice
//        orderItem.itemD
        orderItem.itemStatus = ITEM_STATUS_IN_CART

        self.addChild(itemOptionVC)
        itemOptionVC.view.translatesAutoresizingMaskIntoConstraints =  false
        itemOptionVC.itemHeaderHeight = headerMaximumHeight < initialHeaderMaximumHeight ? 0 : initialHeaderMaximumHeight
        itemOptionVC.cartButtonCallBack = { [weak self] () in
            self?.updateAddToCartButton()
        }

        itemOptionVC.scrollViewDidScrollCallBack = { [weak self] scrollView in
            self?.scrollViewDidScroll(scrollView)
        }
        
        optionView.addSubview(itemOptionVC.view)

        // Programmatically Added Constraints for the new view as we use constraints in IB
        NSLayoutConstraint.activate(
            [
                itemOptionVC.view.leadingAnchor.constraint(equalTo: optionView.leadingAnchor, constant: 0.0),
                itemOptionVC.view.trailingAnchor.constraint(equalTo: optionView.trailingAnchor, constant: 0.0),
                itemOptionVC.view.topAnchor.constraint(equalTo: optionView.topAnchor, constant: 44.0),
                itemOptionVC.view.bottomAnchor.constraint(equalTo: optionView.bottomAnchor, constant: 0.0)
            ]
        )
        
        /* Add a Black gradient to Image so that status bar can be seen clearly */
        gradientView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64))
        let gradient = CAGradientLayer()
        gradient.frame = self.gradientView!.bounds
        let startColor = UIColor.black.cgColor;
        let endColor = UIColor.clear.cgColor.copy(alpha: 0)
        gradient.colors = [startColor as Any, endColor as Any]
        self.itemImage.layer.insertSublayer(gradient, at: 0)
        
        // Set Close Button Image
        self.closeButton.setImage(#imageLiteral(resourceName: "CloseWhiteInactive"), for: UIControl.State.normal)
        self.closeButton.setImage(#imageLiteral(resourceName: "CloseWhiteActive"), for: UIControl.State.highlighted)
        
        updateAddToCartButton()
    
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


    func updateAddToCartButton() {
        var price: Double = 0
        var optionPrice: Double = 0
        var buttonStatus: Bool = true
        
        for (_, optionStatus) in itemOptionVC.optionStatus {
            if !optionStatus {
                buttonStatus = false
                break
            }
        }
        
        price = (itemOptionVC.item?.itemPrice?.doubleValue)! * 100
            
//            (itemOptionVC.item?.itemPrice?.doubleValue)!
        
        for (_, selecteOptionPrice) in itemOptionVC.optionPrice {
            optionPrice += selecteOptionPrice * 100
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        price += optionPrice
        price = Double(itemOptionVC.itemOrderCount) * price
        
        let formattedPrice = numberFormatter.string(from: NSNumber(value: price/100) )
        
        addToCartButton.setTitle("ADD TO CART (\(String(describing: formattedPrice!)))", for: .disabled)
        addToCartButton.setTitle("ADD TO CART (\(String(describing: formattedPrice!)))", for: .normal)
        addToCartButton.setTitle("ADD TO CART (\(String(describing: formattedPrice!)))", for: .highlighted)
        
        
        addToCartButton.isEnabled = buttonStatus
        orderItem.itemOptionPrice = numberFormatter.string(from: NSNumber(value: optionPrice) )
        orderItem.totalPrice = String(format: "%.2f", round(price)/100)
        
    }

    @IBAction func closeMenu(_ sender: UIButton) {
        dismiss?()
    }

    @IBAction func addToCart(_ sender: UIButton) {
        if let additionalInstructions = itemOptionVC.additionalInstructions{
            orderItem.itemSpecialInstructions = additionalInstructions
        }


        
        if let orderId = orderItem.orderId {
            orderItem.itemOptionGroups = itemOptionVC.selectedOptionGroup
            orderItem.orderItemId = UUID().uuidString
            orderItem.itemQuantity = itemOptionVC.itemOrderCount

            OrderService.addItemTo(order: orderId, forItems: [orderItem]) { [weak self] (response) in
                DispatchQueue.main.async {
                    self?.dismiss?()
                }
            }
        } else {
            // No Active Order Found. A new order needs to be created first
            // Open up dine in

        }
        
        
//        order
    }

    
}

extension RestaurantItemController: UIScrollViewDelegate {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if navBar.isHidden {
            return .lightContent
        } else {
            return .default
        }
        
    }
    
    func showRestaurantImage() {
        isNavBarVisible = false
        itemHeaderView.isHidden = false
        //        itemImage.isHidden = false
        // Layout before animation for animation to be correct
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25, animations: {
            //            self.itemImageTopToHeaderTop.constant = 0
            self.navBarTopToSuperView.constant = -1 * self.headerMinimumHeight
            self.view.layoutIfNeeded()
        }, completion: { (status) -> Void in
            self.navBar.isHidden = true
            self.closeButton.setImage(#imageLiteral(resourceName: "CloseWhiteInactive"), for: UIControl.State.normal)
            self.closeButton.setImage(#imageLiteral(resourceName: "CloseWhiteActive"), for: UIControl.State.highlighted)
            self.view.setNeedsUpdateConstraints()
            self.setNeedsStatusBarAppearanceUpdate()
            
        })
    }

    func showNavigationBar() {
        isNavBarVisible = true
        navBar.isHidden = false
        self.setNeedsStatusBarAppearanceUpdate()
        // Layout before animation for animation to be correct
        self.navBarTopToSuperView.constant = -1 * self.headerMinimumHeight
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.navBarTopToSuperView.constant = -44
            self.view.layoutIfNeeded()
        }, completion: { (status) -> Void in
            // Need to move Status Bar Update earlier
            self.closeButton.setImage(#imageLiteral(resourceName: "CloseBlackInactive"), for: UIControl.State.normal)
            self.closeButton.setImage(#imageLiteral(resourceName: "CloseBlackActive"), for: UIControl.State.highlighted)
            // Set Right Button Image
            //            self.rightButton.setImage(#imageLiteral(resourceName: "DineinBlackInactive"), for: UIControlState.normal)
            //            self.rightButton.setImage(#imageLiteral(resourceName: "DineinBlackActive"), for: UIControlState.highlighted)
            
            self.view.setNeedsUpdateConstraints()
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        var newHeaderHeight = headerMaximumHeight - scrollView.contentOffset.y
        
        newHeaderHeight = newHeaderHeight >= headerMaximumHeight ? headerMaximumHeight : newHeaderHeight <= headerMinimumHeight ? headerMinimumHeight : newHeaderHeight
        
        headerHeight.constant = newHeaderHeight
        
        if scrollView.contentOffset.y >= headerMaximumHeight - headerMinimumHeight + scrollOffsetForNavbarToTrigger {
            if !(isNavBarVisible) {
                showNavigationBar()
            }
        } else {
            if isNavBarVisible {
                showRestaurantImage()
            }
        }
        
        self.view.setNeedsUpdateConstraints()
        
    }
}
