//
//  HiddenModifier.swift
//  MedicalApp
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import SwiftUI

public struct ConditionalHiddenModifier: ViewModifier {
    let isHidden: Bool

    public func body(content: Content) -> some View {
        if !isHidden {
            content
        }
    }
}

public extension View {
    func hiddenIf(_ condition: Bool) -> some View {
        modifier(ConditionalHiddenModifier(isHidden: condition))
    }
}
