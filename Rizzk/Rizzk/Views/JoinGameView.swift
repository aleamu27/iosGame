import SwiftUI

struct JoinGameView: View {
    @ObservedObject var gameSession: GameSession
    @State private var playerName = ""
    @State private var showingNameAlert = false
    
    let initialPlayerName: String
    
    init(gameSession: GameSession = GameSession(), initialPlayerName: String = "") {
        self.gameSession = gameSession
        self.initialPlayerName = initialPlayerName
    }
    
    var body: some View {
        ZStack {
            Color.drinkWhite.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Spillere")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.drinkBlue)
                
                // Player list
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(Array(gameSession.players.enumerated()), id: \.element.id) { index, player in
                            PlayerRow(player: player) {
                                gameSession.removePlayer(at: index)
                            }
                        }
                    }
                }
                .frame(maxHeight: 300)
                
                // Add player section
                VStack(spacing: 15) {
                    HStack {
                        TextField("Spillernavn", text: $playerName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: addCurrentPlayer) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.drinkGreen)
                        }
                        .disabled(playerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    
                    Button(action: {
                        showingNameAlert = true
                    }) {
                        HStack {
                            Image(systemName: "person.badge.plus")
                            Text("Legg til flere spillere")
                        }
                        .foregroundColor(.drinkBlue)
                        .font(.headline)
                    }
                }
                
                Spacer()
                
                // Continue button
                if !gameSession.players.isEmpty {
                    NavigationLink(destination: GameMenuView(gameSession: gameSession)) {
                        GameButton(title: "Start spill (\(gameSession.players.count) spillere)", color: .drinkBlue)
                    }
                }
            }
            .padding()
        }
        .alert("Legg til spiller", isPresented: $showingNameAlert) {
            TextField("Navn", text: $playerName)
            Button("Avbryt", role: .cancel) { }
            Button("Legg til") {
                addCurrentPlayer()
            }
        }
        .navigationTitle("Spillere")
        .onAppear {
            if !initialPlayerName.isEmpty && gameSession.players.isEmpty {
                gameSession.addPlayer(name: initialPlayerName)
                playerName = ""
            } else {
                playerName = initialPlayerName
            }
        }
    }
    
    private func addCurrentPlayer() {
        let trimmedName = playerName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedName.isEmpty {
            // Check if player already exists
            if !gameSession.players.contains(where: { $0.name.lowercased() == trimmedName.lowercased() }) {
                gameSession.addPlayer(name: trimmedName)
                playerName = ""
            }
        }
    }
}

#Preview {
    JoinGameView(gameSession: GameSession(), initialPlayerName: "TestSpiller")
}
