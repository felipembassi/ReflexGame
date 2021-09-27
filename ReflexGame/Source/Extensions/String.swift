//
//  Strings.swift
//  ReflexGame
//
//  Created by Felipe Moreira Tarrio Bassi on 25/09/21.
//

import Foundation

public enum LocalizableBundle: String {
    
    // MARK: - Texts
    case reflexGameScreenTitle
    case reflexGameSequencialModeScreenTitle
    case reflexGameButtonTittleStart
    case reflexGameLabelElapsedTimeStartingValue
    case reflexGameScoreValue
    
    // MARK: - Computed properties
    var localized: String {
        return rawValue.localize()
    }
}

extension String {
    /// Method responsable for transform time interval into string
    /// - Parameter time: The time interval you want to show as a formated string
    /// - Returns: String with a time format
    static func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    /// Method responsable for returning the string on Localizable strings file
    /// - Returns: Localizable String
    func localize() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: Bundle.main, value: "", comment: "")
    }
}
