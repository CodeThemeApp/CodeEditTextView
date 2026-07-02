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
        textStorage.attributes(at: location, effectiveRange: range)
    }
}
