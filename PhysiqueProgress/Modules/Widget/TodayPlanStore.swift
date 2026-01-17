//
//  TodayPlanStore.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 17/01/26.
//

import Foundation

final class TodayPlanStore {

    private static let suite = "group.com.apertix.physiqueprogress"
    private static let key = "today_plan_snapshot"

    static func save(_ snapshot: TodayPlanSnapshot) {
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        UserDefaults(suiteName: suite)?.set(data, forKey: key)
    }

    static func load() -> TodayPlanSnapshot? {
        guard
            let data = UserDefaults(suiteName: suite)?.data(forKey: key),
            let snapshot = try? JSONDecoder().decode(TodayPlanSnapshot.self, from: data)
        else { return nil }

        return snapshot
    }
}
