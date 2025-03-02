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
        trackingAreas.forEach { removeTrackingArea($0) }
    }

    private func addDefaultTrackingArea() {
        guard let textStorage else {
            print("no text storage")
            return
        }
        guard let layoutManager else {
            print("no layoutManager")
            return
        }

        // Lay out the text
        layoutManager.layoutLines()

        // Get the subviews of the layout manager's view
        for view in layoutManager.layoutView?.subviews ?? [] {
            // Check if the view is a LineFragmentView
            if view is LineFragmentView {
                // Get the rect for the view
                let rect = view.frame

                // Create a tracking area for the view
                let trackingArea = NSTrackingArea(
                    rect: rect,
                    options: [
                        .mouseEnteredAndExited,
                        .mouseMoved,
                        .activeAlways // changed for now
                    ],
                    owner: self,
                    userInfo: nil
                )

                // Add the tracking area to the view
                addTrackingArea(trackingArea)
            }
        }
    }
}
