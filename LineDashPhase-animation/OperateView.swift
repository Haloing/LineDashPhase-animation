//
//  OperateView.swift
//  LineDashPhase-animation
//
//  Created by imh on 2023/8/3.
//

import UIKit

protocol OperateViewDelegate:AnyObject {
    func animationDirectioSwitch(_ view:OperateView, sender:UISwitch)
    func lineWidthChange(_ view:OperateView, sender:UISlider)
    func cornerRadiusChange(_ view:OperateView, sender:UISlider)
    func durationChange(_ view:OperateView, sender:UISlider)
}

class OperateView: UIView {
    
    public weak var delegate:OperateViewDelegate?

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func switchEvent(_ sender: UISwitch) {
        delegate?.animationDirectioSwitch(self, sender: sender)
    }
    
    
    @IBAction func lineWitdhEvent(_ sender: UISlider) {
        delegate?.lineWidthChange(self, sender: sender)
    }
        
    @IBAction func cornerRadiusEvent(_ sender: UISlider) {
        delegate?.cornerRadiusChange(self, sender: sender)
    }
        
    @IBAction func durationChangeEvent(_ sender: UISlider) {
        delegate?.durationChange(self, sender: sender)
    }
}
