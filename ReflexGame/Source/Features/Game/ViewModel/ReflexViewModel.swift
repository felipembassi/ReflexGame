//
//  ReflexViewModel.swift
//  ReflexGame
//
//  Created by Felipe Moreira Tarrio Bassi on 25/09/21.
//

import Foundation

enum ReflexViewModelState {
    case userTurn
    case cpuTurn
}

class ReflexViewModel: ReflexViewModelProtocol {
    static let constMultiplyFactor = 0.9
    static let constStartWaitingTime: Double = 3.000
    static let constIncrementingScore = 1
    static let constIncrementingTurn = 1
    static let constEndGameScoreFactor = 0
    static let constPhaseTurnFactor = 5
    static let constInitialScore = 1
    static let constInitialTurn = 1
    static let constElapsedTimeInterval: Int = 1
    static let constElapsedTimeInitialValue: Int = 1
    
    weak var delegate: ReflexViewModelDelegate?
    
    var multiplyFactor: Double {
        Self.constMultiplyFactor
    }
    
    var incrementingScore: Int {
        Self.constIncrementingScore
    }
    
    var incrementingTurn: Int {
        Self.constIncrementingTurn
    }
    
    var endGameScoreFactor: Int {
        Self.constEndGameScoreFactor
    }
    
    var phaseTurnFactor: Int {
        Self.constPhaseTurnFactor
    }
    
    var turnWaitingTime: Double = constStartWaitingTime
    
    var phaseTurn: Int = constInitialTurn {
        didSet {
            decreaseUserInputTimerIfNeeded()
        }
    }
    
    var state: ReflexViewModelState = .cpuTurn {
        didSet {
            changedState(state)
        }
    }
    
    var score: Int = constInitialScore {
        didSet {
            computeUserScore()
        }
    }
    
    var flashedIndexPath: IndexPath? {
        didSet {
            guard let unwrappedFlashedIndexPath = flashedIndexPath else { return }
            delegate?.presentCpuSelection(at: unwrappedFlashedIndexPath)
            startTurnTimer()
        }
    }
    
    var turnTimer: Timer?
    var elapsedGameTimeTimer: Timer?
    var elapsedGameTimeInSeconds: Int?
    var userInputIndex: Int? = .zero
    var cpuInputIndex: Int? = .zero
    var flashedIndexPaths: [IndexPath]?
    var sequencialTimer: Timer?
    
    func startGame() {
        resetPreviousGame()
        delegate?.presentElapsedTime(String.timeString(time: TimeInterval(Self.constElapsedTimeInitialValue)))
        elapsedGameTimeTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(Self.constElapsedTimeInterval), repeats: true) { [unowned self] _ in
            guard let unwrappedElapsedGameTimeInSeconds = elapsedGameTimeInSeconds else { return }
            elapsedGameTimeInSeconds = unwrappedElapsedGameTimeInSeconds + Self.constElapsedTimeInterval
            delegate?.presentElapsedTime(String.timeString(time: TimeInterval(elapsedGameTimeInSeconds ?? .zero)))
        }
    }
    
    func computeUserScore() {
        delegate?.presentScore(score)
        if score <= endGameScoreFactor {
            showGameEnded()
        } else {
            turnTimer?.invalidate()
            turnTimer = nil
            state = .cpuTurn
        }
    }
    
    func decreaseUserInputTimerIfNeeded() {
        if phaseTurn % phaseTurnFactor == .zero {
            turnWaitingTime *= multiplyFactor
        }
    }
    
    func showGameEnded() {
        turnTimer?.invalidate()
        turnTimer = nil
        elapsedGameTimeTimer?.invalidate()
        elapsedGameTimeTimer = nil
        delegate?.presentGameEnded()
    }
    
    func startTurnTimer() {
        turnTimer = Timer.scheduledTimer(withTimeInterval: turnWaitingTime.toSeconds, repeats: false) { [unowned self] _ in
            switch state {
            case .userTurn:
                delegate?.presentTimesUp { [unowned self] in
                    turnTimer?.invalidate()
                    turnTimer = nil
                    score -= incrementingScore
                }
            case .cpuTurn:
                delegate?.presentCpuSelectionDidFinish()
                turnTimer?.invalidate()
                turnTimer = nil
                state = .userTurn
            }
        }
    }
    
    private func resetPreviousGame() {
        flashedIndexPaths = nil
        delegate?.presentResetedGame()
        phaseTurn = Self.constInitialTurn
        score = Self.constInitialScore
        turnWaitingTime = Self.constStartWaitingTime
        elapsedGameTimeInSeconds = Self.constElapsedTimeInitialValue
    }
}
