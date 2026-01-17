//
//  PhysiqueProgressWidget.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 18/01/26.
//

import WidgetKit
import SwiftUI

@main
struct PhysiqueProgressWidget: Widget {

    let kind = "PhysiqueProgressWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurationAppIntent.self,
            provider: PhysiqueTimelineProvider()
        ) { entry in
            PhysiqueWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Physique Progress")
        .description("Today’s workout and meal plan.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
