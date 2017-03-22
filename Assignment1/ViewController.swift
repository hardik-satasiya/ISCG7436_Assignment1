//
//  ViewController.swift
//  Assignment1
//
//  Created by Darke on 14/03/2017.
//  Copyright © 2017 Unitec. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var startLocation: CGPoint = CGPointFromString("0")
    var layer : CAShapeLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func panGestureHandler(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began
        {
            startLocation = sender.location(in: sender.view)
            layer = CAShapeLayer()
            layer?.fillColor = UIColor.purple.cgColor
            layer?.opacity = 0.5
            layer?.strokeColor = UIColor.black.cgColor
            self.view.layer.addSublayer(layer!)
            
        }
        else if sender.state == .changed
        {
            let translation = sender.translation(in: sender.view)
            layer?.path = (UIBezierPath(ovalIn:
                CGRect(x:startLocation.x, y:startLocation.y, width:translation.x, height:translation.y)))
                .cgPath
        }
    }
}

