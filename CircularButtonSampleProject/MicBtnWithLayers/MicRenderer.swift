//
//  MicRenderer.swift
//  Megafon
//
//  Created by didarmarat on 26.02.2022.
//  Copyright © 2022 Zubkov Nikolay. All rights reserved.
//

import UIKit

class MicRenderer {
    // MARK: Properties
    private let positionLableSize = CGSize(width: 20, height: 20)
    private let units: Float = 8
    let maxValue: Float = 3
    let minValue: Float = 0
    var arcRadius: CGFloat = 233 / 2 //84
    var arcWidth: CGFloat = 24
    
    lazy var twoPi: Float = Float.pi * 2
    lazy var startAngle: CGFloat = CGFloat(twoPi * 3 / units)
    lazy var endAngle: CGFloat = CGFloat(twoPi * 9 / units)
    lazy var buttonRadius: CGFloat = arcRadius - arcWidth / 1.5
    
    //цвет bottom progress
    let idleColor: CGColor = UIColor.uicolorFromHex(rgbValue: 0xDCC7FF).cgColor
    //цвет текста
    var marksColor: CGColor = UIColor.white.cgColor {
        didSet { markLayer.fillColor = marksColor}
    }
    //цвет кружка
    var thumbColor: CGColor = UIColor.uicolorFromHex(rgbValue: 0x620C90).cgColor {
        didSet { thumbLayer.fillColor = thumbColor }
    }
    
    var progressValue: Float = .zero {
        willSet{
            precondition(
                progressValue <= maxValue && progressValue >= minValue,
                "Value must be in range [0 .. \(maxValue)], current is \(progressValue)"
            )
        }
        
        didSet {
            updateProgress()
        }
    }
    
    var pulsatingColor: CGColor = UIColor.red.withAlphaComponent(0.6).cgColor
    
    // Mark: Used layers.
    let bottomProgressLayer = CAShapeLayer()
    let progressLayer = CAGradientLayer()
    
    let innerCircleBottomProgressShadowLayer = CAShapeLayer()
    let outerCircleBottomProgressShadowLayer = CAShapeLayer()
    
    let thumbLayer = CAShapeLayer()
    
    lazy var thumbImgLayer: CALayer = {
        let myLayer = CALayer()
        let myImage = UIImage(named: "ic_thumb")?.cgImage
        myLayer.contents = myImage
        return myLayer
    }()
    
    let buttonLayer = CALayer()
    let markLayer = CAShapeLayer()
    
    init() {
//        bottomProgressShadowLayer.locations = [0, 1.0]
//        bottomProgressShadowLayer.backgroundColor = UIColor.red.cgColor
//        bottomProgressShadowLayer.colors = [
//            UIColor.black.cgColor,
//            UIColor.white.cgColor,
//        ]
//        bottomProgressShadowLayer.shadowRadius = 20
//        bottomProgressShadowLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
//        bottomProgressShadowLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
    }
    func updateInnerOuterCirclesShadowBounds(_ bounds: CGRect){
//        let bounds = bottomProgressLayer.bounds
//        let center = CGPoint(x: bounds.midX, y: bounds.midY)
//        let arcPath = UIBezierPath(
//            arcCenter: center,
//            radius: arcRadius,
//            startAngle: startAngle,
//            endAngle: endAngle,
//            clockwise: true
//        )
////        innerCircleBottomProgressShadowLayer.masksToBounds = false
//        innerCircleBottomProgressShadowLayer.fillRule = CAShapeLayerFillRule.evenOdd
//
//        innerCircleBottomProgressShadowLayer.fillColor = UIColor.lightGray.withAlphaComponent(1).cgColor
//        innerCircleBottomProgressShadowLayer.path = arcPath.cgPath
//
//        innerCircleBottomProgressShadowLayer.shadowRadius = 2
//        innerCircleBottomProgressShadowLayer.shadowColor = UIColor.black.cgColor
//        innerCircleBottomProgressShadowLayer.shadowOpacity = 0.5
//        innerCircleBottomProgressShadowLayer.shadowOffset = CGSize(width: 0, height: 0)
    }
            
    func updateBounds(_ bounds: CGRect) {
        arcRadius = bounds.height / 2.5
        arcWidth = arcRadius / 2.4
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
                
        //Bottom progress
        bottomProgressLayer.frame = bounds
        bottomProgressLayer.position = center
        updateBottomProgress()
        //Button
        updateButton(bounds: bounds)
        
        //Marks
        updateMarks(bounds: bounds)
        
        //Progress
        progressLayer.frame = bounds
        thumbLayer.frame = bounds
        progressLayer.position = center
//        progressLayer.lineCap = CAShapeLayerLineCap.round
        progressLayer.cornerRadius = 31
        updateProgress()
        
//        updateInnerOuterCirclesShadowBounds(bounds)
//        bottomProgressLayer.shadowPath =
        //Bottom progress shadow gradient
//        bottomProgressShadowLayer.frame = bounds
    }
    
    func updateButton(bounds: CGRect) {
        let bazeSize = arcRadius - arcWidth / 1.2
        let size = CGSize(width: bazeSize * 2, height: bazeSize * 2)
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        buttonLayer.backgroundColor = UIColor.white.cgColor
        buttonLayer.frame = CGRect(origin: center, size: size)
        buttonLayer.cornerRadius = size.height / 3
        buttonLayer.position = center
        buttonLayer.cornerRadius = buttonLayer.bounds.height / 2
    }
    
