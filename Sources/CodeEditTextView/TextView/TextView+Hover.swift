//
//  TextView+Hover.swift
//  CodeEditTextView
//
//  Created by Daniel Choroszucha on 02/03/2025.
//

import AppKit

extension TextView {
    override public func updateTrackingAreas() {
        super.updateTrackingAreas()
        onUpdateTrackingAreas()
    }

    func onUpdateTrackingAreas() {
        removeCurrentTrackingAreas()
        addDefaultTrackingArea()
    }

    private func removeCurrentTrackingAreas() {
        for trackingArea in trackingAreas {
            removeTrackingArea(trackingArea)
        }
    }

    private func addDefaultTrackingArea() {
        addTrackingArea(
            NSTrackingArea(
                rect: bounds,
                options: [.mouseEnteredAndExited, .activeInKeyWindow],
                owner: self
            )
        )
    }
}
