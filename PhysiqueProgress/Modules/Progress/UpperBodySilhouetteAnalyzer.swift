import UIKit
import Vision

struct UpperBodySilhouetteMetrics {

    let shoulderWidth: CGFloat
    let chestWidth: CGFloat
    let upperWaistWidth: CGFloat

    let upperBodyArea: CGFloat
    let upperTorsoArea: CGFloat
}

final class UpperBodySilhouetteAnalyzer {

    func analyze(
        mask: CGImage,
        pose: VNHumanBodyPoseObservation
    ) -> UpperBodySilhouetteMetrics? {

        guard let pixelData = mask.dataProvider?.data,
              let data = CFDataGetBytePtr(pixelData),
              let points = try? pose.recognizedPoints(.all)
        else { return nil }

        let width = mask.width
        let height = mask.height
        let bytesPerRow = mask.bytesPerRow
        let bytesPerPixel = 4

        // MARK: - Pixel helpers

        func isBodyPixel(row: UnsafePointer<UInt8>, x: Int) -> Bool {
            let offset = x * bytesPerPixel
            let r = row[offset]
            let g = row[offset + 1]
            let b = row[offset + 2]
            return (Int(r) + Int(g) + Int(b)) / 3 > 30
        }

        /// 🔥 Arm-trimmed center-out scan
        func bodyWidth(at y: Int, band: Int = 6) -> CGFloat {
            var widths: [CGFloat] = []

            for yy in (y - band)...(y + band) {
                guard yy >= 0 && yy < height else { continue }
                let row = data + yy * bytesPerRow

                var xs: [Int] = []
                for x in 0..<width {
                    if isBodyPixel(row: row, x: x) { xs.append(x) }
                }

                guard xs.count > 40 else { continue }
                let center = xs.reduce(0, +) / xs.count

                var left = center
                var right = center

                var empty = 0
                var x = center

                while x > 0 {
                    if isBodyPixel(row: row, x: x) { left = x; empty = 0 }
                    else { empty += 1; if empty > 4 { break } }
                    x -= 1
                }

                empty = 0
                x = center

                while x < width - 1 {
                    if isBodyPixel(row: row, x: x) { right = x; empty = 0 }
                    else { empty += 1; if empty > 4 { break } }
                    x += 1
                }

                let w = CGFloat(right - left)
                if w > 40 && w < CGFloat(width) * 0.65 {
                    widths.append(w)
                }
            }

            return widths.isEmpty ? 0 : widths.reduce(0, +) / CGFloat(widths.count)
        }

        func minBodyWidth(from y1: Int, to y2: Int) -> CGFloat {
            var minWidth: CGFloat = .greatestFiniteMagnitude

            for y in y1...y2 {
                let w = bodyWidth(at: y, band: 3)
                if w > 25 && w < minWidth { minWidth = w }
            }

            return minWidth == .greatestFiniteMagnitude ? 0 : minWidth
        }

        // MARK: - Shoulder anchor

        guard
            let ls = points[.leftShoulder],
            let rs = points[.rightShoulder]
        else { return nil }

        let rawShoulderY = (1 - (ls.y + rs.y) / 2) * CGFloat(height)
        let shoulderY = min(max(Int(rawShoulderY), 0), height - 1)

        // MARK: - Vertical anatomy (elite calibrated)

        let chestY    = min(shoulderY + Int(CGFloat(height) * 0.038), height - 1)
        let upperAbsY = min(shoulderY + Int(CGFloat(height) * 0.17), height - 1)

        // 🔥 TRUE WAIST between chest and abs
        // 🔥 TRUE WAIST SEARCH ZONE
        // from lower chest to below abs
        let waistSearchStart = min(upperAbsY, height - 1)
        let waistSearchEnd   = min(shoulderY + Int(CGFloat(height) * 0.42), height - 1)

        var bestWaist: CGFloat = .greatestFiniteMagnitude
        var bestY = waistSearchStart

        if waistSearchEnd > waistSearchStart {
            for y in waistSearchStart...waistSearchEnd {
                let w = bodyWidth(at: y, band: 4)
                if w > 40 && w < bestWaist {
                    bestWaist = w
                    bestY = y
                }
            }
        }

        let waist = bestWaist == .greatestFiniteMagnitude ? 0 : bestWaist


        print("""
        ---- UPPER SLICE Y DEBUG ----
        shoulderY: \(shoulderY)
        chestY:    \(chestY)
        upperAbsY: \(upperAbsY)
        waistY*:   \(bestY)
        imageH:    \(height)
        -----------------------------
        """)


        // MARK: - Widths

        let shoulder = bodyWidth(at: shoulderY)
        let chest    = bodyWidth(at: chestY)


        if waist < 25 || chest < 40 || shoulder < 40 {
            print("❌ Invalid upper-body silhouette")
            return nil
        }

        // MARK: - Areas

        var upperPixels: CGFloat = 0
        var torsoPixels: CGFloat = 0

        let torsoStart = min(shoulderY + Int(CGFloat(height) * 0.04), height - 1)
        let torsoEnd   = min(shoulderY + Int(CGFloat(height) * 0.17), height - 1)
        if torsoEnd <= torsoStart { return nil }

        for y in shoulderY..<torsoEnd {
            let row = data + y * bytesPerRow
            for x in 0..<width {
                if isBodyPixel(row: row, x: x) {
                    upperPixels += 1
                    if y >= torsoStart { torsoPixels += 1 }
                }
            }
        }

        return UpperBodySilhouetteMetrics(
            shoulderWidth: shoulder,
            chestWidth: chest,
            upperWaistWidth: waist,
            upperBodyArea: upperPixels,
            upperTorsoArea: torsoPixels
        )
    }
}