    fileprivate func updateBottomProgress() {
        
        //draw arc
        let bounds = bottomProgressLayer.bounds
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let arcPath = UIBezierPath(
            arcCenter: center,
            radius: arcRadius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        
        bottomProgressLayer.path = arcPath.cgPath
        bottomProgressLayer.fillColor = UIColor.clear.cgColor
        bottomProgressLayer.lineWidth = arcWidth
        bottomProgressLayer.strokeColor = idleColor //UIColor.black.withAlphaComponent(0.1).cgColor
        bottomProgressLayer.lineCap = CAShapeLayerLineCap.round
        
        

    }
    
    fileprivate func updateProgress(){
        let w =  (twoPi * progressValue) / (maxValue + 1 - minValue)
        let end = startAngle + CGFloat(w)
        progressLayer.cornerRadius = 31
        updateArc(
            layer: progressLayer,
            fromAngle: startAngle,
            toAngle: end
        )
        updateThumb()
        progressLayer.needsDisplay()
    }
    
    fileprivate func updateArc(layer: CAGradientLayer,
                               fromAngle: CGFloat, toAngle: CGFloat) {
        layer.startPoint = CGPoint(x: 0.0, y: 1.0)
        layer.endPoint = CGPoint(x: 1.0, y: 1.0)
        layer.locations = [0.3, 0.7]
        
        // make sure to use .cgColor
        layer.colors = [
            UIColor.rgba(r: 89, g: 32, b: 174, a: 255) .cgColor,
            UIColor.rgba(r: 89, g: 32, b: 174, a: 255) .cgColor,
        ]
        //draw arc
        let bounds = layer.bounds
        let maskLayer = CAShapeLayer()
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let arcPath = UIBezierPath(
            arcCenter: center,
            radius: arcRadius,
            startAngle: fromAngle,
            endAngle: toAngle,
            clockwise: true
        )
        
        maskLayer.path = arcPath.cgPath
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.strokeColor = UIColor.white.cgColor
        maskLayer.lineWidth = arcWidth
        layer.mask = maskLayer
    }
    
    fileprivate func updateMarks(bounds: CGRect) {
        //draw lable marks
        markLayer.sublayers = nil
        addPositionMark(bounds: bounds)
    }
    
    
    fileprivate func addPositionMark(bounds: CGRect) {
        let boundArc = arcRadius + arcWidth / 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let path = UIBezierPath()
        [0, 1, 2, 3].forEach { (pos) in
            let startPoint = getArcPoint(
                center: center, position: Float(pos), withLength:  boundArc + 5)
            let endPoint = getArcPoint(
                center: center, position: Float(pos), withLength: boundArc + 14)
            path.move(to: startPoint)
            path.addLine(to: endPoint)
            
            let textLayer = LCTextLayer()
            textLayer.string = "\(pos)x"
            textLayer.shouldRasterize = true
            textLayer.frame = CGRect(
                origin: getLablePointForPosition(center: center, position: Float(pos)),
                size: positionLableSize
            )
            
            textLayer.fontSize = positionLableSize.width * 0.8
            textLayer.alignmentMode = .center
            textLayer.foregroundColor = marksColor
//            AppColors.mainViolet.cgColor//
            markLayer.addSublayer(textLayer)
        }
        
        markLayer.path = path.cgPath
        markLayer.strokeColor = marksColor
        markLayer.lineWidth = 1
    }
    
    func updateThumb() {
        let bounds = thumbLayer.bounds
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let thumbPath = UIBezierPath(
            arcCenter: getThumbCenter(center: center),
            radius: arcWidth / 1.34,
            startAngle: 0,
            endAngle: CGFloat(twoPi),
            clockwise: true
        )
        thumbLayer.path = thumbPath.cgPath
        thumbLayer.fillColor = UIColor.uicolorFromHex(rgbValue: 0x620C90).cgColor
        thumbLayer.strokeColor = UIColor.white.cgColor
        thumbLayer.lineWidth = 5
        
        CALayer.performWithoutAnimation(){
            thumbImgLayer.frame = thumbPath.bounds
        }
        
        thumbLayer.shadowRadius = 4
        thumbLayer.shadowColor = UIColor.black.cgColor
        thumbLayer.shadowOpacity = 0.3
        thumbLayer.shadowOffset = CGSize(width: 1, height: 1)
        
    }
    
    // MARK: Private utility methods.
    
    fileprivate func getLablePointForPosition(center: CGPoint, position: Float) -> CGPoint{
        var pointWithOffcet = getArcPoint(
            center: center, position: position, withLength: arcRadius + 50)
        pointWithOffcet.x -= positionLableSize.width / 2
        pointWithOffcet.y -= positionLableSize.height / 2
        return pointWithOffcet
    }
    
    fileprivate func getArcPoint(
        center: CGPoint, position: Float, withLength len: CGFloat) -> CGPoint {
        let w =  (twoPi * position) / (maxValue + 1 - minValue)
        let angle = startAngle + CGFloat(w)
        let x = center.x + len * cos(angle)
        let y = center.y + len * sin(angle)
        return CGPoint(x: x, y: y)
    }
    
    
    fileprivate func getThumbCenter(center: CGPoint) -> CGPoint {
        return getArcPoint(
            center: center, position: progressValue, withLength: arcRadius)
    }
}
