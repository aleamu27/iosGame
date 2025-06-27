//
//  GameCompletedView.swift
//  Rizzk
//
//  Created by Alexander Amundsen on 25/06/2025.
//

import SwiftUI

struct GameCompletedView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var coordinator: GameCoordinator
    @State private var playAgain = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.drinkBlue, Color.drinkGreen],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                VStack(spacing: 20) {
                    Text("🎉")
                        .font(.system(size: 80))
                    
                    Text("SPILL FERDIG!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.drinkYellow)
                    
                    Text("Gratulerer! Dere fullførte 10 runder!")
                        .font(.title2)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: 20) {
                    Text("Spillpakke:")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    if let selectedPack = coordinator.selectedGamePack {
                        HStack {
                            Text(selectedPack.icon)
                                .font(.title)
                            Text(selectedPack.rawValue)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.drinkYellow)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(20)
                    }
                    
                    Text("Drikketype: \(coordinator.drinkType?.rawValue ?? "Ikke valgt")")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(20)
                
                VStack(spacing: 15) {
                    Text("Hva vil dere gjøre nå?")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text("Vil dere spille en ny runde eller gå tilbake til lobbyen?")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                VStack(spacing: 20) {
                    Button(action: {
                        coordinator.startGame()
                        playAgain = true
                    }) {
                        GameButton(
                            title: "🎮 Spill igjen (10 nye runder)",
                            color: .drinkYellow
                        )
                    }
                    
                    Button(action: {
                        coordinator.endGame()
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "house.fill")
                            Text("Tilbake til lobby")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(15)
                    }
                    
                    Button(action: {
                        // TODO: Legg til logikk for å bytte spillpakke
                        coordinator.endGame()
                        // Navigate to pack selection
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "arrow.triangle.2.circlepath")
                            Text("Bytt spillpakke")
                        }
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.vertical, 8)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 10) {
                    Text("💡 Tips")
                        .font(.headline)
                        .foregroundColor(.drinkYellow)
                    
                    Text("Prøv en annen spillpakke for helt nye utfordringer!")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(15)
            }
            .padding()
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(isPresented: $playAgain) {
            coordinator.getGameView()
        }
    }
}

#Preview {
    NavigationStack {
        GameCompletedView()
    }
    .environmentObject(GameCoordinator())
}
