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
    
    // not sure how to grab the current tint from the segmented control.
    let standardBackgroundColor = UIColor.clear
	let models = ShapeManager.getInstance()
    
    var drawnShapeLayers = [CAShapeLayer]()
    
    //MARK: properties
    var startLocation : CGPoint = CGPointFromString("0")
    var layer : CAShapeLayer?
    
    // used for drawing freeform (pencil). Remember over time where last freeform point was, to draw to new freeform point.
    var lastPoint : CGPoint?
    var currentPoint : CGPoint?
    
    // if drawing with pencil, need to remember the path over time.
    var currentShape: BaseShape?
    
    var selectedFillColor : Colors = Colors.red
    var selectedTool : Tools = Tools.pencil
    
    var isShapeEndPointWithinDrawingBounds : Bool = false
    
    // MARK: outlets
    @IBOutlet weak var trashButton : UIButton!
    @IBOutlet weak var toolSelector : UISegmentedControl!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var drawArea: UIView!
    
    @IBOutlet weak var redColorButton: UIButton!
    @IBOutlet weak var yellowColorButton: UIButton!
    @IBOutlet weak var greenColorButton: UIButton!
    @IBOutlet weak var blueColorButton: UIButton!
    @IBOutlet weak var purpleColorButton: UIButton!
    
    //MARK: view methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // choose an initial tool and color. trash and undo should not be available, as no shapes yet.
        self.selectedTool = Tools .rectangle
        self.toolSelector.selectedSegmentIndex = Tools .rectangle.rawValue
        
        self.selectCurrentFillColor(blueColorButton)
        
        self.trashButton .isEnabled = false
        self.undoButton .isEnabled  = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UI methods
    
    /***
     *   Use Tool Selector tint for highlighting other controls.
     */
    func getToolSelectorTint() -> UIColor
    {
        return toolSelector.tintColor
    }
    
    /***
     *   remove all highlighting from the colour buttons
     */
    func resetColorButtonStates()
    {
        let buttons = [redColorButton, yellowColorButton, greenColorButton, blueColorButton, purpleColorButton]
        
        for button in buttons
        {
            button?.backgroundColor = standardBackgroundColor
        }
    }

    /***
     *   choose color, show user which color is currently selected.
     */
    @IBAction func selectCurrentFillColor(_ sender: UIButton)
    {
        resetColorButtonStates()
        
        let tag = sender.tag
        
        switch tag {
        case Colors .red .rawValue:
            selectedFillColor = Colors .red
            
        case Colors .yellow .rawValue:
            selectedFillColor = Colors .yellow
            
        case Colors .green .rawValue:
            selectedFillColor = Colors .green
            
        case Colors .blue .rawValue:
            selectedFillColor = Colors .blue
            
        case Colors .purple .rawValue:
            selectedFillColor = Colors .purple
            
        default:
            selectedFillColor = Colors .blue
        }
        
        sender.backgroundColor = getToolSelectorTint()
    }
    
    /***
     *   select which tool, and thus which shape, for drawing.
     */
    @IBAction func chooseTool(_ sender: UISegmentedControl) {
        switch toolSelector.selectedSegmentIndex
        {
            
        case Tools .rectangle .rawValue:
            selectedTool = Tools .rectangle
            
        case Tools .line .rawValue:
            selectedTool = Tools .line
            
        case Tools .oval .rawValue:
            selectedTool = Tools .oval
            
        case Tools .pencil .rawValue:
            selectedTool = Tools .pencil
            
        default:
            selectedTool = Tools .rectangle
        }
    }
    
    /**
     *  remove all sublayers from the drawing space.
     *  
     *  should result in blank drawing.
     */
    @IBAction func clearDrawings(_ sender: UIButton) {
        let alertView = UIAlertController(title : "Remove All Drawings", message : "Are you sure?", preferredStyle: .alert)
        
        alertView.addAction( UIAlertAction( title : "Cancel", style : .cancel, handler: nil))
        alertView.addAction( UIAlertAction( title : "Delete all", style : .destructive)
        { (action) in
            
            // remove all drawings
            for layer in self .drawnShapeLayers
            {
                layer.removeFromSuperlayer()
            }
            
            self .drawnShapeLayers .removeAll()
            
            // remove all shapes connected to drawings
            self .models .removeAll()
            
            // nothing left to undo or clear
            self .trashButton .isEnabled = false
            self .undoButton .isEnabled = false;
        })
        
        self.present(alertView, animated: true, completion: nil)
        
    }
    
    @IBAction func saveToPhotoAlbum(_ sender: UIButton) {
        let imageName = "MyDrawing " + Date().description(with : Locale.current)
        let name = imageName.replacingOccurrences(of: ":", with: "-")
        ImageUtilities .saveViewLayerToPngFile( fileName: name, view: self .view, bounds: self .view .frame, opaque: true )
    }
    
	
	/**
	 *  remove last known drawing made. 
	 */
	@IBAction func undoLastDrawing(_ sender : UIButton) {
        if models .count() > 0 && self.drawnShapeLayers .count > 0
		{
			let lastShapeIndex = models.count() - 1
			let shapeLayer = self .drawnShapeLayers [lastShapeIndex]
            
            shapeLayer.removeFromSuperlayer()
            self.drawnShapeLayers.remove(at: lastShapeIndex)
            // don't need the undone model - dereference it.
            let _ = models .removeLast()
		}
		
		if models .count() == 0 || self .drawnShapeLayers .count == 0
		{
            // nothing left to undo or clear
            self .undoButton .isEnabled = false;
            self .trashButton .isEnabled = false;
		}
	}
    
    // MARK: gesture methods
    @IBAction func handlePanGestureDrawing(_ sender: UIPanGestureRecognizer) {
        
        let location : CGPoint = sender .location(in: sender.view)
        
        // only start drawing shapes if beginning inside the drawing area.
        if sender .state == .began && drawArea .frame .contains( location )
        {
            currentShape = selectedTool .getShapeforTool( origin: location )
			models .append( shape : currentShape! )
            layer = CAShapeLayer()
            
            // models only contain the drawing shape
            layer? .fillColor = selectedFillColor.getColor()
            layer? .opacity = 0.5
            layer? .strokeColor = UIColor.black .cgColor
            
            self .view .layer .addSublayer( layer! )
            
            self .drawnShapeLayers .append( layer! )
            
            self .trashButton .isEnabled = true
			self .undoButton .isEnabled  = true
            
            // lines have no fill, so use fill as the stroke color
            switch selectedTool
            {
            case Tools .pencil:
                layer? .strokeColor = selectedFillColor .getColor()

                
            case Tools .line:
                layer? .strokeColor = selectedFillColor .getColor()
                
            default:
                break;
            }
            
            // indicate it's ok to continue drawing
            isShapeEndPointWithinDrawingBounds = true
            
        }
        
        // if start outside the drawing area, do not draw ANY shape
        else if sender .state == .began && !drawArea .frame .contains( location )
        {
            // indicate to not allow continued drawing
            self .isShapeEndPointWithinDrawingBounds = false

        }
        
        // if continuing drawing and permitted to do so
        else if sender .state == .changed && isShapeEndPointWithinDrawingBounds
        {
            let translation = sender .translation(in: sender .view)
            
            // draw the shape for the selected tool
            switch selectedTool
            {
                
            case Tools .oval:
                let correctedTranslation = DrawingUtilities
                    .correctTranslationToWithinDrawbounds( origin : currentShape! .getOrigin(), currentTranslation : translation, boundaries : drawArea .frame)
                (currentShape as! OvalShape) .setSize( width : correctedTranslation.x, height : correctedTranslation.y)
                
            case Tools .rectangle:
                let correctedTranslation = DrawingUtilities
                    .correctTranslationToWithinDrawbounds( origin : currentShape! .getOrigin(), currentTranslation : translation, boundaries : drawArea .frame)
                (currentShape as! RectangleShape) .setSize( width : correctedTranslation.x, height : correctedTranslation.y)
                
            case Tools .pencil:
                let correctedLocation = DrawingUtilities
                    .correctLocationToWithinDrawbounds(currentLocation : location, boundaries : drawArea .frame)
                (currentShape as! FreeformLineShape) .addPoint( next: correctedLocation)
                
            case Tools .line:
                let correctedLocation = DrawingUtilities
                    .correctLocationToWithinDrawbounds(currentLocation : location, boundaries : drawArea .frame)
                (currentShape as! LineShape) .setEndPoint( next: correctedLocation)
            }
            
            layer? .path = currentShape? .getShapePath() .cgPath
        }
    }
}

