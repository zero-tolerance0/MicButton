//
//  MicButton.swift
//  Megafon
//
//  Created by no_cola on 7/5/19.
//  Copyright © 2019 Alexander Bredikhin. All rights reserved.
//

import UIKit
import AVKit

protocol SliderDelegate: class {
    func onOff(_ on: Bool)
    func value(changed: Float)
}

protocol SliderActionViewType: UIView {
    var isActive: Bool { get set }
}

@IBDesignable
class MicButton: UIControl{
    private let logTag = String(describing: MicButton.self)
    weak var delegate: SliderDelegate?
    private var isOn: Bool = false {
        willSet {
            if newValue != isOn {
                delegate?.onOff(newValue)
            }
        }
    }
    private lazy var renderer: MicRenderer = MicRenderer()
        
//    var actionView: SliderActionViewType? {
//        didSet {
//            actionView!.translatesAutoresizingMaskIntoConstraints = false
//        }
//    }
    var actionView: SliderActionViewType? {
        didSet {
            actionView!.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    var megaphoneIV: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "megaphone")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var progressEnabled: Bool = true {
        didSet {renderer.updateThumb()}
    }
    
    // MARK: Properties
    
    /** Contains a Boolean value indicating whether changes
     in the sliders value generate continuous update events. */
    var isContinuous = true
    
    /// Value must be in range [0 ... maxPosition].
    var position: Float {
        get { return renderer.progressValue }
        set {
            isOn = newValue != 0
            return renderer.progressValue = newValue
        }
    }
    override var isEnabled: Bool {
        didSet {
            actionView?.isActive = isEnabled
        }
    }
    @objc private func handleGesture(_ gesture: RotationGestureRecognizer) {
        if progressEnabled {
            let angle = gesture.touchAngle < renderer.startAngle ?
                gesture.touchAngle + 2 * CGFloat.pi : gesture.touchAngle
            if gesture.radius > renderer.arcRadius + renderer.arcWidth ||
                gesture.radius < renderer.arcRadius - renderer.arcWidth {
                return
            }

            let midAngleStartEnd = renderer.endAngle +
                (CGFloat.pi * 2 - (renderer.endAngle - renderer.startAngle)) / 2
            let boundedAngle = angle < midAngleStartEnd ?
                min(renderer.endAngle, angle) : min(renderer.startAngle, angle)

            let angleRange = renderer.endAngle - renderer.startAngle
            let valueRange = renderer.maxValue - renderer.minValue
            let angleValue =
                Float(boundedAngle - renderer.startAngle) / Float(angleRange) * valueRange
            
            renderer.progressValue = min(
                renderer.maxValue + 1, max(renderer.minValue, angleValue))
            
            if isContinuous {
                sendActions(for: .valueChanged)
                delegate?.value(changed: renderer.progressValue)
            } else {
                if gesture.state == .ended || gesture.state == .cancelled {
                    sendActions(for: .valueChanged)
                    delegate?.value(changed: renderer.progressValue)
                }
            }
            
            if gesture.state == .ended || gesture.state == .cancelled {
                isOn = isOn ? renderer.progressValue > 0.2 : renderer.progressValue > 0
            }
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    //Redraw after constraints have changed.
    override func layoutSubviews() {
        addSubview(megaphoneIV)
        let a = bounds.height * 0.64
         NSLayoutConstraint.activate([
            megaphoneIV.centerXAnchor.constraint(equalTo: centerXAnchor),
            megaphoneIV.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10),
            megaphoneIV.widthAnchor.constraint(equalToConstant: a),
            megaphoneIV.heightAnchor.constraint(equalToConstant: a)
        ])
        megaphoneIV.layer.cornerRadius = a / 2
//        if let actionView = actionView {
//            actionView.removeFromSuperview()
//
//            addSubview(actionView)
//            let a = bounds.height * 0.64
//             NSLayoutConstraint.activate([
//                actionView.centerXAnchor.constraint(equalTo: centerXAnchor),
//                actionView.centerYAnchor.constraint(equalTo: centerYAnchor),
//                actionView.widthAnchor.constraint(equalToConstant: a),
//                actionView.heightAnchor.constraint(equalToConstant: a)
//            ])
//            actionView.layer.cornerRadius = a / 2
//        }
        renderer.updateBounds(bounds)
    }
    
    private func commonInit() {
        renderer.updateBounds(bounds)
        // Add gestures recognizer.
        let gestureRecognizer = RotationGestureRecognizer(
            target: self, action: #selector(handleGesture(_:))
        )
        addGestureRecognizer(gestureRecognizer)

        //Add sublayers renderer.
        layer.addSublayer(renderer.bottomProgressLayer)
        layer.addSublayer(renderer.progressLayer)
        layer.addSublayer(renderer.markLayer)
//        layer.addSublayer(renderer.thumbLayer)
        layer.addSublayer(renderer.thumbImgLayer)
//        renderer.thumbLayer.insertSublayer(renderer.thumbImgLayer, at: 0)
//        layer.addSublayer(renderer.buttonLayer)
        layer.addSublayer(renderer.innerCircleBottomProgressShadowLayer)
//        renderer.bottomProgressLayer.addSublayer(renderer.bottomProgressShadowLayer)
//        bottomProgressShadowLayer.frame = arcPath.bounds
        
//        CALayer.performWithoutAnimation(){
//            bottomProgressShadowLayer.shadowPath = arcPath.cgPath
//        }
//        bottomProgressShadowLayer.mask = maskLayer
    }
    
    deinit {
//        Logger.i(withTag: logTag, #function, message: "")
    }
}



