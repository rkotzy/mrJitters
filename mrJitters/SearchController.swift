//
//  SearchController.swift
//  mrJitters
//
//  Created by Ryan Kotzebue on 6/7/16.
//  Copyright © 2016 Ryan Kotzebue. All rights reserved.
//

import UIKit
import CoreLocation

let client_id = "CLIENT_ID" // visit developer.foursqure.com for API key
let client_secret = "CLIENT_SECRET" // visit developer.foursqure.com for API key

class SearchController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var searchResults = [JSON]()
    var currentLocation:CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set nav bar title
        title = "☕️"
        
        // show annimation views
        currentLocationLabel.text = ""
        currentLocationLabel.isHidden = true
        tableView.isHidden = true
        
        // set delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        // snap to current location
        snapToPlace()
        
        // search for coffee nearby
        searchForCoffee()
    }
    
    // MARK: - venues/search endpoint
    // https://developer.foursquare.com/docs/venues/search
    func snapToPlace() {
        let url = "https://api.foursquare.com/v2/venues/search?ll=\(currentLocation.latitude),\(currentLocation.longitude)&v=20160607&intent=checkin&limit=1&radius=4000&client_id=\(client_id)&client_secret=\(client_secret)"
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, err -> Void in
            
            var currentVenueName:String?
            
            let json = JSON(data: data!)
            currentVenueName = json["response"]["venues"][0]["name"].string
            
            // set label name and visible
            DispatchQueue.main.async {
                if let v = currentVenueName {
                    self.currentLocationLabel.text = "You're at \(v). Here's some ☕️ nearby."
                }
                self.currentLocationLabel.isHidden = false
            }
        })
        
        task.resume()
    }
    
    // MARK: - search/recommendations endpoint
    // https://developer.foursquare.com/docs/search/recommendations
    func searchForCoffee() {
        let url = "https://api.foursquare.com/v2/search/recommendations?ll=\(currentLocation.latitude),\(currentLocation.longitude)&v=20160607&intent=coffee&limit=15&client_id=\(client_id)&client_secret=\(client_secret)"
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, err -> Void in
            
            let json = JSON(data: data!)
            self.searchResults = json["response"]["group"]["results"].arrayValue
                        
            DispatchQueue.main.async {
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        })
        
        task.resume()
    }
    
    // MARK: - TableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Set up the SearchCells with data from the searchResults array
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SearchCell
    
        cell.title.text = searchResults[(indexPath as NSIndexPath).row]["venue"]["name"].string
        cell.rating.text = String(format: "%.1f", searchResults[(indexPath as NSIndexPath).row]["venue"]["rating"].doubleValue) + "⭐️"
        cell.distance.text = "\(searchResults[(indexPath as NSIndexPath).row]["venue"]["location"]["distance"].intValue)m"
        cell.address.text = searchResults[(indexPath as NSIndexPath).row]["venue"]["location"]["address"].string
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // show the DetailController
        performSegue(withIdentifier: "details", sender: self)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // check if segue is to the DetailsController
        if segue.identifier == "details" {
            
            let vc = segue.destination as! DetailsController
            let selectedCell = tableView.indexPathForSelectedRow!
            
            // Set the title on the details controller and deselect tableview cell
            vc.venueName = searchResults[(selectedCell as NSIndexPath).row]["venue"]["name"].string
            let lat = searchResults[(selectedCell as NSIndexPath).row]["venue"]["location"]["lat"].doubleValue
            let lng = searchResults[(selectedCell as NSIndexPath).row]["venue"]["location"]["lng"].doubleValue
            vc.location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            vc.venueId = searchResults[(selectedCell as NSIndexPath).row]["venue"]["id"].stringValue
            
            tableView.deselectRow(at: selectedCell, animated: false)
        }
    }
}
