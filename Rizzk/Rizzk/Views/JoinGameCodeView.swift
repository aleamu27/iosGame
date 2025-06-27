//
//  JoinGameCodeView.swift
//  Rizzk
//
//  Created by Alexander Amundsen on 25/06/2025.
//

import SwiftUI

struct JoinGameCodeView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var coordinator: GameCoordinator
    @State private var gameCode = ""
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
                    Text("Skriv inn spillkode")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Få spillkoden fra hosten og skriv den inn under")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                VStack(spacing: 20) {
                    TextField("Spillkode", text: $gameCode)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .focused($isTextFieldFocused)
                        .textInputAutocapitalization(.characters)
                        .disableAutocorrection(true)
                        .multilineTextAlignment(.center)
                        .onSubmit {
                            validateAndJoin()
                        }
                        .onChange(of: gameCode) { _, newValue in
                            // Begrens til 6 tegn og store bokstaver/tall
                            gameCode = String(newValue.uppercased().prefix(6))
                        }
                    
                    if !gameCode.isEmpty {
                        Text("Kode: \(gameCode)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.drinkYellow)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                            .animation(.easeInOut(duration: 0.3), value: gameCode)
                    }
                    
                    Text("Spillkoden er vanligvis 4-6 tegn lang")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.6))
                }
                
                VStack(spacing: 15) {
                    Button(action: {
                        validateAndJoin()
                    }) {
                        GameButton(
                            title: "Bli med i spillet",
                            color: gameCode.count >= 4 ? .drinkYellow : .gray
                        )
                    }
                    .disabled(gameCode.count < 4)
                    
                    Button(action: {
                        gameCode = generateSampleCode()
                    }) {
                        HStack {
                            Image(systemName: "questionmark.circle")
                            Text("Bruk eksempel kode")
                        }
                        .foregroundColor(.white)
                        .font(.headline)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 10) {
                    Text("💡 Tips")
                        .font(.headline)
                        .foregroundColor(.drinkYellow)
                    
                    Text("Spillkoden får du fra personen som startet spillet")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(15)
            }
            .padding()
            
            // Back button
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
        .alert("Ugyldig spillkode", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
        .navigationDestination(isPresented: $navigateNext) {
            PlayerNameView()
        }
    }
    
    private func validateAndJoin() {
        let trimmedCode = gameCode.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedCode.isEmpty {
            errorMessage = "Vennligst skriv inn en spillkode"
            showingError = true
            return
        }
        
        if trimmedCode.count < 4 {
            errorMessage = "Spillkoden må være minst 4 tegn lang"
            showingError = true
            return
        }
        
        if trimmedCode.count > 6 {
            errorMessage = "Spillkoden kan ikke være lengre enn 6 tegn"
            showingError = true
            return
        }
        
        // Sjekk at koden kun inneholder bokstaver og tall
        let allowedCharacters = CharacterSet.alphanumerics
        if trimmedCode.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            errorMessage = "Spillkoden kan kun inneholde bokstaver og tall"
            showingError = true
            return
        }
        
        // Kode er gyldig - send til coordinator og naviger
        coordinator.gameCodeEntered(trimmedCode)
        navigateNext = true
    }
    
    private func generateSampleCode() -> String {
        let sampleCodes = ["RIZZK", "PARTY", "DRINK", "GAME1", "FUN23", "ANDY1"]
        return sampleCodes.randomElement() ?? "DEMO1"
    }
}

#Preview {
    NavigationStack {
        JoinGameCodeView()
    }
    .environmentObject(GameCoordinator())
}
