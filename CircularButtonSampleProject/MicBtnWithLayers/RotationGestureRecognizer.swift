//
//  RotationGestureRecognizer.swift
//  Megafon
//
//  Created by didarmarat on 26.02.2022.
//  Copyright © 2022 Zubkov Nikolay. All rights reserved.
//

import UIKit

class RotationGestureRecognizer: UIPanGestureRecognizer {
    // Touch angle.
    private(set) var touchAngle: CGFloat = 0
    // Last touch point.
    private(set) var touchPoint: CGPoint = .zero
    // Radius from view center to touchPoint.
    private(set) var radius: CGFloat = 0
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        
        maximumNumberOfTouches = 1
        minimumNumberOfTouches = 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        updateAngle(with: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        updateAngle(with: touches)
    }
    
    private func updateAngle(with touches: Set<UITouch>) {
        guard
            let touch = touches.first,
            let view = view
            else {
                return
        }
        touchPoint = touch.location(in: view)
        touchAngle = angle(for: touchPoint, in: view)
    }
    
    private func angle(for point: CGPoint, in view: UIView) -> CGFloat {
        let centerOffset = CGPoint(
            x: point.x - view.bounds.midX, y: point.y - view.bounds.midY)
        var angle = atan2(centerOffset.y, centerOffset.x)
        if angle < 0 {
            angle = CGFloat.pi * 2 + angle
        }
        let cosine = cos(angle)
        radius = cosine != 0 ? abs(centerOffset.x / cos(angle)) : centerOffset.x
        return angle
    }
}
