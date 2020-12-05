//
//  RestaurantNewTableController.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 3/10/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import UIKit
import Eureka
import NVActivityIndicatorView

class RestaurantNewTableController: FormViewController {

    var zeatId: String?
    var zeatRestaurant: Restaurant?
    //    var goToJoinTable: ((UIViewController) -> Void)?
    var goToJoinTable: (() -> Void)?
    var dinerActiveOrder: Order?
    
    var cartButtonCallBack: (() -> Void)?
    var optionStatus = [String: Bool]()
    var allowNewTableRequest: Bool = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLoginForm(toForm: form)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.tableView?.tableHeaderView = UIView(frame: .zero)
        self.view.backgroundColor = UIColor.red
        // Dispose of any resources that can be recreated.
    }
    
    
    private func addLoginForm(toForm form: Form) {
        
        
        self.tableView?.backgroundColor = UIColor.white
        
        if let dinerActiveOrder = dinerActiveOrder {
            if ZeatUtility.validActiveDiningStatus.contains(dinerActiveOrder.orderStatus!) {
                allowNewTableRequest = false
            }
        } else {
            if let dinerActiveOrder = ZeatUtility.getDinerActiveOrder() {
                if ZeatUtility.validActiveDiningStatus.contains(dinerActiveOrder.orderStatus!) {
                    allowNewTableRequest = false
                }
            }
        }
        
        if allowNewTableRequest {
            form +++
                Section() {
                    $0.header = HeaderFooterView<UIView>(HeaderFooterProvider.class)
                    $0.header?.height = { CGFloat.leastNormalMagnitude }
                }
                
                <<< NameRow("groupNameTag") {
                    $0.title = "Group Name"
                    //                $0.placeholder = "How would you refer to your group as?"
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnDemand
                    }
                    .cellUpdate {
                        let placeholderString = NSAttributedString(string: "Group Nick Name", attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: 15.0) ]))
                        $1.cell.textLabel?.font = UIFont.systemFont(ofSize: 17.0)
                        $1.cell.textField.textColor = UIColor.gray
                        $0.textField.attributedPlaceholder = placeholderString
                        
                        if !$1.isValid {
                            let placeholderErrorString = NSAttributedString(string: "Group Name is requred", attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.init(red: 255, green: 0, blue: 0, alpha: 0.3), convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: 15.0) ]))
                            $0.textField.attributedPlaceholder = placeholderErrorString
                        }
                }
                <<< StepperRow("dinerCountTag") {
                    $0.title = "1 Diner"
                    $0.value = 1
                    }
                    .cellUpdate {
                        $1.cell.textLabel?.font = UIFont.systemFont(ofSize: 17.0)
                        $1.cell.valueLabel?.isHidden = true
                        $1.cell.stepper.minimumValue = 1
                    }
                    .onChange { row in
                        let value = Int(row.value!)
                        if value > 1 {
                            row.title = String.init(describing: value) + " Diners"
                        } else {
                            row.title = String.init(describing: value) + " Diner"
                        }
                }
                <<< TimeInlineRow("orderDateTag"){
                    $0.title = "Time"
                    $0.value = Date()
                    $0.minimumDate = Date ()
                    $0.maximumDate = Date ().addingTimeInterval(2*60*60)
                }
                <<< ButtonRow("requestButtonTag") {
                    $0.title = "Request New Table"
                    $0.onCellSelection { cell, row in
                        //                    let groupNameRow: TextRow? = form.rowBy(tag: "groupNameTag")
                        form.validate()
                        let valuesDictionary = form.values()
                        guard let groupName = valuesDictionary["groupNameTag"] as! String?
                            ,let dinerCount = valuesDictionary["dinerCountTag"] as! Double?
                            ,var orderDate = valuesDictionary["orderDateTag"] as! Date?
                            else {
                                return
                        }
                        
                        // Just make sure checkin cannot be requested for a time in past if the user stayed
                        // on the page for long
                        if orderDate < Date () {
                            orderDate = Date ()
                        }
                        
                        //                    let activityData = ActivityData()
                        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
                        NVActivityIndicatorPresenter.sharedInstance.setMessage("Requesting Your Table")
                        
                        // TODO
                        // Remove hardcoding
                        let diner = Diner.init()
                        diner.nickname = "Kumar"
                        diner.phone = "+16784488730"
                        
                        let order = Order.init(groupName: groupName, groupCount: Int(dinerCount), orderDate: orderDate, diner: diner, restaurant: self.zeatRestaurant!)
                        
                        OrderService.createNewOrder(forRequest: order) {
                            [unowned self] result in
                            
                            switch result {
                            case .success(let order):
                                ZeatSharedData.sharedInstance.activeOrder = order
                                ZeatSharedData.sharedInstance.orderRestaurant = self.zeatRestaurant
                                self.form.rowBy(tag: "requestButtonTag")?.updateCell()
                                self.allowNewTableRequest = false
                                self.goToJoinTable?()
                                break
                                
                            case .failure(let errorResponse):
                                if let error = errorResponse as? ZeatError {
                                    let alert = UIAlertController(title: error.errorTitle, message: error.errorMessage, preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                                        [unowned self] (alertAction) in
                                        self.goToJoinTable?()
                                        }
                                    )
                                    
                                    alert.view?.tintColor = ZeatAlerts.alertColor
                                    if error.afterErrorAction == "GO_TO_LIST" {
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                    else {
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                    
                                }
                            }
                            
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                            return
                        }
                        return
                        
                        }.cellUpdate({ (cell, row) in
                            cell.textLabel?.textColor = UIColor.white
                            cell.backgroundColor = UIColor.black
                            cell.tintColor = UIColor.black
                            let blackView = UIView()
                            blackView.backgroundColor = UIColor.black
                            cell.selectedBackgroundView = blackView
                            cell.textLabel?.highlightedTextColor = UIColor.gray
                            cell.textLabel?.font = UIFont.systemFont(ofSize: 17.0)
                            cell.isHidden = !(self.allowNewTableRequest)
                        })
            }
        } else {
            form +++
                Section() {
                    $0.header = HeaderFooterView<UIView>(HeaderFooterProvider.class)
                    $0.header?.height = { CGFloat.leastNormalMagnitude }
                }
                <<< LabelRow() {
                    
//                    let orderRestaurantName = dinerActiveOrder!.restaurant!.name
                    
                    $0.title = "You have an active order with \(dinerActiveOrder!.restaurant!.name!). Please cancel your active order."
                    }.cellUpdate({ (cell, row) in
                        cell.textLabel?.numberOfLines = 2
                        cell.textLabel?.font = UIFont.systemFont(ofSize: 13.0)
//                        cell.textLabel?.textColor = UIColor.white
//                        cell.backgroundColor = UIColor.black
//                        cell.tintColor = UIColor.black
//                        let blackView = UIView()
//                        blackView.backgroundColor = UIColor.black
//                        cell.selectedBackgroundView = blackView
//                        cell.textLabel?.highlightedTextColor = UIColor.gray
//                        cell.textLabel?.font = UIFont.systemFont(ofSize: 17.0)
                    })
            
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

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
