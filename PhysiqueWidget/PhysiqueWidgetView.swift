//
//  PhysiqueWidgetView.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 17/01/26.
//

import SwiftUI
import WidgetKit

struct PhysiqueWidgetView: View {

    let entry: PhysiqueEntry

    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, .gray.opacity(0.6)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)

            VStack(alignment: .leading, spacing: 10) {

                HStack {
                    Image(systemName: "bolt.heart.fill")
                        .foregroundColor(.green)
                    Text("Today")
                        .font(.caption.bold())
                        .foregroundColor(.secondary)
                    Spacer()
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text("Workout")
                        .font(.caption2)
                        .foregroundColor(.secondary)

                    Text(entry.snapshot.workoutTitle)
                        .font(.headline)
                        .foregroundColor(.white)

                    Text(entry.snapshot.workoutFocus)
                        .font(.caption2)
                        .foregroundColor(.green)
                }

                Divider().background(.white.opacity(0.2))

                VStack(alignment: .leading, spacing: 3) {
                    Text("Meal • \(entry.snapshot.mealSlot)")
                        .font(.caption2)
                        .foregroundColor(.secondary)

                    Text(entry.snapshot.mealTitle)
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                }

                Spacer()
            }
            .padding(14)
        }
    }
}
