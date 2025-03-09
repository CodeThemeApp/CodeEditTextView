//
//  TextView+VisibleRange.swift
//  CodeEditTextView
//
//  Created by Daniel Choroszucha on 09/03/2025.
//

import AppKit

extension TextView {
    func visibleRange() -> NSRange {
//        let visibleRect = self.bounds
//        let textVisibleRect = self.convertFromBacking(visibleRect)
//        
//        layoutManager.visibleLineIds.map { id in
//            let line = layoutManager.lineStorage.getLine(with: id)
//        }
        
        documentRange
    }
}
