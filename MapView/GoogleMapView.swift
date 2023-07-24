//
//  MapViewRepresentable.swift
//  AlDwaaNewApp
//
//  Created by ahmed hussien on 21/06/2023.
//

import Foundation
import SwiftUI
import GoogleMaps
import GooglePlaces


struct  GoogleMapView : UIViewRepresentable{
    @ObservedObject var viewModel: LocationViewModel
    
    func makeUIView(context: Context) -> GMSMapView {
        guard let location = viewModel.locationManager.location?.coordinate else { return GMSMapView()}
        let camera = GMSCameraPosition.camera(withTarget:location, zoom: 15.0)
        
        let mapView = GMSMapView(frame:.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = false
        mapView.delegate = context.coordinator
        
        context.coordinator.addMarker(to: mapView)
        viewModel.mapView = mapView
        return mapView

    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {}
    //MARK: - Coordinator
    
    //creates an instance of the Coordinator class, which serves as the delegate for the map view events
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        let viewModel: LocationViewModel
        var marker: GMSMarker?

        init(viewModel: LocationViewModel) {
            self.viewModel = viewModel
        }
        
        //add a marker to the map at the user's current location
        func addMarker(to mapView: GMSMapView){
            guard let location = viewModel.locationManager.location?.coordinate else {return}
            mapView.animate(toLocation: location)
            
            let marker = GMSMarker()
            marker.iconView = UIImageView(image: UIImage(named: "location_marker"))
            marker.iconView?.frame = CGRect(x: 0, y: 0, width: 40, height: 50)
            marker.position = mapView.camera.target
            marker.map = mapView
            self.marker = marker
        }
        
        // move the marker's position when  camera position changes
        func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
            marker?.position = mapView.camera.target
        }
        
        //update current location, address when camera position stops changing
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            let location = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
            viewModel.currentLocation = location
            viewModel.getAddressFromLocation(from: location)
            print("currentAddress :- \(viewModel.currentAddress)")
            print("location :- \(location)")
            
        }
    }
   
}





