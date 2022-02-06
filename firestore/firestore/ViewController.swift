//
//  ViewController.swift
//  firestore
//
//  Created by Steve Vott on 2/5/22.
//

import UIKit
import SwiftUI
import Firebase
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!

    private var locationManager:CLLocationManager?
    private let deviceID = UIDevice.current.identifierForVendor!.uuidString
    private let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserLocation()
        //Iterate through collection
        db.collection("Locations")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        
                        guard let b = document.get("Longitude")! as? Double else {
                            return
                        }
                        let longitude = Double(b)
                        guard let a = document.get("Latitude")! as? Double else {
                            return
                        }
                        let latitude = Double(a)
                        
                        
                        
                        
                        print("Latitude: \(latitude)")
                        print("Document data: \(longitude)")
                        
                        
                        let location1 = CLLocationCoordinate2D(latitude: latitude,
                                                              longitude: longitude)
                        
                        
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location1
                        annotation.title = "Random"
                        self.mapView.addAnnotation(annotation)
                        

                        
                    }
                }
        }
        
    }
    


    func getUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let longitude = Double(location.coordinate.longitude)
            let latitude = Double(location.coordinate.latitude)

            let location1 = CLLocationCoordinate2D(latitude: latitude,
                                                  longitude: longitude)
            
            // 2
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location1, span: span)
            self.mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location1
            annotation.title = "You"
            self.mapView.addAnnotation(annotation)
            
            db.collection("Locations").document(deviceID).setData(["Longitude":longitude, "Latitude":latitude])
        }
    }
       
}

