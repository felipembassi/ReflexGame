//
//  CGFloat.swift
//  ReflexGame
//
//  Created by Felipe Moreira Tarrio Bassi on 25/09/21.
//

import UIKit

// MARK: - Spacing enumeration

public enum Size: CGFloat {
    case nano = 4.0
    case extraSmall = 8.0
    case small = 16.0
    case medium = 24.0
    case big = 32.0
    case xBig = 40.0
    case large = 48.0
    case xLarge = 56.0
}

// MARK: - CGFloat extension

public extension CGFloat {
    // MARK: - Spacings

    /// Method responsible for get a default spacing
    /// - Parameter size: Spacing size
    static func spacing(_ size: Size) -> CGFloat {
        return size.rawValue
    }

    /// Method responsible for get a default size
    /// - Parameter size: Spacing size
    static func size(_ size: Size) -> CGFloat {
        return size.rawValue
    }
}
