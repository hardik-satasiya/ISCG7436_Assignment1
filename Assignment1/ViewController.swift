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
    
    // used for drawing freeform (pencil). Remember over time where last freeform point was, to draw to new freeform point.
    var lastPoint : CGPoint?
    var currentPoint : CGPoint?
    
    // if drawing with pencil, need to remember the path over time.
    var currentPath : UIBezierPath?
    
    var selectedFillColor : Colors = Colors .red
    var selectedTool : Tools = Tools .pencil
    
    var isShapeEndPointWithinDrawingBounds : Bool = false
    
    // MARK: outlets
    @IBOutlet weak var colorSelector : UISegmentedControl!
    @IBOutlet weak var trashButton : UIButton!
    @IBOutlet weak var toolSelector : UISegmentedControl!
    @IBOutlet weak var drawingArea : UIImageView!
    
    
    //MARK: view methods
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
    
    /***
     *   select the colour to fill shapes with
     */
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
    }
    
    /***
     *   select which tool, and thus which shape, for drawing.
     */
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
    }
    
    /**
     *  remove all sublayers from the drawing space.
     *  
     *  should result in blank drawing.
     */
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
            
            switch selectedTool
            {
            case Tools .pencil:
                currentPath = UIBezierPath( )
                lastPoint = startLocation
                currentPath!.move(to: lastPoint!)
                layer? .strokeColor = selectedFillColor .getColor()

                
            // otherwise line will always be black
            case Tools .line:
                layer? .strokeColor = selectedFillColor .getColor()
                
            default:
                break;

            }
            
            // indicate it's ok to continue drawing
            isShapeEndPointWithinDrawingBounds = true
            
        }
        
        // if start outside the drawing area, do not draw ANY shape
        else if sender .state == .began && !drawingArea.frame .contains( location )
        {
            // indicate to not allow continued drawing
            isShapeEndPointWithinDrawingBounds = false

        }
        
        // if continuing drawing and permitted to do so
        else if sender .state == .changed && isShapeEndPointWithinDrawingBounds
        {
            let translation = sender.translation(in: sender.view)
            var translationCorrected : CGPoint = translation
            
            // only draw to the draw Area bounds, but keep drawing the shape
            if !drawingArea.frame .contains( location )
            {
                if translation.x + startLocation.x > drawingArea.frame.maxX {
                    translationCorrected.x = drawingArea.frame.maxX - startLocation.x
                }
                else if translation.x + startLocation.x < drawingArea.frame.minX {
                    translationCorrected.x = drawingArea.frame.minX - startLocation.x
                }
                
                if translation.y + startLocation.y > drawingArea.frame.maxY {
                    translationCorrected.y  = drawingArea.frame.maxY - startLocation.y
                }
                else if translation.y + startLocation.y < drawingArea.frame.minY {
                    translationCorrected.y = drawingArea.frame.minY - startLocation.y
                }
            }
            
            // draw the shape for the selected tool
            switch selectedTool
            {
                
            case Tools .oval:
                currentPath = (UIBezierPath( ovalIn:
                    CGRect( x : startLocation .x, y : startLocation .y,
                            width : translationCorrected .x, height : translationCorrected .y )))
                
            case Tools .rectangle:
                currentPath = (UIBezierPath( rect:
                    CGRect( x : startLocation .x, y : startLocation .y,
                            width : translationCorrected .x, height : translationCorrected .y )))
                
            case Tools .pencil:
                var correctedLocation : CGPoint?
                correctedLocation = location
                if !drawingArea.frame .contains( location )
                {
                    if location.x > drawingArea.frame.maxX {
                        correctedLocation!.x = drawingArea.frame.maxX
                    }
                    else if location.x < drawingArea.frame.minX {
                        correctedLocation!.x = drawingArea.frame.minX
                    }
                    
                    if location.y > drawingArea.frame.maxY {
                        correctedLocation!.y  = drawingArea.frame.maxY
                    }
                    else if location.y < drawingArea.frame.minY {
                        correctedLocation!.y = drawingArea.frame.minY
                    }
                }
                var currentPoint : CGPoint = correctedLocation!
                
                currentPath!.addLine(to: currentPoint)
                lastPoint = currentPoint
                currentPath!.move(to: lastPoint!)
                
            case Tools .line:
                currentPath = UIBezierPath( )
                currentPath!.move(to: startLocation)
                currentPath!.addLine(to: CGPoint( x : startLocation.x + translationCorrected.x,
                                                  y : startLocation.y + translationCorrected.y ))
            }
            
            
            layer? .path = currentPath?.cgPath
        }
    }
}

