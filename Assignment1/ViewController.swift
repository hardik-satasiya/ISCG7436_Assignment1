//
//  ViewController.swift
//  Assignment1
//
//  Created by Darke on 14/03/2017.
//  Copyright © 2017 Unitec. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: properties
    var startLocation: CGPoint = CGPointFromString("0")
    var layer : CAShapeLayer?
    var selectedFillColor : Colors = Colors.red
    var selectedTool : Tools = Tools.rectangle
    
    @IBOutlet weak var colorSelector: UISegmentedControl!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var toolSelector: UISegmentedControl!
    
    //MARK: methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        colorSelector.selectedSegmentIndex = 0
        toolSelector.selectedSegmentIndex = 0
        print("ready.")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UI methods
    @IBAction func chooseColor(_ sender: UISegmentedControl) {
        switch colorSelector.selectedSegmentIndex
        {
        case Colors.red.rawValue:
            selectedFillColor = Colors.red
        case Colors.yellow.rawValue:
            selectedFillColor = Colors.yellow
        case Colors.green.rawValue:
            selectedFillColor = Colors.green
        case Colors.blue.rawValue:
            selectedFillColor = Colors.blue
        case Colors.purple.rawValue:
            selectedFillColor = Colors.purple
            
        default:
            selectedFillColor = Colors.red
        }
        
        print ("chosen color = \(selectedFillColor)")
    }
    
    @IBAction func chooseTool(_ sender: UISegmentedControl) {
        switch toolSelector.selectedSegmentIndex
        {
        case Tools.rectangle.rawValue:
            selectedTool = Tools.rectangle
        case Tools.line.rawValue:
            selectedTool = Tools.line
        case Tools.oval.rawValue:
            selectedTool = Tools.oval
        case Tools.pencil.rawValue:
            selectedTool = Tools.pencil
            
        default:
            selectedTool = Tools.oval
        }
        
        print ("chosen Tool = \(selectedTool)")
    }
    
    
    @IBAction func clearDrawings(_ sender: UIButton) {
        for layer in self.view.layer.sublayers! {
            if layer is CAShapeLayer
            {
                layer.removeFromSuperlayer()
            }
        }
        
        trashButton.isEnabled = false
    }

    // MARK: gesture methods
    @IBAction func panGestureHandler(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began
        {
            startLocation = sender.location(in: sender.view)
            layer = CAShapeLayer()
            layer?.fillColor = selectedFillColor.getColor()
            layer?.opacity = 0.5
            layer?.strokeColor = UIColor.black.cgColor
            self.view.layer.addSublayer(layer!)
            
            trashButton.isEnabled = true
            
        }
        else if sender.state == .changed
        {
            let translation = sender.translation(in: sender.view)
            
            switch selectedTool {
            case Tools.oval:
                layer?.path = (UIBezierPath(ovalIn:
                    CGRect(x:startLocation.x, y:startLocation.y, width:translation.x, height:translation.y)))
                    .cgPath
            case Tools.rectangle:
                layer?.path = (UIBezierPath(rect:
                    CGRect(x:startLocation.x, y:startLocation.y, width:translation.x, height:translation.y)))
                    .cgPath
            default:
                layer?.path = (UIBezierPath(ovalIn:
                    CGRect(x:startLocation.x, y:startLocation.y, width:translation.x, height:translation.y)))
                    .cgPath
            }
        }
    }
    
    
    
}

