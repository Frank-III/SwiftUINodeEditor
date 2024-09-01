//
//  Color.swift
//  ScriptNode
//
//  Created by Jiangda on 8/25/24.
//
import SwiftUI

#if os(iOS)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension Color {
    
    static var platformQuaternaryLabel: Color {
        #if os(iOS)
        return Color(UIColor.quaternaryLabel)
        #elseif canImport(AppKit)
        return Color(NSColor.quaternaryLabelColor) // Assuming you add a custom extension to NSColor
        #endif
    }

    static var platformSystemGroupedBackground: Color {
        #if os(iOS)
        return Color(UIColor.systemGroupedBackground)
        #elseif canImport(AppKit)
        return Color(NSColor.windowBackgroundColor) // Approximate equivalent
        #endif
    }
    
    static var tertiarySystemGroupedBackground: Color {
        #if os(iOS)
        return Color(UIColor.tertiarySystemGroupedBackground)
        #elseif canImport(AppKit)
        return Color(NSColor.tertiarySystemFill) // Approximate equivalent
        #endif
    }

    static var platformSecondaryLabel: Color {
        #if os(iOS)
        return Color(UIColor.secondaryLabel)
        #elseif canImport(AppKit)
        return Color(NSColor.secondaryLabelColor) // Assuming you add a custom extension to NSColor
        #endif
    }

    static var platformSystemBackground: Color {
        #if os(iOS)
        return Color(UIColor.systemBackground)
        #elseif canImport(AppKit)
        return Color(NSColor.windowBackgroundColor) // Approximate equivalent
        #endif
    }
}
