//
//  SyntacticTextView+Mouse.swift
//  CodeEditTextView
//
//  Created by Daniel Choroszucha on 23/03/2025.
//

import AppKit

extension SyntacticTextView {
    public override func mouseDown(with event: NSEvent) {
        guard let offset = offset(for: event) else { return }
        handleSingleClick(event: event, offset: offset)
    }

    private func offset(for event: NSEvent) -> Int? {
        layoutManager.textOffsetAtPoint(
            convert(
                event.locationInWindow,
                from: nil
            )
        )
    }

    fileprivate func handleSingleClick(event: NSEvent, offset: Int) {
        selectionManager.setSelectedRange(NSRange(location: offset, length: 0))
        selectCapture(nil)
        unmarkTextIfNeeded()
    }
}

// MARK: Mouse Hover -

public extension SyntacticTextView {
    override func mouseEntered(with event: NSEvent) {
        if let location = updatedLocation(for: event),
           let offset = layoutManager.textOffsetAtPoint(convert(location, from: nil)) {
            handleHover(at: offset)
        }
    }

    override func mouseMoved(with event: NSEvent) {
        if let location = updatedLocation(for: event),
           let offset = layoutManager.textOffsetAtPoint(convert(location, from: nil)) {
            handleHover(at: offset)
        }
    }

    override func mouseExited(with event: NSEvent) {
        roundedPreviousMousePosition = nil
    }

    private func updatedLocation(for event: NSEvent) -> NSPoint? {
        let newLocation = event.locationInWindow.rounded
        let previousLocation = roundedPreviousMousePosition

        /// Early return when update is not required
        guard newLocation.x != previousLocation?.x || newLocation.y != previousLocation?.y else {
            return nil
        }

        roundedPreviousMousePosition = newLocation
        return newLocation
    }

    private func handleHover(at offset: Int) {
        selectionManager.setSelectedRanges([NSRange(location: offset, length: 0)])
    }
}
