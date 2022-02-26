//
//  ViewController.swift
//  CircularButtonSampleProject
//
//  Created by didarmarat on 26.02.2022.
//

import UIKit

class ViewController: UIViewController {

    private var micBtn: MicButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor  = UIColor.uicolorFromHex(rgbValue: 0x979797)
        setUpMicButton()
    }
    
    private func setUpMicButton() {
        let slg = view.safeAreaLayoutGuide
        if micBtn == nil {
            let micFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 256)
            micBtn = MicButton(frame: micFrame)
            micBtn.center = view.center
            micBtn.position = 0
            micBtn.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(micBtn)
        }
        
        NSLayoutConstraint.activate([
            micBtn.topAnchor.constraint(greaterThanOrEqualTo: slg.topAnchor),
            micBtn.bottomAnchor.constraint(
                greaterThanOrEqualTo: view.bottomAnchor,
                constant: -120
            ),
            micBtn.heightAnchor.constraint(equalToConstant: 256),
            micBtn.leadingAnchor.constraint(equalTo: slg.leadingAnchor),
            micBtn.trailingAnchor.constraint(equalTo: slg.trailingAnchor)
        ])
        
        micBtn.delegate = self
    }

}


extension UIViewController: SliderDelegate {
    func onOff(_ on: Bool) {
        
    }
    
    //here is asdasd
    func value(changed: Float) {
        
    }
    
}
