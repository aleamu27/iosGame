import SwiftUI

struct GameTypeCard: View {
    let gameType: GameType
    
    var body: some View {
        HStack {
            Image(systemName: gameType.icon)
                .font(.title2)
                .foregroundColor(.drinkYellow)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(gameType.rawValue)
                    .font(.headline)
                    .foregroundColor(.drinkBlue)
                
                Text(gameType.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.drinkGreen)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    GameTypeCard(gameType: .tapCompetition)
}
