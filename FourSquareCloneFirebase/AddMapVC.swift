//
//  AddMapVC.swift
//  FourSquareCloneFirebase
//
//  Created by Muhammet Midilli on 8.03.2021.
//

import UIKit
import MapKit
import Firebase
import CoreLocation



class AddMapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapViewAdd: MKMapView!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    
    //variables
    var name = ""
    var placeType = ""
    var placeAtmosphere = ""
    var image = UIImage()
    var annotationLatitude = Double()
    var annotationLongitude = Double()
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegation
        mapViewAdd.delegate = self
        locationManager.delegate = self
        //correctless
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //to request from user
        locationManager.requestWhenInUseAuthorization()
        //to update location
        locationManager.startUpdatingLocation()
        
        //enable to add pin when long press
        let gestureRecognizerMap = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizerMap:)))
        gestureRecognizerMap.minimumPressDuration = 1.5 //sec
        mapViewAdd.addGestureRecognizer(gestureRecognizerMap)
        
        
        
    }
    
   
    
    
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        
    }
    //for gestureRecognizer
    @objc func chooseLocation(gestureRecognizerMap: UILongPressGestureRecognizer) {
        //if user press long
        if gestureRecognizerMap.state == .began {
            //touch point
            let touchPoint = gestureRecognizerMap.location(in: mapViewAdd)
            //convert point to coordinates
            let touchCoordinates = self.mapViewAdd.convert(touchPoint, toCoordinateFrom: self.mapViewAdd)
                //add to varibles
            chosenLatitude = touchCoordinates.latitude
            chosenLongitude = touchCoordinates.longitude
                //for pin
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchCoordinates
            annotation.title = name
            annotation.subtitle = placeType
            //adding pin
            self.mapViewAdd.addAnnotation(annotation)
        }
    }
    
    //customize pin, search "viewforannotation"
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //do not show any pin on user location
        if annotation is MKUserLocation {
            return nil
        }
        let reuseID = "myAnnotation"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            //create to enable to add button in pin
            pinView?.canShowCallout = true
            //change the pin info color
            pinView?.tintColor = UIColor.blue
            //create a button in the pin
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    //after tap pin button, search callout to map
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if name != "" {
            let requestLocation = CLLocation(latitude: annotationLatitude, longitude: annotationLongitude)
            //closure
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let newPlaceMark = MKPlacemark(placemark: placemark[0])
                        let item = MKMapItem(placemark: newPlaceMark)
                        item.name = self.name
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                        item.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }
    
    //update locations given as an array, search "didupdatelocation"
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if name == "" {
            let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
            //zoom level
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            //centre of map
            let region = MKCoordinateRegion(center: location, span: span)
            //setting region
            mapViewAdd.setRegion(region, animated: true)
        }
    }
    
    
    
    
    

}
