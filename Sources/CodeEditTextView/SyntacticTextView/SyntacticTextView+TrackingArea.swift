//
//  SyntacticTextView+TrackingArea.swift
//  CodeEditTextView
//
//  Created by Daniel Choroszucha on 02/03/2025.
//

import AppKit

extension SyntacticTextView {
    // MARK: - Tracking Area Management

    override public func updateTrackingAreas() {
        super.updateTrackingAreas()
        updateHoverTrackingAreas()
    }

    private func updateHoverTrackingAreas() {
        removeExistingTrackingAreas()
        addTrackingAreasForLineFragments()
    }

    private func removeExistingTrackingAreas() {
        trackingAreas.forEach { removeTrackingArea($0) }
    }

    private func addTrackingAreasForLineFragments() {
        guard
            let layoutManager = layoutManager
        else {
            return
        }

        layoutManager.layoutView?.subviews.forEach { subview in
            guard let lineFragmentView = subview as? LineFragmentView else { return }
            let trackingArea = createTrackingArea(for: lineFragmentView.frame)
            addTrackingArea(trackingArea)
        }
    }

    private func createTrackingArea(for rect: NSRect) -> NSTrackingArea {
        return NSTrackingArea(
            rect: rect,
            options: [.mouseEnteredAndExited, .mouseMoved, .activeAlways],
            owner: self,
            userInfo: nil
        )
    }
}
