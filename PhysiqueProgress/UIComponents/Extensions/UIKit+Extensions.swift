//
//  UIKit+Extensions.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 15/01/26.
//

import UIKit

extension UITextField {
    func setLeftPadding(_ amount: CGFloat) {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: 0))
        leftView = v
        leftViewMode = .always
    }
}

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        self.init(
            red: CGFloat((int >> 16) & 0xff) / 255,
            green: CGFloat((int >> 8) & 0xff) / 255,
            blue: CGFloat(int & 0xff) / 255,
            alpha: 1
        )
    }
}
