//
//  PlayerNameView.swift
//  Rizzk
//
//  Created by Alexander Amundsen on 25/06/2025.
//

import SwiftUI

struct PlayerNameView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var coordinator: GameCoordinator
    @State private var playerName = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var navigateNext = false
    @FocusState private var isTextFieldFocused: Bool
    
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
                    Text("Hva heter du?")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Skriv inn navnet ditt for å fortsette")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: 20) {
                    TextField("Ditt navn", text: $playerName)
                        .font(.title2)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .focused($isTextFieldFocused)
                        .onSubmit {
                            validateAndContinue()
                        }
                    
                    if !playerName.isEmpty {
                        Text("Hei, \(playerName)! 👋")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.drinkYellow)
                            .animation(.easeInOut(duration: 0.3), value: playerName)
                    }
                }
                
                VStack(spacing: 15) {
                    Button(action: {
                        validateAndContinue()
                    }) {
                        GameButton(
                            title: "Fortsett",
                            color: playerName.isEmpty ? .gray : .drinkYellow
                        )
                    }
                    .disabled(playerName.isEmpty)
                    
                    Button(action: {
                        playerName = generateRandomName()
                    }) {
                        HStack {
                            Image(systemName: "shuffle")
                            Text("Generer tilfeldig navn")
                        }
                        .foregroundColor(.white)
                        .font(.headline)
                    }
                }
                
                Spacer()
            }
            .padding()
            
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.black.opacity(0.2))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding()
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            isTextFieldFocused = true
        }
        .alert("Ugyldig navn", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
        .navigationDestination(isPresented: $navigateNext) {
            destinationView
        }
    }
    
    @ViewBuilder
    private var destinationView: some View {
        switch coordinator.gameMode {
        case .host:
            GameHostView()
        case .join:
            WhatDoYouDrinkView()
        case .none:
            Text("Error: No game mode selected")
        }
    }
    
    private func validateAndContinue() {
        let trimmedName = playerName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.isEmpty {
            errorMessage = "Vennligst skriv inn et navn"
            showingError = true
            return
        }
        
        if trimmedName.count < 2 {
            errorMessage = "Navnet må være minst 2 tegn langt"
            showingError = true
            return
        }
        
        if trimmedName.count > 20 {
            errorMessage = "Navnet kan ikke være lengre enn 20 tegn"
            showingError = true
            return
        }
        
        // Navn er gyldig - send til coordinator og naviger
        coordinator.nameSelected(trimmedName)
        navigateNext = true
    }
    
    private func generateRandomName() -> String {
        let names = [
            "Abdi", "Baidakongen", "Sossetrynet", "Pipestilken", "Kongen", "Babe😍",
            "BabaJaan", "Twatten", "Bitch", "Quislingen", "Lakei", "Legenden",
            "Ninja", "Viking", "Alex Molteberg", "Kriger", "Beger",
        ]
        return names.randomElement() ?? "Spiller"
    }
}

#Preview {
    NavigationView {
        PlayerNameView()
    }
    .environmentObject(GameCoordinator())
}
