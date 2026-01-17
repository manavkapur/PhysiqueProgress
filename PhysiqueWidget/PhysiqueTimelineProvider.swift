//
//  PhysiqueTimelineProvider.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 17/01/26.
//

import WidgetKit

struct PhysiqueEntry: TimelineEntry {
    let date: Date
    let snapshot: TodayPlanSnapshot
}

struct PhysiqueTimelineProvider: AppIntentTimelineProvider {

    func placeholder(in context: Context) -> PhysiqueEntry {
        PhysiqueEntry(date: .now, snapshot: TodayPlanEngine.buildTodayPlan())
    }

    func snapshot(for configuration: ConfigurationAppIntent,
                  in context: Context) async -> PhysiqueEntry {
        PhysiqueEntry(date: .now, snapshot: TodayPlanEngine.buildTodayPlan())
    }

    func timeline(for configuration: ConfigurationAppIntent,
                  in context: Context) async -> Timeline<PhysiqueEntry> {

        let snapshot = TodayPlanEngine.buildTodayPlan()

        let refresh = Calendar.current.date(byAdding: .minute, value: 30, to: .now)!

        return Timeline(entries: [
            PhysiqueEntry(date: .now, snapshot: snapshot)
        ], policy: .after(refresh))
    }
}
