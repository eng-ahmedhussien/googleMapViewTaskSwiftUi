//
//  LocationMangerVM.swift
//  AlDwaaNewApp
//
//  Created by ahmed hussien on 21/06/2023.
//

import SwiftUI
import GoogleMaps
import CoreLocation
import MapKit

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()///delivering location data to the app
    private let geocoder = CLGeocoder() ///convert a geographic coordinate into a human-readable address
    @Published var currentLocation: CLLocation?
    @Published var currentAddress: String = ""

    var mapView: GMSMapView?
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }

    //get a human-readable address from a given location
    func getAddressFromLocation(from location: CLLocation) {
           geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
               guard let self = self, let placemark = placemarks?.first else {
                   self?.currentAddress = "Address not found"
                   return
               }
               self.currentAddress = self.formatAddress(from: placemark)
           }
       }

    //format an address from a given CLPlacemark object
    private func formatAddress(from placemark: CLPlacemark)->String{
            var addressComponents: [String] = []
            
            if let name = placemark.name{
                addressComponents.append(name)}
            if let subLocality = placemark.subLocality {
                addressComponents.append(subLocality)}
            if let locality = placemark.locality {
                addressComponents.append(locality)}
            if let administrativeArea = placemark.administrativeArea {
                addressComponents.append(administrativeArea)}
            if let postalCode = placemark.postalCode {
                addressComponents.append(postalCode)}
            if let country = placemark.country {
                addressComponents.append(country)}
            
            return addressComponents.joined(separator: ", ")
        }
    
    
    //move camera to the user current location when the "My Location" button is pressed
    func pressedMylocationButton() {
        guard let location = locationManager.location?.coordinate,let mapView = mapView else {
            print("Error: My location is not available.")
            return
        }
        let zoomLevel: Float = 15.0
        let camera = GMSCameraPosition.camera(withTarget: location, zoom: zoomLevel)
        mapView.animate(to: camera)
    }
    
    //move camera to the selected location from a list of places
    func moveToLoactionFormPlaces(){
        guard let location = currentLocation,let mapView = mapView else {
            print("Error: Current location is not available.")
            return
        }
        let zoomLevel: Float = 12.0
        let loc = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let camera = GMSCameraPosition.camera(withTarget: loc, zoom: zoomLevel)
        mapView.animate(to: camera)
    }

}
