//
//  GGetUserLocationViewController.swift
//  LifeStone
//
//  Created by Wajih on 29/06/2020.
//  Copyright © 2020 Invotyx. All rights reserved.
//
//var addressStr  = ""
//var lat = ""
//var long = ""

import UIKit
import GooglePlaces
import GoogleMaps
import CoreLocation

class GGetUserLocationViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate  {

    let locationManager = CLLocationManager()
    var flgfirst = false
    @IBOutlet weak var mapView: GMSMapView!
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var placesClient = GMSPlacesClient?.self
    var vc = AddEventViewController()
    var showvc = false
  override func viewDidLoad() {
        
//    locationManager.requestAlwaysAuthorization()
        Pickgpsstr = ""
        Picklat = ""
        Picklong = ""
        getCurrentLocation()
       resultsViewController = GMSAutocompleteResultsViewController()
       resultsViewController?.delegate = self

       searchController = UISearchController(searchResultsController: resultsViewController)
       searchController?.searchResultsUpdater = resultsViewController

       // Put the search bar in the navigation bar.
       searchController?.searchBar.sizeToFit()
       navigationItem.titleView = searchController?.searchBar

       // When UISearchController presents the results view, present it in
       // this view controller, not one further up the chain.124
    
       definesPresentationContext = true

       // Prevent the navigation bar from being hidden when searching.
       searchController?.hidesNavigationBarDuringPresentation = false
    
    self.mapView.isMyLocationEnabled = true
    
  }
    func getCurrentLocation(){
//        placesClient = GMSPlacesClient.shared()
        locationManager.requestAlwaysAuthorization()
           if CLLocationManager.locationServicesEnabled(){
              locationManager.delegate = self
              locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
              locationManager.distanceFilter = 500
              locationManager.requestWhenInUseAuthorization()
              locationManager.requestAlwaysAuthorization()
              locationManager.startUpdatingLocation()
        }
          mapView.settings.myLocationButton = true
          mapView.settings.zoomGestures = true
          mapView.animate(toViewingAngle: 45)
          mapView.delegate = self
    }
    
    func dropPinZoomIn(placemark:CLLocationCoordinate2D,title:String,snippet:String){
        mapView.clear()
        let position = CLLocationCoordinate2DMake(placemark.latitude,placemark.longitude)
        let marker = GMSMarker(position: position)
        let camera = GMSCameraPosition.camera(withLatitude: placemark.latitude, longitude: placemark.longitude, zoom: 15.0)
        mapView.animate(to: camera)
        marker.title = title
        marker.snippet = snippet
        marker.map = mapView
        Pickgpsstr = snippet
        Picklat = "\(placemark.latitude)"
        Picklong = "\(placemark.longitude)"
        if showvc == true
        {
            vc.btnlocation.setTitle("\(Pickgpsstr)", for: .normal)
        }
//        addressStr = snippet
//        lat = "\(placemark.latitude)"
//        long = "\(placemark.longitude)"
        self.dismiss(animated: true, completion: nil)
     }
    func didTapMyLocationButton(for mmapView: GMSMapView) -> Bool{

        getCurrentAddresss(loc: CLLocationCoordinate2D(latitude: (mmapView.myLocation?.coordinate.latitude)!, longitude: (mmapView.myLocation?.coordinate.longitude)!))
        mapView.camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: (mmapView.myLocation?.coordinate.latitude)!, longitude: (mmapView.myLocation?.coordinate.longitude)!), zoom: 15)
        return true
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         let newLocation = locations.last // find your device location
         mapView.camera = GMSCameraPosition.camera(withTarget: newLocation!.coordinate, zoom: 14.0) // show your device location on map
         mapView.settings.myLocationButton = true // show current location button
        let lat = (newLocation?.coordinate.latitude)! // get current location latitude
        let long = (newLocation?.coordinate.longitude)! //get current location longitude
       
        getCurrentAddresss(loc: CLLocationCoordinate2D(latitude: lat, longitude: long))
//        print(lat)
//        print(long)
    }
    
    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if toLocation != nil {
            mapView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 15)
        }
    }
 
    func getCurrentAddresss(loc:CLLocationCoordinate2D)
    {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(loc) { response, error in
          //
        if error != nil {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    } else {
                        if let places = response?.results() {
                            if let place = places.first {


                                if let lines = place.lines {
                                    print("GEOCODE: Formatted Address: \(lines)")
                                    Pickgpsstr = "\(lines)"
                                    Picklat = "\(loc.latitude)"
                                    Picklong = "\(loc.longitude)"
//                                    addressStr = "\(lines)"
//                                    lat = "\(loc.latitude)"
//                                    long = "\(loc.longitude)"
                                    if self.showvc == true
                                    {
                                        self.vc.btnlocation.setTitle("\(Pickgpsstr)", for: .normal)
                                    }
                                    if self.flgfirst{
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                    self.flgfirst = true
                                }

                            } else {
                                print("GEOCODE: nil first in places")
                            }
                        } else {
                            print("GEOCODE: nil in places")
                        }
                    }
        }
    }

}


// Handle the user's selection.
extension GGetUserLocationViewController: GMSAutocompleteResultsViewControllerDelegate {
  func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                         didAutocompleteWith place: GMSPlace) {
    searchController?.isActive = false
    // Do something with the selected place.
//    print("Place name: \(place.name)")
//    print("Place address: \(place.formattedAddress)")
//    print("Place attributions: \(place.attributions)")
    dropPinZoomIn(placemark: place.coordinate, title: place.name ?? "", snippet: place.formattedAddress ?? "")
  }

  func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                         didFailAutocompleteWithError error: Error){
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
}

extension GGetUserLocationViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    print("Place name: \(place.name)")
//    print("Place ID: \(place.placeID)")
//    print("Place attributions: \(place.attributions)")
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

}
