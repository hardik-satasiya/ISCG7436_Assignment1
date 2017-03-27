//
//  ViewController.swift
//  Assignment1
//
//  Created by Darke on 14/03/2017.
//  Copyright © 2017 Unitec. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIAlertViewDelegate {
    
    //MARK: constants
    let highlightBackgroundColor = UIColor(red:0, green:122.0/255.0, blue:1, alpha:1)
    let standardBackgroundColor = UIColor.clear
    
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
    @IBOutlet weak var trashButton : UIButton!
    @IBOutlet weak var toolSelector : UISegmentedControl!
    @IBOutlet weak var drawingArea : UIImageView!
    
    @IBOutlet weak var redColorButton: UIButton!
    @IBOutlet weak var yellowColorButton: UIButton!
    @IBOutlet weak var greenColorButton: UIButton!
    @IBOutlet weak var blueColorButton: UIButton!
    @IBOutlet weak var purpleColorButton: UIButton!
    
    //MARK: view methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        toolSelector .selectedSegmentIndex = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UI methods
    
    func resetColorButtonStates()
    {
        let buttons = [redColorButton, yellowColorButton, greenColorButton, blueColorButton, purpleColorButton]
        
        for button in buttons
        {
            button?.backgroundColor = standardBackgroundColor
        }
    }

    @IBAction func selectCurrentFillColor(_ sender: UIButton)
    {
        resetColorButtonStates()
        
        let tag = sender.tag
        
        switch tag {
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
        
        sender.backgroundColor = highlightBackgroundColor
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
        let alertView = UIAlertController(title : "Remove All Drawings", message : "Are you sure?", preferredStyle: .alert)
        
        alertView.addAction( UIAlertAction( title : "Delete all", style : .destructive)
        { (action) in
            // remove all drawings
            for layer in self.view .layer.sublayers!
            {
                if layer is CAShapeLayer
                {
                    layer.removeFromSuperlayer()
                }
            }
            
            self.trashButton.isEnabled = false
        })
        
        self.present(alertView, animated: true, completion: nil)
        
        /*
        for layer in self.view .layer.sublayers!
        {
            
            if layer is CAShapeLayer
                
            {
                layer.removeFromSuperlayer()
            }
        }
        */
        
        
    }
    
    // MARK: gesture methods
    @IBAction func handlePanGestureDrawing(_ sender: UIPanGestureRecognizer) {
        
        let location : CGPoint = sender .location(in: sender.view)
        
        // from  the current gesture location, correct it to within a drawing boundary
        func correctLocationToWithinDrawbounds( currentLocation: CGPoint, boundaries: CGRect) -> CGPoint {
            var correctedLocation : CGPoint?
            correctedLocation = currentLocation
            if !boundaries .contains( currentLocation )
            {
                if currentLocation.x > boundaries.maxX {
                    correctedLocation!.x = boundaries.maxX
                }
                else if currentLocation.x < boundaries.minX {
                    correctedLocation!.x = boundaries.minX
                }
                
                if currentLocation.y > boundaries.maxY {
                    correctedLocation!.y  = boundaries.maxY
                }
                else if currentLocation.y < boundaries.minY {
                    correctedLocation!.y = boundaries.minY
                }
            }

            return correctedLocation!
        }
        
        // from a given translation from a point, correct it to remain within a drawing boundary
        func correctTranslationToWithinDrawbounds( origin: CGPoint, currentTranslation: CGPoint, boundaries: CGRect) -> CGPoint {
            var correctedTranslation : CGPoint?
            correctedTranslation = currentTranslation
            
            if currentTranslation.x + origin.x > boundaries.maxX {
                correctedTranslation!.x = boundaries.maxX - origin.x
            }
            else if currentTranslation.x + origin.x < boundaries.minX {
                correctedTranslation!.x = boundaries.minX - origin.x
            }
                
            if currentTranslation.y + origin.y > boundaries.maxY {
                correctedTranslation!.y  = boundaries.maxY - origin.y
            }
            else if currentTranslation.y + origin.y < boundaries.minY {
                correctedTranslation!.y = boundaries.minY - origin.y
            }
            
            return correctedTranslation!
        }
        
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
                currentPath!.move(to: startLocation)
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
            let correctedLocation : CGPoint = correctLocationToWithinDrawbounds(currentLocation : location, boundaries : drawingArea .frame)
            let correctedTranslation : CGPoint = correctTranslationToWithinDrawbounds( origin : startLocation, currentTranslation: translation, boundaries: drawingArea .frame)
            
            // draw the shape for the selected tool
            switch selectedTool
            {
                
            case Tools .oval:
                currentPath = (UIBezierPath( ovalIn:
                    CGRect( x : startLocation .x, y : startLocation .y,
                            width : correctedTranslation .x, height : correctedTranslation .y )))
                
            case Tools .rectangle:
                currentPath = (UIBezierPath( rect:
                    CGRect( x : startLocation .x, y : startLocation .y,
                            width : correctedTranslation .x, height : correctedTranslation .y )))
                
            case Tools .pencil:
                currentPath!.addLine(to: correctedLocation)
                currentPath!.move(to: correctedLocation)
                
            case Tools .line:
                currentPath = UIBezierPath( )
                currentPath!.move(to: startLocation)
                currentPath!.addLine(to: correctedLocation)
            }
            
            
            layer? .path = currentPath?.cgPath
        }
    }
}

