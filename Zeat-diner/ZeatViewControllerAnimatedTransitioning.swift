//
//  ZeatViewControllerAnimatedTransitioning.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 2/10/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import UIKit

enum TransitionType {
    case Presenting, Dismissing
}


class ZeatViewControllerAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning{

    private var presenting: Bool
    
    init(presenting: Bool) {
        self.presenting = presenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to) else {
                return
        }
        
        let container = transitionContext.containerView
        
        let containerFrame = container.frame
        var toViewStartFrame = transitionContext.initialFrame(for: toViewController)
        let toViewFinalFrame = transitionContext.finalFrame(for: toViewController)
        var fromViewFinalFrame = transitionContext.finalFrame(for: fromViewController)
        
        if self.presenting {
            toViewStartFrame.origin.x = 0
            toViewStartFrame.origin.y = containerFrame.size.height
        } else {
            fromViewFinalFrame = CGRect(x: 0, y: containerFrame.size.height, width: toViewController.view.frame.size.width, height: toViewController.view.frame.size.height)
        }

        let duration = self.transitionDuration(using: transitionContext)

        if self.presenting {
            container.addSubview(toViewController.view)
            toViewController.view.frame = toViewStartFrame
        } else {
            container.insertSubview(toViewController.view, belowSubview: fromViewController.view)
//            fromViewController.navigationController?.navigationBar.isHidden = true
        }

        UIView.animate(withDuration: duration, animations: {
            if self.presenting {
                toViewController.view.frame = toViewFinalFrame
            } else {
                fromViewController.view.frame = fromViewFinalFrame
            }
            
        }, completion: { finished in
            
            let success = !transitionContext.transitionWasCancelled
            
            // After a failed presentation or successful dismissal, remove the view.
            if ((self.presenting && !success)) {
                toViewController.view.removeFromSuperview()
            }

            if !self.presenting {
//                toViewController.navigationController?.navigationBar.isHidden = false
            }

            // tell our transitionContext object that we've finished animating
            transitionContext.completeTransition(true)
            
        })
        
        
    }
    
    
}
