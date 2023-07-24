//
//  MapView.swift
//  AlDwaaNewApp
//
//  Created by ahmed hussien on 21/06/2023.
//

import SwiftUI
import CoreLocation
import GooglePlaces

struct MapView: View {
    @StateObject var locationViewModel = LocationViewModel()
    @State private var searchQuery = ""
    @State private var showAutocomplete = false
    @Binding var userLocation:LocationModel?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            GoogleMapView(viewModel: locationViewModel)
            VStack {
                searchField
                Spacer()
                locationButton
                addressView
            }
        }
        .sheet(isPresented: $showAutocomplete, onDismiss: dismissSearch) {
            PlaceAutocompleteView(searchQuery: $searchQuery, showAutocomplete: $showAutocomplete)
                .environmentObject(locationViewModel)
        }
    }
}
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(userLocation: .constant(LocationModel(location: CLLocation(latitude: 0.0, longitude: 0.0), addressString: "")))
    }
}

extension MapView {
    var searchField: some View {
        TextField("Search", text: $searchQuery, onEditingChanged: { _ in showAutocomplete = true })
            .overlay(
                Image("MapSearch")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding()
            )
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .cornerRadius(25)
            .padding(EdgeInsets(top: 20, leading: 30, bottom: 0, trailing: 30))
    }
    
    var locationButton: some View {
        Button(action: locationViewModel.pressedMylocationButton) {
            Image("location_marker").font(.largeTitle)
        }
        .padding(.bottom, 16)
        .padding(.trailing, 16)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    var addressView: some View {
        VStack {
            HStack {
                Image("location_white")
                Text(locationViewModel.currentAddress)
            }
            .padding()
            AppButton(state: .constant(.normal), style: .stroke()) {
                if let Location = locationViewModel.currentLocation  {
                    userLocation = LocationModel(location: Location, addressString: locationViewModel.currentAddress)
                }
                dismiss()
            } builder: {
                Text("save Selected location")
            }
            .padding()
        }//vstack
        .background(.white)
        .cornerRadius(25)
    }
    
   private func dismissSearch() {
        searchQuery = ""
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}



