//
//  ReflexViewModelExtension.swift
//  ReflexGame
//
//  Created by Felipe Moreira Tarrio Bassi on 27/09/21.
//

import Foundation

extension ReflexViewModel {
    func flashRandonSquare() {
        let randowSection = Int.random(in: .zero..<ReflexViewDataSource.numberOfSections)
        let randowRow = Int.random(in: .zero..<ReflexViewDataSource.numberOfSections)
        flashedIndexPath = IndexPath(row: randowRow, section: randowSection)
    }
    
    func readUserInput(for indexPath: IndexPath) {
        turnTimer?.invalidate()
        turnTimer = nil
        if indexPath == flashedIndexPath {
            delegate?.presentCorrectAnswer { [weak self] in
                self?.score += self?.incrementingScore ?? Self.constIncrementingScore
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
            phaseTurn += incrementingTurn
            flashRandonSquare()
        case .userTurn:
            startTurnTimer()
        }
    }
}
