//
//  TextView+Attributes.swift
//  CodeEditTextView
//
//  Created by Daniel Choroszucha on 09/03/2025.
//

import Foundation

extension TextView {
    func attributes(
        at location: Int,
        effectiveRange range: NSRangePointer?
    ) -> [NSAttributedString.Key: Any] {
        var attributes = textStorage.attributes(at: location, effectiveRange: range)

        // substring at location
        let substring = textStorage.attributedSubstring(from: .init(location: location, length: 1)).string
        if substring.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false,
           attributes[.captureName] as? String == nil
        {
            attributes[.captureName] = "parameter"
            return attributes
        } else {
            return attributes
        }
    }
}
