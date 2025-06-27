//
//  GameCoordinator.swift
//  Rizzk
//
//  Created by Alexander Amundsen on 25/06/2025.
//

import Foundation
import SwiftUI

class GameCoordinator: ObservableObject {
    @Published var gameMode: GameMode?
    @Published var playerName: String = ""
    @Published var drinkLevel: String?
    @Published var gameCode: String = ""
    @Published var drinkType: WhatDoYouDrinkView.DrinkType?
    @Published var selectedGamePack: GamePackSelectionView.GamePack?
    @Published var currentGameType: GameType?
    @Published var currentRound: Int = 1
    @Published var totalRounds: Int = 10
    @Published var isGameActive: Bool = false
    
    enum GameType: String, CaseIterable {
        case question = "Spørsmål"
        case statement = "Påstand"
        case quiz = "Quiz"
    }
    
    func startAsHost() {
        gameMode = .host
    }
    
    func joinGame() {
        gameMode = .join
    }
    
    func nameSelected(_ name: String) {
        playerName = name
    }
    
    func drinkLevelSelected(_ level: GameHostView.DrinkLevel) {
        drinkLevel = level.rawValue
    }
    
    func gameCodeEntered(_ code: String) {
        gameCode = code
    }
    
    func drinkTypeSelected(_ type: WhatDoYouDrinkView.DrinkType) {
        drinkType = type
    }
    
    func gamePackSelected(_ pack: GamePackSelectionView.GamePack) {
        selectedGamePack = pack
    }
    
    // Start game with 10 rounds
    func startGame() {
        currentRound = 1
        totalRounds = 10
        isGameActive = true
        let _ = getRandomGameType()
    }
    
    // Go to next round
    func nextRound() {
        if currentRound < totalRounds {
            currentRound += 1
            let _ = getRandomGameType() // Get new random game type for next round
        } else {
            // Game is completed - don't end it here, let the view handle navigation
            currentRound += 1 // This will make isGameFinished return true
        }
    }
    
    // End the game
    func endGame() {
        isGameActive = false
        currentRound = 1
        currentGameType = nil
    }
    
    // Generate random game type
    func getRandomGameType() -> GameType {
        let randomType = GameType.allCases.randomElement() ?? .question
        currentGameType = randomType
        return randomType
    }
    
    // Get specific game view based on game type
    @ViewBuilder
    func getGameView() -> some View {
        switch currentGameType ?? getRandomGameType() {
        case .question:
            QuestionGameView()
        case .statement:
            StatementGameView()
        case .quiz:
            QuizGameView()
        }
    }
    
    // Helper function to start a random game (can be called from lobby)
    func startRandomGame() {
        startGame()
    }
    
    // Check if game is finished
    var isGameFinished: Bool {
        return currentRound > totalRounds
    }
    
    // Get progress as percentage
    var gameProgress: Double {
        guard totalRounds > 0 else { return 0.0 }
        return Double(currentRound) / Double(totalRounds)
    }
    
    // Helper function to get drink text for game prompts
    func getDrinkPrompt(sips: Int) -> String {
        guard let drinkType = drinkType else { return "\(sips) slurker" }
        
        let adjustedSips = sips * drinkType.sipMultiplier
        let drinkText = adjustedSips == 1 ? String(drinkType.drinkText.dropLast()) : drinkType.drinkText
        
        return "\(adjustedSips) \(drinkText)"
    }
    
    // Helper property to check if user should go to host or join flow
    var shouldNavigateToHost: Bool {
        return gameMode == .host
    }
    
    var shouldNavigateToJoin: Bool {
        return gameMode == .join
    }
}
