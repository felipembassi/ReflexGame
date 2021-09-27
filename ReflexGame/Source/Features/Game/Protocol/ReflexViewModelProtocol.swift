//
//  ReflexViewModelProtocol.swift
//  ReflexGame
//
//  Created by Felipe Moreira Tarrio Bassi on 25/09/21.
//

import Foundation

protocol ReflexViewModelProtocol: AnyObject {
    var delegate: ReflexViewModelDelegate? { get set }
    var multiplyFactor: Double { get }
    var incrementingScore: Int { get }
    var incrementingTurn: Int { get }
    var endGameScoreFactor: Int { get }
    var phaseTurnFactor: Int { get }
    var turnWaitingTime: Double { get set }
    var phaseTurn: Int { get set }
    var state: ReflexViewModelState { get set }
    var score: Int { get set }
    var flashedIndexPath: IndexPath? { get set }
    var turnTimer: Timer? { get set }
    var elapsedGameTimeTimer: Timer? { get set }
    var elapsedGameTimeInSeconds: Int? { get set }
    var userInputIndex: Int? { get set }
    var cpuInputIndex: Int? { get set }
    var flashedIndexPaths: [IndexPath]? { get set }
    var sequencialTimer: Timer? { get set }
    
    func startGame()
    func flashRandonSquare()
    func readUserInput(for indexPath: IndexPath)
    func computeUserScore()
    func decreaseUserInputTimerIfNeeded()
    func showGameEnded()
    func startTurnTimer()
    func changedState(_ state: ReflexViewModelState)
}
