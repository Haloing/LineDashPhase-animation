//
//  ViewController.swift
//  LineDashPhase-animation
//
//  Created by imh on 2023/8/3.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var dottedLineView:LineDashPhaseView = {
        let iv = LineDashPhaseView(frame: .zero)
        iv.backgroundColor = .clear
        iv.isHidden = true
        return iv
    }()
    
    lazy var imageView:UIImageView = {
        let iv = UIImageView(frame: .zero)
        iv.image = UIImage(named: "FtcCQ-kaQAAgcZ0")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var operateView:OperateView = {
        let iv = (Bundle.main.loadNibNamed("OperateView", owner: nil) as! [OperateView])[0]
        iv.frame = .zero
        iv.delegate = self
        iv.backgroundColor = .blue.withAlphaComponent(0.5)
        return iv
    }()
    
    // 起点
    private(set) var startPoint:CGPoint = .zero
    
    lazy var pan:UIPanGestureRecognizer = {
        let p = UIPanGestureRecognizer(target: self, action: #selector(panEvent(_:)))
        p.delegate = self
        return p
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(imageView)
        self.view.addGestureRecognizer(pan)
        
        self.view.addSubview(operateView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        operateView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 160)
        imageView.frame = CGRect(x: 0, y: 120, width: self.view.bounds.width, height: self.view.bounds.height - 120)
    }
    
    @objc private func panEvent(_ sender:UIPanGestureRecognizer) {
        let point = sender.location(in: self.view)
        switch sender.state {
        case .began:
            dottedLineView.isHidden = false
            self.view.addSubview(dottedLineView)
            break
        case .changed:
            var x = max(-10, point.x)
            x = min(view.bounds.width + 10, x)
            
            var y = max(-10, point.y)
            y = min(view.bounds.height + 10, y)
            dottedLineView.frame = CGRect(x: startPoint.x, y: startPoint.y, width: x - startPoint.x, height: y - startPoint.y)
            break
        default:
            break
        }
    }
}

extension ViewController:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: self.view)
        if operateView.frame.contains(point) {
            return false
        }
        self.startPoint = point
        return true
    }
}

extension ViewController:OperateViewDelegate {
    func animationDirectioSwitch(_ view: OperateView, sender: UISwitch) {
        self.dottedLineView.isClockwise = sender.isOn
    }
    
    func lineWidthChange(_ view: OperateView, sender: UISlider) {
        self.dottedLineView.lineWidth = CGFloat(sender.value * 10 + 1)
    }
    
    func cornerRadiusChange(_ view: OperateView, sender: UISlider) {
        self.dottedLineView.cornerRadius = CGFloat(sender.value * 10)
    }
    
    func durationChange(_ view: OperateView, sender: UISlider) {
        self.dottedLineView.duration = Double(5 - sender.value * 5) + 0.5
    }
}
