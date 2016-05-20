//
//  MapViewController.swift
//  ass3
//
//  Created by Matthew Saliba on 20/05/2016.
//  Copyright © 2016 Matthew Saliba. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var mapLat : Double?
    var mapLong : Double?
    
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var satelliteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
       satelliteButton.alpha = 0
       self.mapView.removeAnnotations(mapView.annotations)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let satelliteController = segue.destinationViewController as! SatelliteViewController
        
        satelliteController.latitude = self.mapLat
        satelliteController.longittude = self.mapLong
    }

    // add pin via long gesture
    @IBAction func addPin(sender: UILongPressGestureRecognizer) {
        
        sender.minimumPressDuration = 0.4
        
        
        let location = sender.locationInView(self.mapView)
        let locCoord = self.mapView.convertPoint(location, toCoordinateFromView: self.mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locCoord
        annotation.title = "Lat: \(locCoord.latitude)"
        annotation.subtitle = "Lon: \(locCoord.longitude)"
        
        if sender.state == UIGestureRecognizerState.Ended {
            UIButton.animateWithDuration(0.5,animations: { self.satelliteButton.alpha = 1.0 })
            
            self.mapLat = locCoord.latitude
            self.mapLong = locCoord.longitude
        }
        
        // adds one pin only
        self.mapView.removeAnnotations(mapView.annotations)
        
        self.mapView.addAnnotation(annotation)
        
    }
}
