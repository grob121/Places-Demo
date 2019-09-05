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
    
    /**
     Define location manager settings or fetch from the stored location data to display the location of the user.
     
     Location manager set delegate, desired accuracy attribute and starts updating location if the location services is enabled. If the location services is found to be disabled, it tries to fetch saved location from Core Data and displays it as last known location of the user.
     */
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
        
        // Show user's current location and save it in Core Data
        coreDataHelper.save(latitude: locationValue.latitude, longitude: locationValue.longitude)
        showUserLocation(latitude: locationValue.latitude, longitude: locationValue.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let coordinates = coreDataHelper.fetchCoordinates() else { return }
        
        // If the location manager fails to access user's current location, it tries to fetch saved location from Core Data and displays it as last known location.
        showAlert(title: "Unable to access current location", message: "Showing your last known location.", action: "OK")
        showUserLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
    
    /**
     Display the location of the user in map by a blue round marker. It also removes annotation to clear the map for the new top places to be plotted.
     
     This custom function shows the user location provided by the other functions, clears the map annotations and feeds the location coordinate to the method that extracts the top places around its location.
     
     - Parameter latitude: The latitude coordinate of user.
     - Parameter longitude: The longitude coordinate of user.
     */
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
        
        // Creates an instance of CustomAnnotationView to format annotations and display it on the map
        let annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: "Annotation")
        annotationView.canShowCallout = true

        return annotationView
    }
    
    // MARK: - UIAlertView
    
    /**
     This method acts like a helper to show an alert with a single default action.
     
     UIAlertController is initialized with the parameters and then presented to the view.
     
     - Parameter title: The title of the UIAlertController instance.
     - Parameter message: The message of the UIAlertController instance.
     - Parameter action: The title of action of the UIAlertController instance.
     */
    func showAlert(title: String, message: String, action: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: action, style: .default, handler: nil))
        present(alert, animated: true)
    }
}
