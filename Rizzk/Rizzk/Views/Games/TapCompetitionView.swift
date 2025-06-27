import SwiftUI

struct TapCompetitionView: View {
    @ObservedObject var gameSession: GameSession
    @State private var tapCounts: [String: Int] = [:]
    @State private var gameActive = false
    @State private var timeRemaining = 10
    @State private var timer: Timer?
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.drinkYellow, Color.drinkPink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("TAPP-KONKURRANSE")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("\(timeRemaining)")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.white)
                
                if gameActive {
                    Text("TAPP SÅ RASKT DU KAN!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                
                ForEach(gameSession.players, id: \.id) { player in
                    VStack {
                        Text(player.name)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("\(tapCounts[player.id] ?? 0) taps")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Button(action: {
                            if gameActive {
                                tapCounts[player.id, default: 0] += 1
                            }
                        }) {
                            Circle()
                                .fill(Color.white.opacity(0.3))
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Text("TAP")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                )
                        }
                        .disabled(!gameActive)
                    }
                }
                
                if !gameActive {
                    Button(action: startGame) {
                        GameButton(title: "Start spill", color: .drinkGreen)
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func startGame() {
        tapCounts.removeAll()
        gameActive = true
        timeRemaining = 10
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            timeRemaining -= 1
            if timeRemaining <= 0 {
                endGame()
            }
        }
    }
    
    private func endGame() {
        gameActive = false
        timer?.invalidate()
        
        // Find winner
        let winner = tapCounts.max { $0.value < $1.value }
        // Show winner somehow
    }
}

#Preview {
    TapCompetitionView(gameSession: GameSession())
}
