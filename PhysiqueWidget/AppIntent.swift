//
//  AppIntent.swift
//  PhysiqueWidget
//
//  Created by Manav Kapur on 16/01/26.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Physique Progress" }
    static var description: IntentDescription { "Show today's workout and meal plan." }
}
