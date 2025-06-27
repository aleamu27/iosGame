import SwiftUI

struct StartGameView: View {
    @EnvironmentObject var coordinator: GameCoordinator
    @State private var navigateToPlayerName = false
    @State private var navigateNext = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.drinkBlue, Color.drinkGreen],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                VStack(spacing: 10) {
                    Text("RIZZK")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.drinkYellow)
                    
                    Text("Andy min Andy")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .tracking(2)
                }
                
                VStack(spacing: 20) {
                    Button(action: {
                        coordinator.startAsHost()
                        navigateNext = true
                    }) {
                        GameButton(title: "START SPILL", color: .drinkYellow)
                    }
                    
                    Button(action: {
                        coordinator.joinGame()
                        navigateNext = true
                    }) {
                        GameButton(title: "JOIN SPILL", color: .drinkPink)
                    }
                    
                    NavigationLink(destination: AboutView()) {
                        HStack {
                            Image(systemName: "info.circle")
                            Text("Om appen")
                        }
                        .foregroundColor(.white)
                        .font(.headline)
                    }
                }
                
                Spacer()
                
                Text("Samle vennene og start festen! 🎉")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(isPresented: $navigateNext) {
            destinationView
        }
    }
    
    @ViewBuilder
    private var destinationView: some View {
        switch coordinator.gameMode {
        case .host:
            GamePackSelectionView()
        case .join:
            JoinGameCodeView()
        default:
            Text("Error")
        }
    }
}

#Preview {
    NavigationStack {
        StartGameView()
    }
    .environmentObject(GameCoordinator())
}
