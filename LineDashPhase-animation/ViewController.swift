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
        self.view.addGestureRecognizer(pan)
        
        print(self)
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
        self.startPoint = point
        return true
    }
}
