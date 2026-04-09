//
//  DefaultSpacing.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import Foundation
import SwiftUI

public enum DefaultSpacing {
    /// 64pt
    case p64
    // 56pt
    case p56
    /// 52pt
    case p52
    /// 48pt
    case p48
    /// 44
    case p44
    /// 42
    case p42
    /// 40
    case p40
    /// 32pt
    case p32
    /// 24pt
    case p24
    /// 20pt
    case p20
    /// 16pt
    case p16
    /// 14pt
    case p14
    /// 12pt
    case p12
    /// 10pt
    case p10
    /// 8pt
    case p8
    /// 5pt
    case p5
    /// 4pt
    case p4
    /// 3pt
    case p3
    /// 2pt
    case p2
}

public extension CGFloat {
    
    static func defaultSpacing(_ spacing: DefaultSpacing) -> CGFloat {
        switch spacing {
        case .p64:
            return 64
        case .p56:
            return 56
        case .p52:
            return 52
        case .p48:
            return 48
        case .p44:
            return 44
        case .p40:
            return 40
        case .p42:
            return 42
        case .p32:
            return 32
        case .p24:
            return 24
        case .p20:
            return 20
        case .p16:
            return 16
        case .p14:
            return 14
        case .p12:
            return 12
        case .p10:
            return 10
        case .p8:
            return 8
        case .p5:
            return 5
        case .p4:
            return 4
        case .p3:
            return 3
        case .p2:
            return 2
        }
    }
}

public extension Double {

    static func defaultSpacing(_ spacing: DefaultSpacing) -> Double {
        Double(CGFloat.defaultSpacing(spacing))
    }
}
