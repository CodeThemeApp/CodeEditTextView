//
//  SyntacticTextView+VisibleRange.swift
//  CodeEditTextView
//
//  Created by Daniel Choroszucha on 09/03/2025.
//

import Foundation

extension SyntacticTextView {
    // TODO: [09.03.2025] Calculate visibile range -
    /// https://linear.app/codetheme/issue/MAC-26/dynamically-calculate-visible-text-range-in-window
    var visibleRange: NSRange {
        documentRange
    }
}
