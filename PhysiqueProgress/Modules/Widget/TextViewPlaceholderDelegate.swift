//
//  TextViewPlaceholderDelegate.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 18/01/26.
//

import UIKit

final class TextViewPlaceholderDelegate: NSObject, UITextViewDelegate {

    static let shared = TextViewPlaceholderDelegate()

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .tertiaryLabel {
            textView.text = ""
            textView.textColor = .label
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.textColor = .tertiaryLabel
        }
    }
}
