//
//  Utils.swift
//  Assignment1
//
//  Created by Roland Askew on 3/28/17.
//  Copyright © 2017 Unitec. All rights reserved.
//
//  Utility classes holding very common actions.
//
//

import Foundation
import UIKit

class DrawingUtilities {

    // move a location to within a drawing boundary.
    static func correctLocationToWithinDrawbounds( currentLocation: CGPoint, boundaries: CGRect) -> CGPoint {
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
    static func correctTranslationToWithinDrawbounds( origin: CGPoint, currentTranslation: CGPoint, boundaries: CGRect) -> CGPoint {
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

}

class ImageUtilities {
    
    // convert picture data to a PNG file and save in the documents folder.
    static func saveViewLayerToPngFileInDocumentsFolder( fileName : String, view : UIView, bounds : CGRect, opaque : Bool )
    {
        UIGraphicsBeginImageContextWithOptions(bounds.size, opaque, 0.0)
        view.drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        let data = UIImagePNGRepresentation(image!)
        
        do {
            // saving to documents - proper photo album save requires permissions setup and using PH classes, investigated but found too complex for remaining time and issues accessing PH classes (required import not available?)
            let documentsURL = try FileManager .default .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentsURL .appendingPathComponent( fileName + ".png" )
            print("fileURL=\(fileURL)")
            
            try data! .write ( to: fileURL, options: .atomicWrite )
        } catch {
            print(error)
        }
    }
}
