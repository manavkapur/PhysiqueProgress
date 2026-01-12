//
//  SilhouetteAnalyzer.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 12/01/26.
//

import CoreVideo
import UIKit

struct SilhouetteMetrics {
    let shoulderWidth: Double
    let waistWidth: Double
    let hipWidth: Double
    let upperArea: Double
    let lowerArea: Double
}

final class SilhouetteAnalyzer {

    func analyze(mask: CVPixelBuffer) -> SilhouetteMetrics {

        CVPixelBufferLockBaseAddress(mask, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(mask, .readOnly) }

        let width = CVPixelBufferGetWidth(mask)
        let height = CVPixelBufferGetHeight(mask)
        let base = CVPixelBufferGetBaseAddress(mask)!.assumingMemoryBound(to: UInt8.self)

        func bodyWidth(at row: Int) -> Double {
            var left = width, right = 0

            for x in 0..<width {
                if base[row * width + x] > 0 {
                    left = min(left, x)
                    right = max(right, x)
                }
            }

            return left < right ? Double(right - left) : 0
        }

        // vertical sampling bands
        let shoulderRow = Int(Double(height) * 0.28)
        let waistRow    = Int(Double(height) * 0.48)
        let hipRow      = Int(Double(height) * 0.58)

        let shoulder = bodyWidth(at: shoulderRow)
        let waist    = bodyWidth(at: waistRow)
        let hip      = bodyWidth(at: hipRow)

        var upperArea = 0.0
        var lowerArea = 0.0

        for y in 0..<height {
            for x in 0..<width {
                if base[y * width + x] > 0 {
                    if y < height / 2 { upperArea += 1 }
                    else { lowerArea += 1 }
                }
            }
        }

        return SilhouetteMetrics(
            shoulderWidth: shoulder,
            waistWidth: waist,
            hipWidth: hip,
            upperArea: upperArea,
            lowerArea: lowerArea
        )
    }
}
