//
//  MapViewController.swift
//  Places Demo
//
//  Created by Allan Pagdanganan on 03/09/2019.
//  Copyright © 2019 Allan Pagdanganan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestLocationAuthorization()
        getUserLocation()
    }
    
    // MARK: - Location Manager
    
    /**
     Request permission if your app's authorization status is not yet determined.
     
     Calling this method lets the user choose whether to grant the request for always authorization or to leave your app with when-in-use authorization.
     */
    func requestLocationAuthorization() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getUserLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let centerCoordinate = CLLocationCoordinate2D(latitude: locationValue.latitude, longitude: locationValue.longitude)
      
        mapView.showsUserLocation = true
        mapView.removeAnnotations(mapView.annotations)
        getTopPlaces(locationValue: centerCoordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to access current location")
    }
    
    // MARK: - MKMapView
    
    /**
     Request for the top places near user's location.
     
     Calling this method sends a request in the background. After getting the response in the main thread, it formats itself to show as annotations on the map.
     
     - Parameter locationValue: The location of the user in coordinates.
     - Parameter requestHelper: This has a default value of RequestHelper instance.
     */
    func getTopPlaces(locationValue: CLLocationCoordinate2D, requestHelper: RequestHelper = RequestHelper()) {
        requestHelper.getTopPlaces(nearMe: locationValue) { (topPlaces) in
            DispatchQueue.main.async {
                self.mapView.showAnnotations(self.displayAnnotations(topPlaces), animated: true)
            }
        }
    }
    
    /**
     Extract the data from topPlaces object and use it in annotation.
     
     With each loop inside the array of places, a CustomAnnotation instance is created supplying the parsed data. Each of these annotations is then added to the mapView and returned by the end of the method.
     
     - Parameter topPlaces: The items received from request.
     - Precondition: The data must be present to build the custom annotation.
     - Returns: An array of annotations to be displayed in the map.
     */
    func displayAnnotations(_ topPlaces:[Place]?) -> [MKAnnotation] {
        guard let topPlaces = topPlaces else { return [] }
        
        for place in topPlaces {
            let annotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(place.position[0]), longitude: CLLocationDegrees(place.position[1])), title: place.title, subtitle: "\(place.distance) m. away", imageUrl: place.icon)
            mapView.addAnnotation(annotation)
        }
        
        return mapView.annotations
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is CustomAnnotation else { return nil }
        let annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: "Annotation")
        annotationView.canShowCallout = true

        return annotationView
    }
}

