//
//  CALayer+ performWithoutAnimation.swift
//  CircularButtonSampleProject
//
//  Created by didarmarat on 26.02.2022.
//

import UIKit

extension CALayer {
    class func performWithoutAnimation(_ actionsWithoutAnimation: () -> Void){
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        actionsWithoutAnimation()
        CATransaction.commit()
    }
}
