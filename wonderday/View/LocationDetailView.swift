//
//  LocationDetailView.swift
//  wonderday
//
//  Created by How Sun on 2023/10/23.
//

import SwiftUI
import MapKit

struct LocationDetailView: View {
    @ObservedObject var location: Location
    @State private var isShowingSearchView = false

    var body: some View {
        VStack {
            Map(coordinateRegion: .constant(MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: location.latitude,
                    longitude: location.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))),
                annotationItems: [location]) { location in
                    MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                }
            Button(action: {
                self.isShowingSearchView = true
            }) {
                Text("Manual Change Location")
            }
            .sheet(isPresented: $isShowingSearchView) {
                LocationSearchView(placeName: Binding<String>(
                    get: { self.location.userModifiedPlace ?? "" },
                    set: { self.location.userModifiedPlace = $0 }
                ), location: location)
            }
        }
    }
}


struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let newLocation = Location(context: context)
        newLocation.latitude = 31.2304
        newLocation.longitude = 121.4737
        newLocation.timestamp = Date()
        return LocationDetailView(location: newLocation)
    }
}
