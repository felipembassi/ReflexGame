//
//  ReflexViewModelExtension.swift
//  ReflexGame
//
//  Created by Felipe Moreira Tarrio Bassi on 27/09/21.
//

import Foundation

extension ReflexViewModel {
    var animationFactor: Double {
        return 0.3
    }
    
    func readUserInput(for indexPath: IndexPath) {
        sequencialTimer?.invalidate()
        sequencialTimer = nil
        if indexPath == flashedIndexPaths?[safe: userInputIndex ?? .zero] {
            if let unwrappedUserInputIndex = userInputIndex {
                userInputIndex = unwrappedUserInputIndex + Self.constIncrementingTurn
            }
            if userInputIndex == flashedIndexPaths?.count {
                delegate?.presentCorrectAnswer { [weak self] in
                    self?.score += self?.incrementingScore ?? Self.constIncrementingScore
                }
            }
        } else {
            delegate?.presentWrongAnswer { [weak self] in
                self?.score -= self?.incrementingScore ?? Self.constIncrementingScore
            }
        }
    }
    
    func changedState(_ state: ReflexViewModelState) {
        switch state {
        case .cpuTurn:
            cpuInputIndex = .zero
            phaseTurn += incrementingTurn
            startTurnTimer()
            flashRandonSquare()
        case .userTurn:
            userInputIndex = .zero
            startTurnTimer()
        }
    }
    
    func flashRandonSquare() {
        if let unwrappedFlashedIndexPaths = flashedIndexPaths {
            let itensFactor = Double(unwrappedFlashedIndexPaths.count) + Double(incrementingTurn) + animationFactor
            let timerInterval = turnWaitingTime.toSeconds / itensFactor
            sequencialTimer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { [unowned self] timer in
                if cpuInputIndex == flashedIndexPaths?.count ?? .zero {
                    presentCpuIndexPath()
                    timer.invalidate()
                    return
                } else {
                    if let previouslyShownIndePath = unwrappedFlashedIndexPaths[safe: cpuInputIndex ?? .zero] {
                        cpuInputIndex = (cpuInputIndex ?? .zero) + incrementingTurn
                        delegate?.presentCpuSelectionDidFinish()
                        delegate?.presentCpuSelection(at: previouslyShownIndePath)
                    }
                }
            }
        } else {
            initializeIndexPathControl()
            presentCpuIndexPath()
        }
    }
    
    private func initializeIndexPathControl() {
        flashedIndexPaths = []
    }
    
    private func presentCpuIndexPath() {
        let indexPath = creatingCpuIndexPath()
        flashedIndexPaths?.append(indexPath)
        delegate?.presentCpuSelectionDidFinish()
        delegate?.presentCpuSelection(at: indexPath)
    }
    
    private func creatingCpuIndexPath() -> IndexPath {
        let randowSection = Int.random(in: .zero..<ReflexViewDataSource.numberOfSections)
        let randowRow = Int.random(in: .zero..<ReflexViewDataSource.numberOfSections)
        return IndexPath(row: randowRow, section: randowSection)
    }
}
