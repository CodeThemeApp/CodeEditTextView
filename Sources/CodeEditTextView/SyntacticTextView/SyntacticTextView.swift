//
//  SyntacticTextView.swift
//  CodeEditTextView
//
//  Created by Daniel Choroszucha on 23/03/2025.
//

import AppKit

public class SyntacticTextView: TextView {
    /// The syntax category selection manager for the syntactic text view.
    public package(set) var syntacticSelectionManager: SyntacticTextSelectionManager!

    var roundedPreviousMousePosition: NSPoint?
    var currentlyHoveredCaptureName: String?

    public init(string: String) {
        super.init(
            string: string,
            isEditable: false
        )
        self.syntacticSelectionManager = setUpSyntacticSelectionManager()
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layout() {
        super.layout()
        updateTrackingAreas()
    }

    override public func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        updateTrackingAreas()
    }
}

extension SyntacticTextView {
    func setUpSyntacticSelectionManager() -> SyntacticTextSelectionManager {
        SyntacticTextSelectionManager(
            layoutManager: layoutManager,
            textStorage: textStorage,
            textView: self,
            delegate: self
        )
    }
}
