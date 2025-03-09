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
        guard
            let textStorage,
            let layoutManager
        else {
            return
        }

        layoutManager.layoutLines()

        for view in layoutManager.layoutView?.subviews ?? [] {
            if view is LineFragmentView {
                let rect = view.frame

                let trackingArea = NSTrackingArea(
                    rect: rect,
                    options: [
                        .mouseEnteredAndExited,
                        .mouseMoved,
                        .activeInKeyWindow
                    ],
                    owner: self,
                    userInfo: nil
                )

                addTrackingArea(trackingArea)
            }
        }
    }
}
