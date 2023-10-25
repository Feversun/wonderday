//
//  ContentView.swift
//  wonderday
//
//  Created by How Sun on 2023/9/27.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var locationMangager = LocationManager()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TimelineListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Timeline")
                }
                .tag(0)
            
            FootprintMapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Footprint")
                }
                .tag(1)
            
            StatisticsView()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Statistics")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let newLocation = Location(context: context)
        newLocation.latitude = 31.2304
        newLocation.longitude = 121.4737
        newLocation.timestamp = Date()

        return ContentView().environment(\.managedObjectContext, context)
    }
}
