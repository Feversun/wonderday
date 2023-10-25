//
//  LocationSearchView.swift
//  wonderday
//
//  Created by How Sun on 2023/10/23.
//

import SwiftUI
import MapKit

struct LocationSearchView: View {
    @Binding var placeName: String
    @State private var searchQuery = ""
    @State private var searchResults = [String]()
    @ObservedObject var location: Location
    
    var body: some View {
        VStack {
            SearchBar(text: $searchQuery, onSearchButtonChanged: fetchPlaces)
            List(searchResults, id: \.self) { result in
                Button(action: {
                    self.placeName = result
                    updateLocation(for: result)
                }) {
                    Text(result)
                }
            }
        }
    }
    
    func fetchPlaces() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchQuery

        // 创建一个以当前位置为中心，半径为2公里的区域
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), latitudinalMeters: 2000, longitudinalMeters: 2000)
        request.region = region

        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            if let response = response {
                self.searchResults = response.mapItems.compactMap { $0.name }
            }
        }
    }
    
    func updateLocation(for placeName: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(placeName) { (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error)")
                return
            }
            if let placemark = placemarks?.first, let location = placemark.location {
                self.location.latitude = location.coordinate.latitude
                self.location.longitude = location.coordinate.longitude
                do {
                    try self.location.managedObjectContext?.save() // 尝试保存更改到 Core Data
                } catch {
                    print("Failed to save location: \(error)") // 如果保存失败，打印错误信息
                }
            }
        }
    }
    
}

struct SearchBar: View {
    @Binding var text: String
    var onSearchButtonChanged: () -> Void
    
    var body: some View {
        TextField("Search", text: $text, onCommit: onSearchButtonChanged)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

//struct LocationSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocationSearchView(placeName: .constant(""))
//    }
//}
