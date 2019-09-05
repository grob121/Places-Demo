//
//  Places_DemoTests.swift
//  Places DemoTests
//
//  Created by Allan Pagdanganan on 03/09/2019.
//  Copyright © 2019 Allan Pagdanganan. All rights reserved.
//

import XCTest
import UIKit
import MapKit
@testable import Places_Demo

protocol LocationManager {
    
    // CLLocationManager Properties
    var location: CLLocation? { get }
    var delegate: CLLocationManagerDelegate? { get set }
}

extension CLLocationManager: LocationManager {
    func getAuthorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    func isLocationServicesEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
}

class MockLocationManager: LocationManager {
    var location: CLLocation?
    var delegate: CLLocationManagerDelegate?
    
    func getAuthorizationStatus() -> CLAuthorizationStatus {
        return .authorizedWhenInUse
    }
    
    func isLocationServicesEnabled() -> Bool {
        return true
    }
}

class Places_DemoTests: XCTestCase {
    
    //declaring the ViewController under test as an implicitly unwrapped optional
    var mapViewController : MapViewController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        //get the storyboard the ViewController under test is inside
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        //get the ViewController we want to test from the storyboard (note the identifier is the id explicitly set in the identity inspector)
        mapViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController
        
        //load view hierarchy
        if(mapViewController != nil) {
            mapViewController.loadView()
            mapViewController.viewDidLoad()
        }
    }
    
    func testViewControllerIsComposedOfMapView() {
        XCTAssertNotNil(mapViewController.mapView, "ViewController under test is not composed of a MKMapView")
    }
    
    func testControllerConformsToMKMapViewDelegate() {
        XCTAssert(mapViewController.conforms(to: MKMapViewDelegate.self), "ViewController under test does not conform to MKMapViewDelegate protocol")
    }
    
    func testMapViewDelegateIsSet() {
        XCTAssertNotNil(mapViewController.mapView.delegate)
    }
    
    func testControllerImplementsMKMapViewDelegateMethods() {
        XCTAssert(mapViewController.responds(to: #selector(MapViewController.mapView(_:viewFor:))), "ViewController under test does not implement mapView:viewForAnnotation")
    }
    
    func testMapInitialization() {
        XCTAssert(mapViewController.mapView.mapType == MKMapType.standard)
    }
    
    func testLocationManagerIsSet(){
        XCTAssertNotNil(mapViewController.locationManager)
    }
    
    func testLocationManagerDelegateIsSet(){
        XCTAssertNotNil(mapViewController.locationManager.delegate)
    }
    
//    func testControllerAddsAnnotationsToMapView() {
//        let annotationsOnMap = mapViewController.mapView.annotations
//        XCTAssertGreaterThan(annotationsOnMap.count, 0)
//    }
//
//    func testControllerCanAddCustomAnnotationToMapView() {
//        let mapHasCustomAnnotation = self.hasTargetAnnotation(annotationClass: CustomAnnotation.self)
//        XCTAssertTrue(mapHasCustomAnnotation)
//    }
//
//    func hasTargetAnnotation(annotationClass: MKAnnotation.Type) -> Bool {
//        let mapAnnotations = mapViewController.mapView.annotations
//        var hasTargetAnnotation = false
//        for annotation in mapAnnotations {
//            if (annotation.isKind(of: annotationClass)) {
//                hasTargetAnnotation = true
//            }
//        }
//        return hasTargetAnnotation
//    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
