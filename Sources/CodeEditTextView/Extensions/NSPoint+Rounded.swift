//
//  NSPoint+Rounded.swift
//  CodeEditTextView
//
//  Created by Daniel Choroszucha on 09/03/2025.
//

import Foundation

extension NSPoint {
    var rounded: NSPoint {
        return NSPoint(x: x.rounded(), y: y.rounded())
    }
}
