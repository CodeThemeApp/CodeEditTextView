//
//  TextView+Select.swift
//  CodeEditTextView
//
//  Created by Khan Winter on 10/20/23.
//

import AppKit
import TextStory

public extension TextView {
    override func selectAll(_ sender: Any?) {
        selectionManager.setSelectedRange(documentRange)
        unmarkTextIfNeeded()
        needsDisplay = true
    }

    override func selectLine(_ sender: Any?) {
        let newSelections = selectionManager.textSelections.compactMap { textSelection -> NSRange? in
            guard let linePosition = layoutManager.textLineForOffset(textSelection.range.location) else {
                return nil
            }
            return linePosition.range
        }
        selectionManager.setSelectedRanges(newSelections)
        unmarkTextIfNeeded()
        needsDisplay = true
    }

    override func selectWord(_ sender: Any?) {
        let newSelections = rangeForWordSelection()
        selectionManager.setSelectedRanges(newSelections)
        unmarkTextIfNeeded()
        needsDisplay = true
    }

    private func rangeForWordSelection() -> [NSRange] {
        selectionManager.textSelections.compactMap { textSelection -> NSRange? in
            guard textSelection.range.isEmpty,
                  let char = textStorage.substring(
                      from: NSRange(location: textSelection.range.location, length: 1)
                  )?.first else {
                return nil
            }
            let charSet = CharacterSet(charactersIn: String(char))
            let characterSet: CharacterSet
            if CharacterSet.alphanumerics.isSuperset(of: charSet) {
                characterSet = .alphanumerics
            } else if CharacterSet.whitespaces.isSuperset(of: charSet) {
                characterSet = .whitespaces
            } else if CharacterSet.newlines.isSuperset(of: charSet) {
                characterSet = .newlines
            } else if CharacterSet.punctuationCharacters.isSuperset(of: charSet) {
                characterSet = .punctuationCharacters
            } else {
                return nil
            }
            guard let start = textStorage
                .findPrecedingOccurrenceOfCharacter(in: characterSet.inverted, from: textSelection.range.location),
                let end = textStorage
                .findNextOccurrenceOfCharacter(in: characterSet.inverted, from: textSelection.range.max) else {
                return nil
            }
            return NSRange(start: start, end: end)
        }
    }

    func selectCapture(_ sender: Any?) {
        // TODO: [09.03.2025] Add selection padding -
        /// to check leading / trailing characters next to current selection
        /// and add logic that verifies that this is between the same capture sytnax and should be highlighted
        /// eg. comments, docs

        // 1. check if text is larger than ""
        guard textStorage.string.isEmpty == false else { return }
        guard let captureName = getCurrentWordCaptureName() else { return }
        currentlyHoveredCaptureName = captureName

        // TODO: [09.03.2025] Highlight it differently -

        // TODO: [09.03.2025] Highlight other words with the same capture name -
        /// 1. Get the `NSRange` for entire text (or ideally for the part that is visible 😜)
        let documentRange = visibleRange()
        /// 2. Find the array of `NSRange` that contain matching attributedString `captureName` property
        let matchingRanges = ranges(for: captureName, in: documentRange)
        /// 3. Mark words underneath as selected
        selectionManager.setSelectedRanges(matchingRanges)
        needsDisplay = true
    }

    private func ranges(for captureName: String, in range: NSRange) -> [NSRange] {
        var matchingRanges: [NSRange] = []
        var searchRange = range

        while searchRange.length > 0 {
            var foundRange = NSRange(location: NSNotFound, length: 0)

            textStorage.enumerateAttribute(
                NSAttributedString.Key("captureName"),
                in: searchRange,
                options: []
            ) { value, range, stop in
                if let value = value as? String, value == captureName {
                    foundRange = range
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

    private func getCurrentWordCaptureName() -> String? {
        guard let currentWordRange = rangeForWordSelection().first else { return nil }
        var effectiveRange = NSRange(start: 0, end: 0)
        let attributes = textStorage.attributes(
            at: currentWordRange.lowerBound,
            effectiveRange: &effectiveRange
        )
        return attributes[NSAttributedString.Key("captureName")] as? String
    }
}
