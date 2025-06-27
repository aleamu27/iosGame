import SwiftUI

struct QuickQuizView: View {
    @ObservedObject var gameSession: GameSession
    @State private var currentQuestion = ""
    @State private var currentAnswer = ""
    @State private var playerAnswers: [String] = []
    @State private var showingAnswer = false
    
    let questions = [
        ("Hovedstaden i Norge?", "Oslo"),
        ("Hvor mange bein har en edderkopp?", "8"),
        ("Hvilket år landet mennesket på månen?", "1969"),
        ("Hva er det største dyret i verden?", "Blåhval"),
        ("Hvor mange strenger har en gitar?", "6")
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.drinkBlue, Color.drinkGreen],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("HURTIGQUIZ")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(currentQuestion)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(15)
                
                if showingAnswer {
                    Text("Svar: \(currentAnswer)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.drinkYellow)
                        .padding()
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(10)
                }
                
                if !showingAnswer {
                    Text("Første som svarer riktig vinner!")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                ForEach(gameSession.players, id: \.id) { player in
                    Button(action: {
                        // Player buzzed in
                        showingAnswer = true
                    }) {
                        Text("\(player.name) - Buzz!")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.drinkYellow.opacity(0.8))
                            .cornerRadius(10)
                    }
                    .disabled(showingAnswer)
                }
                
                Button(action: nextQuestion) {
                    GameButton(title: showingAnswer ? "Neste spørsmål" : "Vis svar", color: .drinkPink)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadRandomQuestion()
        }
    }
    
    private func loadRandomQuestion() {
        let question = questions.randomElement() ?? ("Test", "Test")
        currentQuestion = question.0
        currentAnswer = question.1
        showingAnswer = false
    }
    
    private func nextQuestion() {
        if showingAnswer {
            loadRandomQuestion()
        } else {
            showingAnswer = true
        }
    }
}

#Preview {
    QuickQuizView(gameSession: GameSession())
}
