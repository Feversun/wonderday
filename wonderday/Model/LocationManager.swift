//
//  LocationManager.swift
//  wonderday
//
//  Created by How Sun on 2023/9/27.
//

import Foundation
import CoreLocation
import CoreData

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var locations = [Location]() // 更改类型为 [Location]
    
    private let locationManager = CLLocationManager()
    private let context = PersistenceController.shared.container.viewContext // 添加这行代码
    private let geocoder = CLGeocoder() // 添加这行代码
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = false // 修改这行代码
        locationManager.startMonitoringVisits()
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        DispatchQueue.main.async {
            let newLocation = Location(context: self.context) // 创建新的 Location 实体
            newLocation.latitude = visit.coordinate.latitude
            newLocation.longitude = visit.coordinate.longitude
            newLocation.timestamp = visit.arrivalDate
            self.locations.append(newLocation) // 将新的位置数据添加到 locations 数组中

            // 添加以下代码来获取地点信息
            let location = CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)
            self.geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let placemark = placemarks?.first {
                    newLocation.place = placemark.locality // 存储地点信息
                }
            }

            do {
                try self.context.save() // 将新的位置数据保存到 Core Data
            } catch {
                print("Failed to save location: \(error)")
            }
        }
    }
    
    func createMockData() {
        let newLocation = Location(context: self.context)
        newLocation.latitude = 31.2304
        newLocation.longitude = 121.4737
        newLocation.timestamp = Date()
        self.locations.append(newLocation)
        do {
            try self.context.save()
        } catch {
            print("Failed to save location: \(error)")
        }
    }
}

