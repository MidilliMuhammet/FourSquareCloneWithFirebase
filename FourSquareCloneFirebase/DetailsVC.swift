//
//  DetailsVC.swift
//  FourSquareCloneFirebase
//
//  Created by Muhammet Midilli on 8.03.2021.
//

import UIKit
import MapKit
import CoreLocation
import SDWebImage


class DetailsVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var imageViewDetail: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var placeTypeLabel: UILabel!
    @IBOutlet weak var placeAtmosphereLabel: UILabel!
    @IBOutlet weak var mapViewDetail: MKMapView!
    
    //variables
    var chosenName = ""
    var chosenPlaceType = ""
    var chosenPlaceAtmosphere = ""
    var chosenImage = ""
    var chosenLatitude = 0.00
    var chosenLongitude = 0.00
    
    var locationManager = CLLocationManager()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //degations
        mapViewDetail.delegate = self
        locationManager.delegate = self
        
        //best location
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //allow to request from user
        locationManager.requestWhenInUseAuthorization()
        //update the location
        locationManager.startUpdatingLocation()
        
        nameLabel.text = chosenName
        placeTypeLabel.text = chosenPlaceType
        placeAtmosphereLabel.text = chosenPlaceAtmosphere
        imageViewDetail.sd_setImage(with: URL(string : self.chosenImage))
        
        //create pin
        let annotation = MKPointAnnotation()
        annotation.title = chosenName
        annotation.subtitle = chosenPlaceType
        //adding coordinate information to pin
        let coordinate = CLLocationCoordinate2D(latitude: chosenLatitude, longitude: chosenLongitude)
        annotation.coordinate = coordinate
        mapViewDetail.addAnnotation(annotation)
        
        
        
        

        
    }
    
    //update location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //define location
        let location = CLLocationCoordinate2D(latitude: chosenLatitude, longitude: chosenLongitude)
        //zoom level
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        //centre of map
        let region = MKCoordinateRegion(center: location, span: span)
        //setting region
        mapViewDetail.setRegion(region, animated: true)
    }
    
    //customize pin
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //do not show any pin on user location
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "myAnnotation"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.tintColor = UIColor.blue
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    //after tap pin button, search callout
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let requestLocation = CLLocation(latitude: chosenLatitude, longitude: chosenLongitude)
        //clousre
        CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
            if let placemark = placemarks {
                if placemark.count > 0 {
                    let newPlaceMark = MKPlacemark(placemark: placemark[0])
                    let item = MKMapItem(placemark: newPlaceMark)
                    item.name = self.chosenName
                    let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                    item.openInMaps(launchOptions: launchOptions)
                }
            }
        }
    }
    

    

}
