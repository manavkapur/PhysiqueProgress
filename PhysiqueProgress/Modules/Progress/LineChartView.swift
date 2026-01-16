//
//  LineChartView.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 05/01/26.
//

import UIKit

final class LineChartView: UIView {

    var values: [Double] = [] {
        didSet { setNeedsDisplay() }
    }

    override func draw(_ rect: CGRect) {
        guard values.count > 1 else { return }

        let path = UIBezierPath()
 
        let maxValue = values.max() ?? 1
        let minValue = values.min() ?? 0

        let padding = max((maxValue - minValue) * 0.6, 1.5)
        let top = maxValue + padding
        let bottom = minValue - padding
        let range = max(top - bottom, 1)

        let stepX = rect.width / CGFloat(values.count - 1)

        for (index, value) in values.enumerated() {
            let x = CGFloat(index) * stepX
            let yRatio = (value - bottom) / range
            let y = rect.height - (CGFloat(yRatio) * rect.height)

            index == 0
                ? path.move(to: CGPoint(x: x, y: y))
                : path.addLine(to: CGPoint(x: x, y: y))
        }

        UIColor.systemBlue.setStroke()
        path.lineWidth = 3
        path.stroke()
    }
}
