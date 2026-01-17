//
//  WidgetRefreshManager.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 17/01/26.
//

import Foundation
import WidgetKit

enum WidgetRefreshManager {

    static func refreshTodayWidget() {
        let snapshot = TodayPlanEngine.buildTodayPlan()
        TodayPlanStore.save(snapshot)
        WidgetCenter.shared.reloadAllTimelines()
        
        print("🔄 Widget refreshed")
    }
}
