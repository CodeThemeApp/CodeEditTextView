//
//  SyntacticTextView+Capture.swift
//  CodeEditTextView
//
//  Created by Daniel Choroszucha on 23/03/2025.
//

import Foundation

extension SyntacticTextView {
    private func rangeForSelectedCapture() throws -> NSRange {
        let range = selectionManager.textSelections.compactMap { textSelection -> NSRange? in
            let attributedSubstring = textStorage.attributedSubstring(
                from: NSRange(location: textSelection.range.location, length: 1)
            )

            guard textSelection.range.isEmpty,
                  let char = attributedSubstring.string.first
            else {
                return nil
            }

            guard
                let characterSet = characterSet(for: String(char))
            else {
                return nil
            }

            if characterSet == .alphanumerics || characterSet == .punctuationCharacters {
                guard
                    let start = textStorage.findPrecedingOccurrenceOfCharacter(
                        in: characterSet.inverted,
                        from: textSelection.range.location
                    ),
                    let end = textStorage.findNextOccurrenceOfCharacter(
                        in: characterSet.inverted,
                        from: textSelection.range.max
                    )
                else {
                    return nil
                }
                return NSRange(start: start, end: end)
            } else {
                return nil
            }
        }
        guard let first = range.first else { throw CaptureSelectionError.unknown }
        return first
    }

    private func characterSet(for string: String) -> CharacterSet? {
        let charSet = CharacterSet(charactersIn: string)

        if CharacterSet.alphanumerics.isSuperset(of: charSet) {
            return .alphanumerics
        } else if CharacterSet.whitespaces.isSuperset(of: charSet) {
            return .whitespaces
        } else if CharacterSet.newlines.isSuperset(of: charSet) {
            return .newlines
        } else if CharacterSet.punctuationCharacters.isSuperset(of: charSet) {
            return .punctuationCharacters
        } else {
            return nil
        }
    }

    enum CaptureSelectionError: Error {
        case empty
        case outOfBounds
        case invisibles
        case missingAttribute
        case unknown
    }

    func selectCapture(_ sender: Any?) {
        // TODO: [09.03.2025] Add selection padding -
        /// to check leading / trailing characters next to current selection
        /// and add logic that verifies that this is between the same capture sytnax and should be highlighted
        /// eg. comments, docs
        guard textStorage.string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false else { return }

        do {
            let hoveredRange = try rangeForSelectedCapture()
            let captureName = try captureName(for: hoveredRange)
            currentlyHoveredCaptureName = captureName

            let documentRange = visibleRange
            let matchingRanges = ranges(for: captureName, in: documentRange)
            selectionManager.setSelectedRanges(matchingRanges)
            // TODO: [23.03.2025] Efficiency issue: many repeating calls -
            syntacticSelectionManager.setSelectedCapture(at: hoveredRange.location)
            print("Hovered range: \(hoveredRange)")
            unmarkTextIfNeeded()
            needsDisplay = true
        } catch {
            deselectCapture()
        }
    }

    func deselectCapture() {
        currentlyHoveredCaptureName = nil
        selectionManager.removeCursors()
        selectionManager.setSelectedRanges([])
        unmarkTextIfNeeded()
        needsDisplay = true
    }

    private func ranges(for captureName: String, in range: NSRange) -> [NSRange] {
        var matchingRanges: [NSRange] = []
        var searchRange = range

        while searchRange.length > 0 {
            var foundRange = NSRange(location: NSNotFound, length: 0)

            textStorage.enumerateAttribute(
                .captureName,
                in: searchRange,
                options: []
            ) { value, currentRange, stop in
                if let value = value as? String, value == captureName,
                   textStorage.substring(from: currentRange)?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
                    foundRange = currentRange
                    stop.pointee = true
                }
            }

            if foundRange.location != NSNotFound {
                matchingRanges.append(foundRange)

                // Update search range correctly
                let newStart = foundRange.location + foundRange.length
                let remainingLengthInSearchRange = searchRange.location + searchRange.length - newStart
                let newSearchRange = NSRange(location: newStart, length: remainingLengthInSearchRange)
                searchRange = newSearchRange
            } else {
                break
            }
        }

        return matchingRanges
    }

    private func captureName(for range: NSRange) throws -> String {
        let range = try rangeForSelectedCapture()
        var effectiveRange = NSRange(start: 0, end: 0)
        let attributes = attributes(
            at: range.lowerBound,
            effectiveRange: &effectiveRange
        )
        guard let value = attributes[.captureName] as? String
        else {
            throw CaptureSelectionError.missingAttribute
        }
        return value
    }
}
