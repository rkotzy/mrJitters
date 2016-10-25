//
//  DetailsController.swift
//  mrJitters
//
//  Created by Ryan Kotzebue on 6/7/16.
//  Copyright © 2016 Ryan Kotzebue. All rights reserved.
//

import UIKit
import MapKit

class DetailsController: UIViewController, MKMapViewDelegate {
    
    var venueName:String!
    var venueId:String!
    var location:CLLocationCoordinate2D!
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set title
        title = venueName
        
        // set directions button
        let directions = UIBarButtonItem(title: "Directions", style: .plain, target: self, action: #selector(getDirections))
        navigationItem.rightBarButtonItem = directions
        
        // set map zoom
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, 2000, 2000)
        mapView.setRegion(coordinateRegion, animated: true)
        
        // add a pin to the map
        mapView.delegate = self
        mapView.addAnnotation(CoffeePin(title: "View in Foursquare", name: venueName, foursquareId: venueId, coordinate: location))
        
    }
    
    // MARK: - Apple Maps directions
    func getDirections() {
        let loc = mapView.annotations.first as! CoffeePin
        print(loc.name)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        loc.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    // MARK: - Map Delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? CoffeePin {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let encodedAddress = ("https://www.foursquare.com/v/"+venueId).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: encodedAddress) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    

}
