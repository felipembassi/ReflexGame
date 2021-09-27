//
//  ReflexViewModelDelegate.swift
//  ReflexGame
//
//  Created by Felipe Moreira Tarrio Bassi on 26/09/21.
//

import Foundation

protocol ReflexViewModelDelegate: AnyObject {
    func presentTimesUp(_ completion: @escaping () -> Void)
    func presentGameEnded()
    func presentCpuSelection(at indexPath: IndexPath)
    func presentCorrectAnswer(_ completion: @escaping () -> Void)
    func presentWrongAnswer(_ completion: @escaping () -> Void)
    func presentElapsedTime(_ timeInterval: String)
    func presentCpuSelectionDidFinish()
    func presentScore(_ score: Int)
    func presentResetedGame()
}
