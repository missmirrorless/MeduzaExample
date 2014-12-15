//
//  InterfaceAssistant.swift
//  MeduzaExample
//
//  Created by Max Rovnov on 10.12.14.
//  Copyright (c) 2014 Max Rovnov. All rights reserved.
//

import UIKit

class InterfaceAssistant {
    
    class func addFadeInAnimationToViewController(viewController : UIViewController) {
        var animation : CATransition = CATransition();
        animation.duration = 0.3;
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut);
        animation.type = kCATransitionFade;
        animation.subtype = kCATransitionFromBottom;
        
        viewController.view.window?.layer.addAnimation(animation, forKey: nil);
    }

}
