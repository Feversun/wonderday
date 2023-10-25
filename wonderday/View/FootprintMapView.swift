//
//  FootprintMapView.swift
//  wonderday
//
//  Created by How Sun on 2023/9/27.
//

import SwiftUI
import MapKit

struct CodableCLLocationCoordinate2D: Codable {
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
}

struct CodableMKCoordinateSpan: Codable {
    var latitudeDelta: CLLocationDegrees
    var longitudeDelta: CLLocationDegrees
}

struct CodableMKCoordinateRegion: Codable, Equatable {
    var center: CodableCLLocationCoordinate2D
    var span: CodableMKCoordinateSpan
    
    static func == (lhs: CodableMKCoordinateRegion, rhs: CodableMKCoordinateRegion) -> Bool {
        return lhs.center.latitude == rhs.center.latitude &&
        lhs.center.longitude == rhs.center.longitude &&
        lhs.span.latitudeDelta == rhs.span.latitudeDelta &&
        lhs.span.longitudeDelta == rhs.span.longitudeDelta
    }
}

struct FootprintMapView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Location.timestamp, ascending: true)],
        animation: .default)
    private var locations: FetchedResults<Location>
    
    @AppStorage("mapRegion") private var storedRegion: Data?
    
    @State private var mapType: MKMapType = .standard
    
    @State private var region: CodableMKCoordinateRegion = {
        var region = CodableMKCoordinateRegion(
            center: CodableCLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: CodableMKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        if let storedRegion = UserDefaults.standard.data(forKey: "mapRegion"),
           let decodedRegion = try? JSONDecoder().decode(CodableMKCoordinateRegion.self, from: storedRegion) {
            region = decodedRegion
        }
        return region
    }()
    
    var body: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: region.center.latitude, longitude: region.center.longitude), span: MKCoordinateSpan(latitudeDelta: region.span.latitudeDelta, longitudeDelta: region.span.longitudeDelta))), annotationItems: locations) { location in
            MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        }
        .onAppear {
            if let storedRegion = storedRegion,
               let decodedRegion = try? JSONDecoder().decode(CodableMKCoordinateRegion.self, from: storedRegion) {
                region = decodedRegion
            } else {
                region = CodableMKCoordinateRegion(
                    center: CodableCLLocationCoordinate2D(
                        latitude: locations.first?.latitude ?? 0,
                        longitude: locations.first?.longitude ?? 0),
                    span: CodableMKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
            }
        }
        .onChange(of: region) { newRegion in
            storedRegion = try? JSONEncoder().encode(newRegion)
        }
    }
}

struct FootprintMapView_Previews: PreviewProvider {
    static var previews: some View {
        FootprintMapView()
    }
}
