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
    
    enum PanGesture {
        case tl // 左上角
        case tr // 右上角
        case bl // 左下角
        case br // 右下角
        case mv // 移动
    }
    
    // 是否顺时针旋转
    public var isClockwise:Bool = true {
        didSet {
            if isClockwise {
                animation.toValue = shapeLayer.lineDashPattern?.reduce(0) { $0 - $1.intValue } ?? 0
                animation.fromValue = 0
            } else {
                animation.fromValue = shapeLayer.lineDashPattern?.reduce(0) { $0 - $1.intValue } ?? 0
                animation.toValue = 0
            }
            shapeLayer.add(animation, forKey: "line")
        }
    }
    
    // 圆角
    public var cornerRadius:CGFloat = 0 {
        didSet {
            self.drawDashPhaseLine()
        }
    }
    
    // 线宽
    public var lineWidth:CGFloat = 1 {
        didSet {
            self.shapeLayer.lineWidth = lineWidth
            self.drawDashPhaseLine()
        }
    }
    
    // 动画时长
    public var duration:Double = 1 {
        didSet {
            self.animation.duration = duration
            shapeLayer.add(animation, forKey: "line")
        }
    }
    
    lazy var pan:UIPanGestureRecognizer = {
        let p = UIPanGestureRecognizer(target: self, action: #selector(panEvent(_:)))
        p.delegate = self
        return p
    }()
    
    lazy var shapeLayer:CAShapeLayer = {
        let sl = CAShapeLayer()
        sl.lineWidth = 2
        sl.strokeColor = UIColor.black.cgColor
        sl.fillColor = UIColor.blue.withAlphaComponent(0.4).cgColor
        sl.lineDashPhase = 0
        sl.lineCap = .round
        sl.lineJoin = .round
        sl.lineDashPattern = [24, 15]
        return sl
    }()
    
    lazy var animation:CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "lineDashPhase")
        
        /*
         1.虚线运动方向调换fromValue和toValue即可
           Dotted line movement direction can be exchanged fromValue and toValue
         2.
         */
        animation.toValue = shapeLayer.lineDashPattern?.reduce(0) { $0 - $1.intValue } ?? 0
        animation.fromValue = 0
        animation.duration = 0.5
        animation.repeatCount = .infinity
        return animation
    }()
    
    private var gesture:PanGesture = .mv
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.layer.masksToBounds = true
        self.layer.addSublayer(shapeLayer)
        
        // 添加动画效果
        shapeLayer.add(animation, forKey: "line")
        
        self.addGestureRecognizer(pan)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.bounds = self.bounds
        shapeLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        self.drawDashPhaseLine()
    }
    
    private func drawDashPhaseLine() {
        let margin:CGFloat = 10
        let rect = CGRect(x: margin, y: margin, width: self.bounds.width - margin * 2, height: self.bounds.height - margin * 2)
        shapeLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: self.cornerRadius).cgPath
    }
    
    
    @objc
    private func panEvent(_ sender:UIPanGestureRecognizer) {
        let offset = sender.translation(in: self)
        
        var minX = self.frame.origin.x
        var minY = self.frame.origin.y
        var maxX = minX + self.bounds.width
        var maxY = minY + self.bounds.height
        
        switch gesture {
        case .tl:
            minX = minX + offset.x
            minY = minY + offset.y
            self.frame = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
            break
        case .tr:
            maxX = maxX + offset.x
            minY = minY + offset.y
            self.frame = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
            break
        case .bl:
            
            minX = minX + offset.x
            maxY = maxY + offset.y
            self.frame = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
            break
        case .br:
            maxX = maxX + offset.x
            maxY = maxY + offset.y
            self.frame = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
            break
        case .mv:
            let centerX = self.center.x + offset.x
            let centerY = self.center.y + offset.y
            self.center = CGPoint(x: centerX, y: centerY)
            break
        }
        sender.setTranslation(.zero, in: self)
    }
}

extension LineDashPhaseView:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: self)
        
        let tl = CGRect(x: 0, y: 0, width: 40, height: 40)
        let tr = CGRect(x: self.bounds.width - 40, y: 0, width: 40, height: 40)
        let bl = CGRect(x: 0, y: self.bounds.height - 40, width: 40, height: 40)
        let br = CGRect(x: self.bounds.width - 40, y: self.bounds.height - 40, width: 40, height: 40)
        
        if tl.contains(point) {
            self.gesture = .tl
        } else if tr.contains(point) {
            self.gesture = .tr
        } else if bl.contains(point) {
            self.gesture = .bl
        } else if br.contains(point) {
            self.gesture = .br
        } else {
            self.gesture = .mv
        }
        return true
    }
}
