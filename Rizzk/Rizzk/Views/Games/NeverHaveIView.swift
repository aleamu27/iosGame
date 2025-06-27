import SwiftUI

struct NeverHaveIView: View {
    @ObservedObject var gameSession: GameSession
    @State private var currentStatement = ""
    @State private var statements = [
        "Aldri har jeg løpt naken",
        "Aldri har jeg sovnet på en fest",
        "Aldri har jeg kysset noen av samme kjønn",
        "Aldri har jeg drukket alene",
        "Aldri har jeg sendt en melding til feil person"
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.drinkPink, Color.drinkBlue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("ALDRI HAR JEG")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(currentStatement)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(15)
                
                VStack(spacing: 15) {
                    Text("Hvis du har gjort dette, drink!")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    ForEach(gameSession.players, id: \.id) { player in
                        Button(action: {
                            // Player admits to doing this
                        }) {
                            Text("\(player.name) drikker 🍺")
                                .font(.headline)
                                .foregroundColor(.drinkYellow)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                }
                
                Button(action: nextStatement) {
                    GameButton(title: "Neste utfordring", color: .drinkGreen)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            currentStatement = statements.randomElement() ?? ""
        }
    }
    
    private func nextStatement() {
        currentStatement = statements.randomElement() ?? ""
    }
}

#Preview {
    NeverHaveIView(gameSession: GameSession())
}
