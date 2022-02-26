//
//  LCTextLayer.swift
//  CircularButtonSampleProject
//
//  Created by didarmarat on 26.02.2022.
//

import UIKit
// Sublass for solve vertical center text problem.
public class LCTextLayer : CATextLayer {
    override public func draw(in context: CGContext) {
        let height = self.bounds.size.height
        let fontSize = self.fontSize
        let yDiff = (height-fontSize)/2 - fontSize/10
        
        context.saveGState()
        context.translateBy(x: 0, y: yDiff)
        super.draw(in: context)
        context.restoreGState()
    }
}
