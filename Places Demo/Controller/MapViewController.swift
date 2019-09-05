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
    let coreDataHelper = CoreDataHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestLocationAuthorization()
        getUserLocation()
    }
    
    // MARK: - Location Manager
    
    /**
     Request permission if your app's authorization status is not yet determined.
     
     Calling this method lets the user choose whether to grant the request for always authorization or when-in-use authorization and shows an alert when location services is denied or restricted.
     */
    func requestLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            showAlert(title: "Location Services disabled", message: "Please enable Location Services in Settings.", action: "OK")
            return
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
    }
    
    func getUserLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else {
            guard let coordinates = coreDataHelper.fetchCoordinates() else { return }
            showAlert(title: "Location Services disabled", message: "Showing your last known location.", action: "OK")
            showUserLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        coreDataHelper.save(latitude: locationValue.latitude, longitude: locationValue.longitude)
        showUserLocation(latitude: locationValue.latitude, longitude: locationValue.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let coordinates = coreDataHelper.fetchCoordinates() else { return }
        showAlert(title: "Unable to access current location", message: "Showing your last known location.", action: "OK")
        showUserLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
    
    func showUserLocation(latitude: Double, longitude: Double) {
        let centerCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.showsUserLocation = true
        mapView.removeAnnotations(mapView.annotations)
        getTopPlaces(locationValue: centerCoordinate)
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

extension UIViewController {
    
    func showAlert(title: String, message: String, action: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: action, style: .default, handler: nil))
        present(alert, animated: true)
    }
}
