//
//  EditorConfig.swift
//  SwordMinder
//
//  Created by John Delano on 12/2/22.
//

import Foundation

/// Struct used to configure modal sheets and popovers
struct EditorConfig {
    var isPresented = false
    var needsSaving = false
    
    /// Used to indicate that a modal sheet or popover should appear
    mutating func present() {
        isPresented = true
        needsSaving = false
    }
    
    /// Used to indicate that a modal sheet or popover should disappear
    /// - Parameter save: Determines whether or not the contents from the modal popover should be saved or discarded.
    mutating func dismiss(save: Bool = false) {
        isPresented = false
        needsSaving = save
    }
}
