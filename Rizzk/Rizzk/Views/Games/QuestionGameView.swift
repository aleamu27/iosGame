//
//  QuestionGameView.swift
//  Rizzk
//
//  Created by Alexander Amundsen on 25/06/2025.
//

import SwiftUI

struct QuestionGameView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var coordinator: GameCoordinator
    @State private var currentQuestion = "Hvem i gruppen ville mest sannsynlig blitt arrestert på en fyllefest?"
    @State private var isForEveryone = false
    @State private var selectedPlayer: String?
    @State private var selectedSips = 3
    @State private var showPlayerSelection = false
    @State private var showResult = false
    @State private var navigateToCompleted = false
    
    // Mock players - replace with real data
    @State private var players = ["Alex", "Emma", "Lars", "Sofia"]
    
    // Computed property for progress
    private var roundProgress: Double {
        guard coordinator.totalRounds > 0 else { return 0.0 }
        return Double(coordinator.currentRound) / Double(coordinator.totalRounds)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.drinkBlue, Color.blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header with round info
                VStack(spacing: 15) {
                    HStack {
                        Text("❓")
                            .font(.largeTitle)
                        Text("SPØRSMÅL")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    // Round progress
                    VStack(spacing: 10) {
                        ProgressView(value: roundProgress)
                            .progressViewStyle(LinearProgressViewStyle(tint: .drinkYellow))
                            .scaleEffect(x: 1, y: 2)
                        
                        Text("Runde \(coordinator.currentRound) av \(coordinator.totalRounds)")
                            .font(.headline)
                            .foregroundColor(.drinkYellow)
                    }
                    
                    Text("Pakke: \(coordinator.selectedGamePack?.rawValue ?? "")")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(15)
                }
                
                // Question card
                VStack(spacing: 20) {
                    Text(currentQuestion)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(20)
                    
                    // Instructions
                    VStack(spacing: 15) {
                        if isForEveryone {
                            VStack(spacing: 10) {
                                Text("📢 FOR ALLE")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.drinkYellow)
                                
                                Text("Dette spørsmålet gjelder hele gruppen!")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                                    .multilineTextAlignment(.center)
                            }
                        } else {
                            VStack(spacing: 10) {
                                Text("🎯 VELG EN SPILLER")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.drinkYellow)
                                
                                Text("Du kan velge hvem som skal svare på spørsmålet")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(15)
                }
                
                if !isForEveryone && !showResult {
                    // Player selection
                    VStack(spacing: 20) {
                        Text("Velg en spiller:")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 15) {
                            ForEach(players, id: \.self) { player in
                                Button(action: {
                                    selectedPlayer = player
                                }) {
                                    Text(player)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(selectedPlayer == player ? Color.drinkYellow : Color.white.opacity(0.2))
                                                .stroke(Color.drinkYellow, lineWidth: selectedPlayer == player ? 2 : 1)
                                        )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        
                        // Sips selector
                        VStack(spacing: 10) {
                            Text("Antal slurker:")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            HStack(spacing: 15) {
                                ForEach(1...5, id: \.self) { sips in
                                    Button(action: {
                                        selectedSips = sips
                                    }) {
                                        Text("\(sips)")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .frame(width: 50, height: 50)
                                            .background(
                                                Circle()
                                                    .fill(selectedSips == sips ? Color.drinkYellow : Color.white.opacity(0.2))
                                                    .stroke(Color.drinkYellow, lineWidth: selectedSips == sips ? 2 : 1)
                                            )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 15) {
                    if !showResult {
                        if isForEveryone {
                            Button(action: {
                                showResult = true
                            }) {
                                GameButton(title: "Alle har svart", color: .drinkYellow)
                            }
                        } else if selectedPlayer != nil {
                            Button(action: {
                                showResult = true
                            }) {
                                GameButton(
                                    title: "\(selectedPlayer!) får \(coordinator.getDrinkPrompt(sips: selectedSips))",
                                    color: .drinkYellow
                                )
                            }
                        }
                    } else {
                        VStack(spacing: 10) {
                            Text("🎉 Bra jobbet!")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.drinkYellow)
                            
                            Button(action: {
                                coordinator.nextRound()
                                if coordinator.isGameFinished {
                                    navigateToCompleted = true
                                } else {
                                    generateNewQuestion()
                                }
                            }) {
                                GameButton(
                                    title: coordinator.currentRound < coordinator.totalRounds ?
                                        "Neste runde" : "Se resultat!",
                                    color: .drinkGreen
                                )
                            }
                            
                            Button(action: {
                                coordinator.endGame()
                                dismiss()
                            }) {
                                Text("Tilbake til lobby")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(15)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            generateNewQuestion()
        }
        .navigationDestination(isPresented: $navigateToCompleted) {
            GameCompletedView()
        }
    }
    
    private func generateNewQuestion() {
        // Mock questions - replace with backend data
        let questions = [
            "Hvem i gruppen ville mest sannsynlig blitt arrestert på en fyllefest?",
            "Hvem ville overlevd lengst i en zombie-apokalypse?",
            "Hvem ville blitt den første til å gråte på en skummel film?",
            "Hvem ville mest sannsynlig blitt millionær?",
            "Hvem ville aldri klart å holde en hemmelighet?",
            "Hvem ville mest sannsynlig blitt berømt?",
            "Hvem ville overlatt hele gruppen for å redde seg selv?",
            "Hvem ville mest sannsynlig flyttet til en annen planet?",
            "Hvem ville blitt den første til å gi opp i en overlevelsessituasjon?",
            "Hvem ville mest sannsynlig startet en kult?"
        ]
        
        currentQuestion = questions.randomElement() ?? "Hvem i gruppen er mest sannsynlig til å bli berømt?"
        isForEveryone = Bool.random()
        selectedPlayer = nil
        selectedSips = 3
        showResult = false
    }
}

#Preview {
    NavigationStack {
        QuestionGameView()
    }
    .environmentObject(GameCoordinator())
}
