//
//  Pin.swift
//  mrJitters
//
//  Created by Ryan Kotzebue on 10/14/16.
//  Copyright © 2016 Ryan Kotzebue. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class CoffeePin: NSObject, MKAnnotation {
    let title: String?
    let name: String
    let foursquareId: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, name: String, foursquareId: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.name = name
        self.foursquareId = foursquareId
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return name
    }
    
    func mapItem() -> MKMapItem {
        let placemark = MKPlacemark(coordinate: coordinate)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        
        return mapItem
    }
}
