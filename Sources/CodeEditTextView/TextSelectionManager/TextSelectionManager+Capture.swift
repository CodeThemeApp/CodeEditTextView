//
//  TextSelectionManager+Capture.swift
//  CodeEditTextView
//
//  Created by Daniel Choroszucha on 09/03/2025.
//

import Foundation

public extension TextSelectionManager {
    /// Sets the text selection based on the capture
    /// - Parameter offset: text position
    func setSelectedCapture(at offset: Int) {
        let range = NSRange(location: offset, length: 0)
        setSelectedRanges([range])
    }
}
