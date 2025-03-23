//
//  SyntacticTextView+Attributes.swift
//  CodeEditTextView
//
//  Created by Daniel Choroszucha on 09/03/2025.
//

import Foundation

extension SyntacticTextView {
    func attributes(
        at location: Int,
        effectiveRange range: NSRangePointer?
    ) -> [NSAttributedString.Key: Any] {
        var attributes = textStorage.attributes(at: location, effectiveRange: range)

        // substring at location
        let substring = textStorage.attributedSubstring(from: .init(location: location, length: 1)).string
        if substring.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false,
           attributes[.captureName] as? String == nil {
            // TODO: [23.03.2025] Handle default capture name -
            /// https://linear.app/codetheme/issue/MAC-25/handle-defaults-for-attribute-to-capture-mapping-failure
            attributes[.captureName] = "parameter"
            return attributes
        } else {
            return attributes
        }
    }
}
