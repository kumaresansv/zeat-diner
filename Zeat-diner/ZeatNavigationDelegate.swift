////
////  ZeatNavigationDelegate.swift
////  Zeat-diner
////
////  Created by Kumaresan Sankaranarayanan on 2/10/17.
////  Copyright © 2017 Zeat. All rights reserved.
////
//
//import UIKit
//
//class ZeatNavigationDelegate: NSObject, UINavigationControllerDelegate{
//    
//    private var transition: ZeatViewControllerAnimatedTransitioning?
//
//    
//    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        
//        switch operation {
//        case .push:
//            transition = ZeatViewControllerAnimatedTransitioning.init(presenting: true)
////            return ZeatViewControllerAnimatedTransitioning.init(presenting: true)
//        case .pop:
//            transition =  ZeatViewControllerAnimatedTransitioning.init(presenting: false)
////            break
//        default:
//            break
//        }
////        if operation == .pop {
////            return ZeatViewControllerAnimatedTransitioning.animationControllerForDismissedController(transition)
////        }
//        return transition
//    }
//    
//}

