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
    var startLocation : CGPoint = CGPointFromString("0")
    var layer : CAShapeLayer?
    var selectedFillColor : Colors = Colors .red
    var selectedTool : Tools = Tools .rectangle
    
    var isDrawingAllowed : Bool = false
    
    @IBOutlet weak var colorSelector : UISegmentedControl!
    @IBOutlet weak var trashButton : UIButton!
    @IBOutlet weak var toolSelector : UISegmentedControl!
    @IBOutlet weak var drawingArea : UIImageView!
    
    
    //MARK: methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        colorSelector .selectedSegmentIndex = 0
        toolSelector .selectedSegmentIndex = 0
        
        drawingArea.layer.borderColor = UIColor.black.cgColor
        
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
            
        case Colors .red.rawValue:
            selectedFillColor = Colors .red
            
        case Colors .yellow.rawValue:
            selectedFillColor = Colors .yellow
            
        case Colors .green.rawValue:
            selectedFillColor = Colors .green
            
        case Colors .blue.rawValue:
            selectedFillColor = Colors .blue
            
        case Colors .purple.rawValue:
            selectedFillColor = Colors .purple
            
        default:
            selectedFillColor = Colors .red
            
        }
        
        print ("chosen color = \(selectedFillColor)")
    }
    
    @IBAction func chooseTool(_ sender: UISegmentedControl) {
        switch toolSelector.selectedSegmentIndex
        {
            
        case Tools .rectangle.rawValue:
            selectedTool = Tools .rectangle
            
        case Tools .line.rawValue:
            selectedTool = Tools .line
            
        case Tools .oval.rawValue:
            selectedTool = Tools .oval
            
        case Tools .pencil.rawValue:
            selectedTool = Tools .pencil
            
        default:
            selectedTool = Tools .oval
            
        }
        
        print ("chosen Tool = \(selectedTool)")
    }
    
    
    @IBAction func clearDrawings(_ sender: UIButton) {
        for layer in self.view .layer.sublayers!
        {
            
            if layer is CAShapeLayer
                
            {
                layer.removeFromSuperlayer()
            }
        }
        
        trashButton.isEnabled = false
    }
    
    // MARK: gesture methods
    @IBAction func handlePanGestureDrawing(_ sender: UIPanGestureRecognizer) {
        
        let location : CGPoint = sender .location(in: sender.view)
        
        var lastPoint : CGPoint?
        var currentPoint : CGPoint?
        
        print ("within drawing area = \( drawingArea.frame.contains( location ))")
        
        // only start drawing shapes if beginning inside the drawing area.
        if sender .state == .began && drawingArea.frame .contains( location )
        {
            
            startLocation = location
            layer = CAShapeLayer()
            
            layer? .fillColor = selectedFillColor.getColor()
            layer? .opacity = 0.5
            layer? .strokeColor = UIColor.black .cgColor
            
            self.view .layer.addSublayer( layer! )
            
            trashButton .isEnabled = true
            
            // indicate it's ok to continue drawing
            isDrawingAllowed = true
            
        }
        
        // if start outside the drawing area, do not draw ANY shape
        else if sender .state == .began && !drawingArea.frame .contains( location )
        {
            // indicate to not allow continued drawing
            isDrawingAllowed = false

        }
        
        // if continuing drawing and permitted to do so
        else if sender .state == .changed && isDrawingAllowed
        {
            let translation = sender.translation(in: sender.view)
            var translationCorrected : CGPoint = translation
            
            //TODO: fix this
            // if pan is outside the draw Area, only draw to the draw Area bounds
            if !drawingArea.frame .contains( location )
            {
                if translation.x > drawingArea.frame.maxX {
                    translationCorrected.x = drawingArea.frame.maxX
                }
                else if translation.x < drawingArea.frame.minX {
                    translationCorrected.x = drawingArea.frame.minX
                }
                
                if translation.y > drawingArea.frame.maxY {
                    translationCorrected.y = drawingArea.frame.maxY
                }
                else if translation.y < drawingArea.frame.minY {
                    translationCorrected.y = drawingArea.frame.minY
                }
            }
            
            print("translation = \(translation), maxX = \(drawingArea.frame.maxX), maxY = \(drawingArea.frame.maxY), minX = \(drawingArea.frame.minX), minY = \(drawingArea.frame.minY)")
            
            switch selectedTool
            {
                
            case Tools .oval:
                layer? .path = (UIBezierPath( ovalIn:
                    CGRect( x : startLocation .x, y : startLocation .y,
                            width : translationCorrected .x, height : translationCorrected .y )))
                    .cgPath
                
            case Tools .rectangle:
                layer? .path = (UIBezierPath( rect:
                    CGRect( x : startLocation .x, y : startLocation .y,
                            width : translationCorrected .x, height : translationCorrected .y )))
                    .cgPath
                
            case Tools .pencil:
                layer? .path = (UIBezierPath( rect:
                    CGRect( x : startLocation .x, y : startLocation .y,
                            width : translationCorrected .x, height : translationCorrected .y )))
                    .cgPath
                
            case Tools .line:
                layer? .path = (UIBezierPath( rect:
                    CGRect( x : startLocation .x, y : startLocation .y,
                            width : translationCorrected .x, height : translationCorrected .y )))
                    .cgPath
                
            default:
                layer? .path = (UIBezierPath( ovalIn:
                    CGRect( x : startLocation .x, y : startLocation .y,
                            width : translationCorrected .x, height : translationCorrected .y )))
                    .cgPath
                
            }
        }
    }
}

