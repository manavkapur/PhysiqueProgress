//
//  SilhouetteAnalyzer.swift
//  PhysiqueProgress
//

import UIKit

struct SilhouetteMetrics {
    let shoulderWidth: CGFloat
    let chestWidth: CGFloat
    let waistWidth: CGFloat
    let hipWidth: CGFloat
    let thighWidth: CGFloat
    
    let bodyArea: CGFloat
    let torsoArea: CGFloat
    let bodyHeight: CGFloat
}

final class SilhouetteAnalyzer {

    func analyze(mask: CGImage) -> SilhouetteMetrics? {
        guard let pixelData = mask.dataProvider?.data,
              let data = CFDataGetBytePtr(pixelData) else { return nil }

        let width = mask.width
        let height = mask.height
        let bytesPerRow = mask.bytesPerRow
        let bytesPerPixel = 4

        func isBodyPixel(row: UnsafePointer<UInt8>, x: Int) -> Bool {
            let offset = x * bytesPerPixel

            let r = row[offset]
            let g = row[offset + 1]
            let b = row[offset + 2]

            // convert to brightness
            let brightness = (Int(r) + Int(g) + Int(b)) / 3

            return brightness > 30   // body is light, background is dark
        }


        func bodyWidth(at percent: CGFloat, band: CGFloat = 0.015) -> CGFloat {
            let centerY = Int(CGFloat(height) * percent)
            let bandPx = Int(CGFloat(height) * band)

            var widths: [CGFloat] = []

            for y in (centerY - bandPx)...(centerY + bandPx) {
                guard y >= 0 && y < height else { continue }
                let row = data + y * bytesPerRow

                var left = -1
                var right = -1

                for x in 0..<width {
                    if isBodyPixel(row: row, x: x) { left = x; break }
                }

                for x in stride(from: width - 1, through: 0, by: -1) {
                    if isBodyPixel(row: row, x: x) { right = x; break }
                }

                if left != -1 && right != -1 {
                    widths.append(CGFloat(right - left))
                }
            }

            return widths.isEmpty ? 0 : widths.reduce(0, +) / CGFloat(widths.count)
        }


        var bodyPixels: CGFloat = 0
        var torsoPixels: CGFloat = 0

        let torsoStart = Int(CGFloat(height) * 0.18)
        let torsoEnd   = Int(CGFloat(height) * 0.52)

        for y in 0..<height {
            let row = data + y * bytesPerRow
            for x in 0..<width {

                let offset = x * bytesPerPixel
                let r = row[offset]
                let g = row[offset + 1]
                let b = row[offset + 2]

                #if DEBUG
                // 🧪 TEMP DEBUG — print first 10 pixels of middle row
                if y == height / 2 && x < 10 {
                    print("PIXEL", x, r, g, b)
                }
                #endif

                
                if isBodyPixel(row: row, x: x) {
                    bodyPixels += 1
                    if y >= torsoStart && y <= torsoEnd {
                        torsoPixels += 1
                    }
                }
            }
        }


        let shoulder = bodyWidth(at: 0.25)
        let chest    = bodyWidth(at: 0.32)
        let waist    = bodyWidth(at: 0.55)
        let hip      = bodyWidth(at: 0.63)
        let thigh    = bodyWidth(at: 0.72)

        print("""
        ---- WIDTH DEBUG ----
        Shoulder: \(shoulder)
        Chest:    \(chest)
        Waist:    \(waist)
        Hip:      \(hip)
        Thigh:    \(thigh)
        ---------------------
        """)

        return SilhouetteMetrics(
            shoulderWidth: shoulder,
            chestWidth: chest,
            waistWidth: waist,
            hipWidth: hip,
            thighWidth: thigh,
            bodyArea: bodyPixels,
            torsoArea: torsoPixels,
            bodyHeight: CGFloat(height)
        )


    }
}
