//
//  GameViewModel.swift
//  Roll Strike
//
//  Created by Ehab Saifan on 3/5/25.
//

import SwiftUI

class GameViewModel: ObservableObject {
    private var gameService: GameServiceProtocol
    private var contentProvider: GameContentProvider
    private var physicsService: PhysicsServiceProtocol
    private var cellEffect: CellEffect
        
    @Published var rows: [GameRowProtocol] = []
    @Published var currentPlayer: Player
    @Published var winner: Player?
    @Published var player1: Player
    @Published var player2: Player
    @Published var gameMode: GameMode
    // For example, we add a property to track ball position (if needed)
    @Published var ballPosition: CGPoint = .zero
    // For robust collision detection using screen coordinates (if desired)
    @Published var rowFrames: [Int: CGRect] = [:]
    
    let gameScene: GameScene
    let rowHeight: CGFloat = 70  // Used to calculate landing row
    let ballSize: CGFloat = 40  // must match GameScene.ballSize
    
    init(gameService: GameServiceProtocol,
         physicsService: PhysicsServiceProtocol,
         contentProvider: GameContentProvider,
         gameScene: GameScene,
         gameMode: GameMode,
         player1: Player,
         player2: Player,
         cellEffect: CellEffect) {
        self.gameService = gameService
        self.physicsService = physicsService
        self.contentProvider = contentProvider
        self.gameScene = gameScene
        self.gameMode = gameMode
        self.player1 = player1
        currentPlayer = player1
        self.player2 = player2
        self.cellEffect = cellEffect
        rows = []
    }
    
    func startGame(with targets: [GameContent]) {
        gameService.startGame(with: targets, cellEffect: cellEffect)
        rows = gameService.rows
    }
    
    // Robust, screen-based collision detection approach:
    // Here, we assume that the board's row frames have been captured via a PreferenceKey in the view.
    private func getRowAtBallPosition(finalPosition: CGPoint) -> Int? {
        let sortedRowFrames = rowFrames.sorted(by: { $0.key > $1.key }) // Ensure rows are in order
        
        let ballCenterY = UIScreen.main.bounds.maxY - finalPosition.y
        let ballLowerEdge = ballCenterY + ballSize/2
        let ballUpperEdge = ballCenterY - ballSize/2
        print("@@ ballUpperEdge: \(ballUpperEdge) | ballCenterY: \(ballCenterY) | ballLowerEdge: \(ballLowerEdge)")
        
        for (index, rowFrame) in sortedRowFrames {
            print("@@ index: \(index) -> \(rowFrame.minY) - \(rowFrame.maxY)")
            if (ballCenterY >= rowFrame.minY) && (ballCenterY <= rowFrame.maxY) {
                return index
            }
        }
        
        print("@@ No valid row detected for y: \(finalPosition.y)")
        return nil
    }
    
    func rollBall() {
        print("@@ Now \(currentPlayer) is rolling the ball...")
        let maxY = UIScreen.main.bounds.maxY
        physicsService.rollBallWithRandomPosition(maxY: maxY) { [weak self] finalPosition in
            guard let self = self else { return }
            
            // Option 1: Use robust collision detection via row frames if available:
            if let rowIndex = self.getRowAtBallPosition(finalPosition: finalPosition) {
                print("@@ Ball hit row: \(rowIndex)")
                let player: GameService.PlayerType = self.currentPlayer == self.player1 ? .player1 : .player2
                self.gameService.markCell(at: rowIndex, forPlayer: player)
                self.rows = self.gameService.rows
                physicsService.resetBall()
                switch self.gameService.checkForWinner() {
                case .player1:
                    self.winner = player1
                case .player2:
                    self.winner = player2
                case .none:
                    break
                }
            }
            
            if self.winner == nil {
                self.toggleTurn()
            }
        }
    }
    
    private func toggleTurn() {
        physicsService.resetBall()
        if gameMode == .singlePlayer && currentPlayer != .computer {
            currentPlayer = .computer
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.computerMove()
            }
        } else {
            currentPlayer = (currentPlayer == player1) ? player2 : player1
            print("@@ Current Player now: \(currentPlayer.name)")
        }
    }
    
    private func computerMove() {
        rollBall()
    }
    
    func checkForWinner() {
        let playerOneScore = rows.filter { $0.rightMarking == .complete }.count
        let playerTwoScore = rows.filter { $0.leftMarking == .complete }.count
        
        if playerOneScore == rows.count {
            winner = player1
        } else if playerTwoScore == rows.count {
            winner = player2
        }
    }
    
    func getContent(for index: Int) -> GameContent {
       // print("@@ returning \(contentProvider.getContent(for: index))")
        return contentProvider.getContent(for: index)
    }
    
    func reset() {
        print("@@ reset")
        gameService.reset()
        rows = gameService.rows
        currentPlayer = player1
        print("@@ Current Player now: \(currentPlayer.name)")
        winner = nil
        physicsService.resetBall()
    }
}
