//
//  RestaurantItemController.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 4/23/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import UIKit
import Eureka
import NVActivityIndicatorView

class RestaurantItemOptionController: FormViewController  {


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView?.backgroundColor = UIColor.white
//        self.tableView.delegate
        addItemForm(toForm: form)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var item: MenuItem?
    var cartButtonCallBack: (() -> Void)?
    var scrollViewDidScrollCallBack: ((UIScrollView) -> Void)?
    var optionStatus = [String: Bool]()
    var optionPrice = [String: Double] ()
    var itemOrderCount: Int = 1
    let itemHeaderContentHeight: CGFloat = 140
    var itemHeaderHeight: CGFloat?
    var selectedOptionGroup: [OrderItemOptionGroup] = []
    var additionalInstructions: String?

    
    private func addItemForm(toForm form: Form) {

        
        form +++
            Section() {section in
                var header = HeaderFooterView<ItemHeader>(.nibFile(name: "ItemHeader", bundle: nil))
                header.onSetupView = { [weak self] (view, section) in
                    view.itemName.text = self?.item?.itemName
                    view.itemDescription.text = self?.item?.itemDescription
                }
                
                header.height = { self.itemHeaderContentHeight + self.itemHeaderHeight! }
//                header.height = { 140 }
                section.header = header
                
            }

        for  itemOption in (item?.itemOptionGroups)! {
            
            let optionGroup = OrderItemOptionGroup()
            optionGroup.optionGroupName = itemOption.optionGroupName
            optionGroup.optionGroupType = itemOption.optionGroupType
            selectedOptionGroup.append(optionGroup)
            
            var optionName: String?
            
            optionName = itemOption.optionGroupName?.uppercased()
            optionStatus[optionName!] = false
            
            switch (itemOption.optionGroupType)! {
            case "OPTION_CHOOSE":
                form +++ SelectableSection<ItemOptionRow>(optionName!, selectionType: .singleSelection(enableDeselection: false)) { section in
                    
                    var header = HeaderFooterView<ItemOptionHeader>(.nibFile(name: "ItemOptionHeader", bundle: nil))
                    header.onSetupView = { (view, section) in
                        view.optionName.text = optionName
                        view.required.isHidden = !(itemOption.required!)
                    }
                    section.header = header
                    section.tag = optionName!
                    section.onSelectSelectableRow = { [weak self] cell, row in
                        if section.selectedRows().count == 0 {
                            self?.optionStatus[optionName!] = false
                        } else {
                            self?.optionStatus[optionName!] = true
                        }
                        
                        self?.optionPrice[optionName!] = section.selectedRows().reduce(0.0, {$0 + round(($1.value?.price.doubleValue)! * 100)/100})
                        
                        // Set Selected Value for Order Item Option Groups
                        for (itemOptionGroupIndex, itemOptionGroup) in (self?.selectedOptionGroup)!.enumerated() {
                            if (itemOptionGroup.optionGroupName?.uppercased() == optionName! ) {
                                let optionGroupValue = OrderItemOptionValue()
                                optionGroupValue.optionValueName = section.selectedRow()?.value?.name
                                optionGroupValue.optionValuePrice = section.selectedRow()?.value?.price
                                self?.selectedOptionGroup[itemOptionGroupIndex].itemOptionValues = []
                                self?.selectedOptionGroup[itemOptionGroupIndex].itemOptionValues?.append(optionGroupValue)
                            }
                        }
                        
                        self?.cartButtonCallBack!()
                    }
                }
                
                for itemOptionValue in itemOption.itemOptionValues {
                    form.last! <<< ItemOptionRow(itemOptionValue.optionObjectName) { optionRow in
                        optionRow.cell.optionName.text = itemOptionValue.optionObjectName
                        optionRow.cell.height = { 44 }
                        
                        var optionPrice: String = "0.0"
                        
                        if let price = itemOptionValue.optionObjectPrice {
                            optionPrice = price
                        }
                       
                        let numberFormatter = NumberFormatter()
                        numberFormatter.numberStyle = .currency
                        numberFormatter.locale = Locale.current
                        optionRow.cell.optionPrice.text = numberFormatter.string(from: NSNumber(value: optionPrice.doubleValue ) )

                        optionRow.selectableValue = Option(name: (itemOptionValue.optionObjectName)!, price: optionPrice)
                        
                        optionRow.value = nil
                        }.cellSetup { cell, _ in
                            cell.trueImage = #imageLiteral(resourceName: "selectedRadioBox")
                            cell.falseImage = #imageLiteral(resourceName: "unselectedRadioBox")
                    }
                    
                }
                
            case "OPTION_ADD":
                
                form +++ SelectableSection<ItemOptionRow>(optionName!, selectionType: .multipleSelection) { section in
                    var header = HeaderFooterView<ItemOptionHeader>(.nibFile(name: "ItemOptionHeader", bundle: nil))
                    header.onSetupView = { (view, section) in
                        view.optionName.text = optionName
                        view.required.isHidden = !(itemOption.required!)
                        view.optionMaximum = itemOption.maximum!
                        view.optionMinimum = itemOption.minimum!
                    }
                    section.header = header
                    section.tag = optionName!

                    section.onSelectSelectableRow = { [weak self] cell, row in
                        
                        let header = self?.form.sectionBy(tag: optionName!)?.header?.viewForSection((self?.form.sectionBy(tag: optionName!))!, type: HeaderFooterType.header) as? ItemOptionHeader
                        
                        if section.selectedRows().count >= (header?.optionMinimum)! {
                            self?.optionStatus[optionName!] = true
                        } else {
                            self?.optionStatus[optionName!] = false
                        }
                        
                        self?.optionPrice[optionName!] = section.selectedRows().reduce(0.0, {$0 + round(($1.value?.price.doubleValue)! * 100)/100})

                        if section.selectedRows().count == (header?.optionMaximum)! {
                            for (_, sectionRow) in section.enumerated() {
                                if sectionRow.baseValue ==  nil {
                                    if let itemOptionRow = sectionRow as? ItemOptionRow {
                                        itemOptionRow.cell.isUserInteractionEnabled = false
                                        itemOptionRow.cell.disableCell()
                                    }
                                }
                            }
                        } else {
                            if section.selectedRows().count == (header?.optionMaximum)! - 1 {
                                for (_, sectionRow) in section.enumerated() {
                                    if sectionRow.baseValue ==  nil {
                                        if let itemOptionRow = sectionRow as? ItemOptionRow {
                                            itemOptionRow.cell.isUserInteractionEnabled = true
                                            itemOptionRow.cell.enableCell()
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Set Selected Value for Order Item Option Groups
                        for (itemOptionGroupIndex, itemOptionGroup) in (self?.selectedOptionGroup)!.enumerated() {
                            if (itemOptionGroup.optionGroupName?.uppercased() == optionName! ) {
                                self?.selectedOptionGroup[itemOptionGroupIndex].itemOptionValues = []
                                for selectedOption in section.selectedRows() {
                                    let optionGroupValue = OrderItemOptionValue()
                                    optionGroupValue.optionValueName = selectedOption.value?.name
                                    optionGroupValue.optionValuePrice = selectedOption.value?.price
                                    self?.selectedOptionGroup[itemOptionGroupIndex].itemOptionValues?.append(optionGroupValue)
                                }
                            }
                        }

                        self?.cartButtonCallBack!()
                    }
                    
                }
                for itemOptionValue in itemOption.itemOptionValues {
                    form.last! <<< ItemOptionRow(itemOptionValue.optionObjectName) { optionRow in
                        optionRow.cell.optionName.text = itemOptionValue.optionObjectName
                        optionRow.cell.height = { 44 }
                        optionRow.cell.trueImage = #imageLiteral(resourceName: "selectedCheckBox")
                        optionRow.cell.falseImage = #imageLiteral(resourceName: "unselectedCheckBox")
                        
                        var optionPrice: String = "0.0"
                        
                        if let price = itemOptionValue.optionObjectPrice {
                            optionPrice = price
                        }

                        let numberFormatter = NumberFormatter()
                        numberFormatter.numberStyle = .currency
                        numberFormatter.locale = Locale.current
                        optionRow.cell.optionPrice.text = numberFormatter.string(from: NSNumber(value: optionPrice.doubleValue ) )
                        
                        optionRow.selectableValue = Option(name: (itemOptionValue.optionObjectName)!, price: optionPrice)
                        
                        optionRow.value = nil
                        }.cellSetup { cell, _ in
                            cell.trueImage = #imageLiteral(resourceName: "selectedCheckBox")
                            cell.falseImage = #imageLiteral(resourceName: "unselectedCheckBox")
                    }
                    
                }
                
            case "OPTION_LEVEL":
                
                form +++ Section(optionName!) { section in
                    var header = HeaderFooterView<ItemOptionHeader>(.nibFile(name: "ItemOptionHeader", bundle: nil))
                    header.onSetupView = { (view, section) in
                        view.optionName.text = optionName
                        view.required.isHidden = !(itemOption.required!)
                    }
                    section.header = header
                    section.tag = optionName!
                    }
                    <<< SegmentedRow<String>() {
                        for itemOptionValue in itemOption.itemOptionValues {
                            $0.options?.append(itemOptionValue.optionObjectName!)
                        }
                        }.onChange { [weak self] row in
                            if row.value != nil {
                                self?.optionStatus[optionName!] = true
                            } else {
                                self?.optionStatus[optionName!] = false
                            }

                            for (itemOptionGroupIndex, itemOptionGroup) in (self?.selectedOptionGroup)!.enumerated() {
                                if (itemOptionGroup.optionGroupName?.uppercased() == optionName! ) {
                                    let optionGroupValue = OrderItemOptionValue()
                                    optionGroupValue.optionValueName = row.value
                                    optionGroupValue.optionValuePrice = "0.0"
                                    self?.selectedOptionGroup[itemOptionGroupIndex].itemOptionValues = []
                                    self?.selectedOptionGroup[itemOptionGroupIndex].itemOptionValues?.append(optionGroupValue)
                                }
                            }
                            
                            self?.cartButtonCallBack!()
                            
                }
                
            default:
                break
            }
            
            
        }
        
        form +++
            Section() {
                var header = HeaderFooterView<ItemOptionHeader>(.nibFile(name: "ItemOptionHeader", bundle: nil))
                header.onSetupView = { (view, section) in
                    view.optionName.text = "SPECIAL INSTRUCTIONS"
                    view.required.isHidden = true
                }
                $0.header = header
            }
            <<< TextAreaRow() {
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 50)
                $0.cell.placeholderLabel?.font = UIFont.systemFont(ofSize: 13)
                $0.placeholder = "Add special notes(e.g Extra Sauce, Extra Onions.."
                }.onChange({ [weak self] (row) in
                    self?.additionalInstructions = row.value
                })

        form +++
            Section() {
                var header = HeaderFooterView<ItemOptionHeader>(.nibFile(name: "ItemOptionHeader", bundle: nil))
                header.onSetupView = { (view, section) in
                    view.optionName.text = "QUANTITY"
                    view.required.isHidden = true
                }
                $0.header = header
        }
            <<< StepperRow() {
                $0.value = 1.0
                $0.title = "Specify Quantity"
                $0.displayValueFor = { value in
                    guard let value = value else { return nil }
                    let numberFormatter = DecimalFormatter()
                    numberFormatter.maximumFractionDigits = 0
                    numberFormatter.minimumFractionDigits = 0
                    return numberFormatter.string(from: NSNumber(value: value))
                }
                }.cellSetup() { cell, row in
                    cell.valueLabel?.textColor = UIColor.black
                    row.cell.textLabel?.isHidden = true
                    cell.stepper.minimumValue = 1
                    cell.stepper.maximumValue = 12
                }.onChange() { [weak self] row in
                    self?.itemOrderCount = Int(row.value!)
                    self?.cartButtonCallBack!()
        }
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollViewDidScrollCallBack!(scrollView)
    }

    
}

