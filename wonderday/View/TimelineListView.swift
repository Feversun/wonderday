//
//  TimelineListView.swift
//  wonderday
//
//  Created by How Sun on 2023/9/27.
//

import SwiftUI
import CoreData

struct TimelineListView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Location.timestamp, ascending: true)],
        animation: .default)
    private var locations: FetchedResults<Location>
    
    
    @State private var isShowingDatePicker = false
    @State private var selectedDate = Date()
    @State private var isShowingAll = false
    
    var body: some View {
        NavigationView {
            VStack {
//                Text("Locations count: \(locations.filter { isShowingAll ? true : isSameDay($0.timestamp ?? Date(), selectedDate) }.count)") // 打印地点的数量
//                ForEach(locations.filter { isShowingAll ? true : isSameDay($0.timestamp ?? Date(), selectedDate) }, id: \.self) { location in
//                    Text("Location timestamp: \(dateToString(location.timestamp ?? Date()))") // 打印每个地点的日期
//                }
                HStack {
                    Button(action: {
                        self.selectedDate = Date() // 设置选中的日期为当前日期
                        self.isShowingAll = false // 不显示所有地点
                    }) {
                        Text("Today")
                    }
                    Button(action: {
                        self.isShowingDatePicker = true // 显示日期选择器
                    }) {
                        Text("Select Date")
                    }
                    Button(action: {
                        self.isShowingAll = true // 显示所有地点
                    }) {
                        Text("Show All")
                    }
                }
                ScrollView(.horizontal) {
                    HStack {
                        ForEach((1...7), id: \.self) { i in
                            Button(action: {
                                self.selectedDate = Calendar.current.date(byAdding: .day, value: -i, to: Date()) ?? Date()
                                self.isShowingAll = false // 不显示所有地点
                            }) {
                                Text(dateToString(Calendar.current.date(byAdding: .day, value: -i, to: Date()) ?? Date()))
                            }
                        }
                    }
                }
                ScrollView {
                    VStack {
                        ForEach(locations.filter { isShowingAll ? true : isSameDay($0.timestamp ?? Date(), selectedDate) }, id: \.self) { location in
                            NavigationLink(destination: LocationDetailView(location: location)) {
                                HStack(spacing: 20) {
                                    ZStack {
                                        Image(systemName: "mappin.and.ellipse")
                                            .imageScale(.large)
                                            .symbolRenderingMode(.monochrome)
                                    }
                                    .frame(width: 40, height: 40)
                                    .clipped()
                                    .background(Color(.systemFill))
                                    .mask { RoundedRectangle(cornerRadius: 14, style: .continuous) }
                                    VStack(alignment: .leading) {
                                        Text("Location")
                                        Text("\(location.latitude), \(location.longitude)")
                                            .font(.headline)
                                        Text("\(dateTimeToString(location.timestamp ?? Date()))")
                                            .font(.footnote)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .clipped()
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                                        .stroke(Color.green, lineWidth: 2)
                                        .background(RoundedRectangle(cornerRadius: 4, style: .continuous).fill(Color(.quaternarySystemFill)))
                                }
                            }
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .padding()
                }
            }
            .sheet(isPresented: $isShowingDatePicker) {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
            }
        }
    }
    
    func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        let result = calendar.isDate(date1, inSameDayAs: date2)
        print("Is same day: \(result)") // 打印结果
        return result
    }
    
    func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd" // 只显示月和日
        return formatter.string(from: date)
    }
    
    func dateTimeToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct TimelineListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let newLocation = Location(context: context)
        newLocation.latitude = 31.2304
        newLocation.longitude = 121.4737
        newLocation.timestamp = Date()
        
        return TimelineListView().environment(\.managedObjectContext, context)
    }
}
