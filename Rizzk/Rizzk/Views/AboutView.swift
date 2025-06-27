import SwiftUI

struct AboutView: View {
    var body: some View {
        ZStack {
            Color.drinkWhite.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Om Rizzk")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.drinkBlue)
                
                Text("En morsom og interaktiv app for festspill og sosiale sammenkomster.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Spilltyper:")
                        .font(.headline)
                        .foregroundColor(.drinkBlue)
                    
                    ForEach(GameType.allCases, id: \.self) { gameType in
                        HStack {
                            Image(systemName: gameType.icon)
                                .foregroundColor(.drinkGreen)
                            Text(gameType.rawValue)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Spacer()
                
                Text("Versjon 1.0")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .navigationTitle("Om appen")
    }
}

#Preview {
    AboutView()
}
