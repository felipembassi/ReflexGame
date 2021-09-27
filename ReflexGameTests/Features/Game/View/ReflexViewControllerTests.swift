//
//  ReflexViewControllerTests.swift
//  ReflexGameTests
//
//  Created by Felipe Moreira Tarrio Bassi on 27/09/21.
//

import Foundation
import FBSnapshotTestCase
import XCTest
@testable import ReflexGame

class ReflexViewControllerTests: ReflexBaseTests {
    var controller: ReflexViewController?
    var delegateSpy: ReflexViewModelDelegateSpy = ReflexViewModelDelegateSpy()
    
    override func setUp() {
        super.setUp()
//        recordMode = true
        controller = setupViewController()
        delegateSpy = ReflexViewModelDelegateSpy()
        guard let unwrappedController = controller else { return }
        addControllerToWindow(unwrappedController)
        controller?.viewModel.delegate = delegateSpy
    }
    
    func testScreen() {
        verifySnapshotView(delay: 1) { [unowned self] in self.controller?.view }
    }
    
    func testFailureScreenFromInactivityAfterDelay() {
        controller?.viewModel.startGame()
        verifySnapshotView(delay: 7) { [unowned self] in self.controller?.view }
    }
    
    func testUserSelectingRightSpotScoreIncreaseThenTimeExpireThenSelectIncorrectSpotThenLoseGame() {
        controller?.viewModel.startGame()
        
        guard let unwrappedFlashedIndexPath = controller?.viewModel.flashedIndexPath else { return }
        controller?.viewModel.readUserInput(for: unwrappedFlashedIndexPath)
        XCTAssertTrue(delegateSpy.presentCorrectAnswerCalled)
        XCTAssertEqual(controller?.viewModel.score, 2)
        XCTAssertTrue(delegateSpy.presentScoreCalled)
        XCTAssertEqual(controller?.viewModel.state, .cpuTurn)
        XCTAssertEqual(controller?.viewModel.phaseTurn, 3)
        XCTAssertTrue(delegateSpy.presentCpuSelectionCalled)
        sleepTest(for: controller?.viewModel.turnWaitingTime ?? 3)
        XCTAssertEqual(controller?.viewModel.state, .userTurn)
        XCTAssertNotNil(controller?.viewModel.turnTimer)
        sleepTest(for: controller?.viewModel.turnWaitingTime ?? 3)
        XCTAssertTrue(delegateSpy.presentTimesUpCalled)
        sleepTest(for: 1)
        XCTAssertEqual(controller?.viewModel.score, 1)
        XCTAssertTrue(delegateSpy.presentScoreCalled)
        XCTAssertEqual(controller?.viewModel.state, .cpuTurn)
        XCTAssertEqual(controller?.viewModel.phaseTurn, 4)
        XCTAssertTrue(delegateSpy.presentCpuSelectionCalled)
        controller?.viewModel.readUserInput(for: unwrappedFlashedIndexPath)
        XCTAssertTrue(delegateSpy.presentWrongAnswerCalled)
        XCTAssertEqual(controller?.viewModel.score, 0)
        XCTAssertTrue(delegateSpy.presentScoreCalled)
        XCTAssertTrue(delegateSpy.presentGameEndedCalled)
    }
    
    // MARK: - Private methods
    
    private func setupViewController() -> ReflexViewController {
        let controller = ReflexViewController()
        return controller
    }
}

class ReflexViewModelDelegateSpy: ReflexViewModelDelegate {
    var presentTimesUpCalled = false
    func presentTimesUp(_ completion: @escaping () -> Void) {
        presentTimesUpCalled = true
        completion()
    }
    
    var presentGameEndedCalled = false
    func presentGameEnded() {
        presentGameEndedCalled = true
    }
    
    var presentCpuSelectionCalled = false
    func presentCpuSelection(at indexPath: IndexPath) {
        presentCpuSelectionCalled = true
    }
    
    var presentCorrectAnswerCalled = false
    func presentCorrectAnswer(_ completion: @escaping () -> Void) {
        presentCorrectAnswerCalled = true
        completion()
    }
    
    var presentWrongAnswerCalled = false
    func presentWrongAnswer(_ completion: @escaping () -> Void) {
        presentWrongAnswerCalled = true
        completion()
    }
    
    var presentElapsedTimeCalled = false
    func presentElapsedTime(_ timeInterval: String) {
        presentElapsedTimeCalled = true
    }
    
    var presentCpuSelectionDidFinishCalled = false
    func presentCpuSelectionDidFinish() {
        presentCpuSelectionDidFinishCalled = true
    }
    
    var presentScoreCalled = false
    func presentScore(_ score: Int) {
        presentScoreCalled = true
    }
    
    var presentResetedGameCalled = false
    func presentResetedGame() {
        presentResetedGameCalled = true
    }
    
    
}
