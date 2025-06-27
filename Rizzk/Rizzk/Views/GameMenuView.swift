import SwiftUI

struct GameMenuView: View {
    @ObservedObject var gameSession: GameSession
    
    var body: some View {
        ZStack {
            Color.drinkWhite.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Velg spill")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.drinkBlue)
                
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(GameType.allCases, id: \.self) { gameType in
                            NavigationLink(destination: gameDestination(for: gameType)) {
                                GameTypeCard(gameType: gameType)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Spill")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func gameDestination(for gameType: GameType) -> some View {
        switch gameType {
        case .tapCompetition:
            TapCompetitionView(gameSession: gameSession)
        case .colorReaction:
            ColorReactionView(gameSession: gameSession)
        case .neverHaveI:
            NeverHaveIView(gameSession: gameSession)
        case .quickQuiz:
            QuickQuizView(gameSession: gameSession)
        case .spinWheel:
            SpinWheelView(gameSession: gameSession)
        }
    }
}

#Preview {
    GameMenuView(gameSession: GameSession())
}
