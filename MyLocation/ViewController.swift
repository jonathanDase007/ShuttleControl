//
//  ViewController.swift
//  MyLocation
//
//  Created by jonathan walter dase on 12/19/21.
//

import CoreLocation
import UIKit
import MapKit
import FirebaseDatabase

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var mapview: MKMapView!
    
    //reference to realrime database
    private let database = Database.database().reference()
    var longitude = 0.0
    var latitude = 0.0
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    
    
    //Sets up the location manager
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            render(location)
        }
    }
    
    func render(_ location: CLLocation){
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span : span)
        mapview.setRegion(region, animated: true)
        
        longitude = location.coordinate.longitude
        latitude = location.coordinate.latitude
        print(longitude)
        print(latitude)
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = format.string(from: date)
        
        let object : [String: Any] = ["Bus" : longitude.description + ", " + latitude.description as NSObject, "TimeStamp" : timestamp]
        database.child("Bus").setValue(object)
        
        //builds regular pin
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapview.addAnnotation(pin)
    }
}

