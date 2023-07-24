//
//  PlacesSearch.swift
//  AlDwaaNewApp
//
//  Created by ahmed hussien on 06/07/2023.
//

import Foundation
import SwiftUI
import GooglePlaces
import GoogleMaps
import CoreLocation

struct PlaceAutocompleteView: UIViewControllerRepresentable {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @Binding var searchQuery: String
    @Binding var showAutocomplete: Bool
    
    func makeUIViewController(context: Context) -> UIViewController {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = context.coordinator
        let autocompleteFilter = GMSAutocompleteFilter()
        autocompleteFilter.types = ["address"]
        autocompleteController.autocompleteFilter = autocompleteFilter
        return autocompleteController
    }
    
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        ///No update needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, GMSAutocompleteViewControllerDelegate {
        let parent: PlaceAutocompleteView
        
        init(parent: PlaceAutocompleteView) {
            self.parent = parent
        }
        
        //update current location and address when a place is selected from places list
        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            parent.searchQuery = place.name ?? ""
            let location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            parent.locationViewModel.getAddressFromLocation(from: location)
            parent.locationViewModel.currentLocation = location
            parent.locationViewModel.moveToLoactionFormPlaces()
            dismiss(viewController)
        }
        
        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            print("Autocomplete error: \(error.localizedDescription)")
            dismiss(viewController)
        }
        
        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            dismiss(viewController)
        }
        
        private func dismiss(_ viewController: GMSAutocompleteViewController) {
                   viewController.dismiss(animated: true) {
                        self.parent.showAutocomplete = false
                    }
               }
    }
}
