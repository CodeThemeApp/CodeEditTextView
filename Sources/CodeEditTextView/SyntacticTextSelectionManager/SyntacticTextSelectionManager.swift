//
//  SyntacticTextSelectionManager.swift
//  CodeEditTextView
//
//  Created by Daniel Choroszucha on 23/03/2025.
//

import Foundation

public class SyntacticTextSelectionManager: TextSelectionManager {
    public static let syntacticCategorySelectionChangedNotification: Notification.Name = .init("com.CodeEdit.SyntacticTextSelectionManager.Syntactic CategorySelectionChangedNotification")

    public var selectedSyntacticName: String?
    public var selectedSyntacticRange: NSRange?

    /// - Parameter offset: text position
    func setSelectedCapture(
        _ captureName: String?,
        at range: NSRange?
    ) {
        selectedSyntacticName = captureName
        selectedSyntacticRange = range

        if let range {
            setSelectedRanges([range])
        } else {
            setSelectedRanges([])
        }
        
        NotificationCenter.default.post(
            Notification(
                name: Self.syntacticCategorySelectionChangedNotification,
                object: self
            )
        )
    }
}
