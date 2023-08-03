//
//  LineDashPhaseView.swift
//  LineDashPhase-animation
//
//  Created by imh on 2023/8/2.
//

import UIKit

class LineDashPhaseView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    lazy var shapeLayer:CAShapeLayer = {
        let sl = CAShapeLayer()
        sl.lineWidth = 2
        sl.strokeColor = UIColor.black.cgColor
        sl.fillColor = UIColor.blue.withAlphaComponent(0.4).cgColor
        sl.lineDashPhase = 0
        sl.lineCap = .round
        sl.lineJoin = .round
        sl.lineDashPattern = [5, 3]
        return sl
    }()
    
    lazy var animation:CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "lineDashPhase")
        
        /*
         1.虚线运动方向调换fromValue和toValue即可
           Dotted line movement direction can be exchanged fromValue and toValue
         2.
         */
        animation.fromValue = 0
        animation.toValue = shapeLayer.lineDashPattern?.reduce(0) { $0 - $1.intValue } ?? 0
        animation.duration = 1
        animation.repeatCount = .infinity
        return animation
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.layer.masksToBounds = true
        self.layer.addSublayer(shapeLayer)
        
        // 添加动画效果
        shapeLayer.add(animation, forKey: "line")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin:CGFloat = 10
        shapeLayer.bounds = self.bounds
        shapeLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        let rect = CGRect(x: margin, y: margin, width: self.bounds.width - margin * 2, height: self.bounds.height - margin * 2)
        shapeLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: 10).cgPath
    }
}
