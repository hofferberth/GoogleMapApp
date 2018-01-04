//
//  ViewController.swift
//  GoogleMapApp
//
//  Created by mobile consulting on 1/3/18.
//  Copyright © 2018 mobile consulting. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class ViewController: UIViewController {
    
    var nearbyPlaces: [GMSPlace] = []
    var annotations: [MKAnnotation] = []
    
    var locationManager = CLLocationManager()
    var placePicker: GMSPlacePickerViewController!
    var latitude: Double!
    var longitude: Double!
    var placesClient: GMSPlacesClient!
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient.shared()
        
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        showNearbyPlaces()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setAnnotation(place: GMSPlace, index: Int) {
        let marker = MKPointAnnotation()
        marker.coordinate = place.coordinate
        marker.title = place.name
        map.addAnnotation(marker)
        //print("Added \(place.name) at \(place.coordinate)")
        
        annotations.append(marker)
    }
    
    func showNearbyPlaces() {
        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
            if let error = error {
                // TODO: Handle the error.
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            
            // Get likely places and add to the list.
            if let likelihoodList = placeLikelihoods {
                for likelihood in likelihoodList.likelihoods {
                    let place = likelihood.place
                    self.nearbyPlaces.append(place)
                }
                
                print("-------\(self.nearbyPlaces.count)----------")
                
                for (i,e) in self.nearbyPlaces.enumerated() {
                    self.setAnnotation(place: e, index: i)
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Annotation") {
            if let i = annotations.index(where: {$0 === map.selectedAnnotations.first}) {
                let dest = segue.destination as! DetailViewController
                dest.place = nearbyPlaces[i]
            } else {
                print("ERROR: Equivalance not found")
            }
        }
    }
    
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.performSegue(withIdentifier: "Annotation", sender: nil)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location:CLLocation = locations.last!
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        
        let coordinates = CLLocationCoordinate2DMake(self.latitude, self.longitude)
        
        let span = MKCoordinateSpanMake(0.003, 0.003)
        let region =  MKCoordinateRegionMake(coordinates, span)
        map.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("An error occurred while tracking location changes : \(error)")
    }
}

/*
 The locations gathered from the api should be displayed with annotations using Map Kit, when the user clicks on the annotation it should be taken to a detail view where the user should be able to see the complete information of the place.
 */
