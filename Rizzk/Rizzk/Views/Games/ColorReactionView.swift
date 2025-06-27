import SwiftUI

struct ColorReactionView: View {
    @ObservedObject var gameSession: GameSession
    @State private var currentColor: Color = .drinkYellow
    @State private var targetColor: Color = .drinkPink
    @State private var gameActive = false
    @State private var scores: [String: Int] = [:]
    
    let colors: [Color] = [.drinkYellow, .drinkPink, .drinkBlue, .drinkGreen]
    
    var body: some View {
        ZStack {
            currentColor.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("FARGEREAKSJON")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                if gameActive {
                    Text("Tapp når fargen matcher!")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("Mål: \(colorName(targetColor))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                ForEach(gameSession.players, id: \.id) { player in
                    VStack {
                        Text(player.name)
                            .foregroundColor(.white)
                            .font(.headline)
                        
                        Text("\(scores[player.id] ?? 0) poeng")
                            .foregroundColor(.white)
                            .font(.title3)
                        
                        Button(action: {
                            playerTapped(player.id)
                        }) {
                            Circle()
                                .fill(Color.white.opacity(0.3))
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Text("TAP")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                )
                        }
                    }
                }
                
                if !gameActive {
                    Button(action: startGame) {
                        GameButton(title: "Start spill", color: .white)
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func startGame() {
        gameActive = true
        scores.removeAll()
        changeColor()
    }
    
    private func changeColor() {
        guard gameActive else { return }
        
        currentColor = colors.randomElement() ?? .drinkYellow
        targetColor = colors.randomElement() ?? .drinkPink
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 1...3)) {
            changeColor()
        }
    }
    
    private func playerTapped(_ playerId: String) {
        guard gameActive else { return }
        
        if currentColor == targetColor {
            scores[playerId, default: 0] += 1
        } else {
            scores[playerId, default: 0] -= 1
        }
    }
    
    private func colorName(_ color: Color) -> String {
        switch color {
        case .drinkYellow: return "Gul"
        case .drinkPink: return "Rosa"
        case .drinkBlue: return "Blå"
        case .drinkGreen: return "Grønn"
        default: return "Ukjent"
        }
    }
}

#Preview {
    ColorReactionView(gameSession: GameSession())
}
