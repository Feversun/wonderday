//
//  StatisticsView.swift
//  wonderday
//
//  Created by How Sun on 2023/9/27.
//

import SwiftUI
import Charts

struct StatisticsView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Activity.startTime, ascending: true)],
        animation: .default)
    private var activities: FetchedResults<Activity>

    var body: some View {
        VStack {
            Text("活动统计")
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
