//
//  QuizGameView.swift
//  Rizzk
//
//  Created by Alexander Amundsen on 25/06/2025.
//

import SwiftUI

struct QuizQuestion {
    let question: String
    let options: [String]
    let correctAnswer: String
}

struct QuizGameView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var coordinator: GameCoordinator
    @State private var currentQuestionIndex = 0
    @State private var wrongAnswers = 0
    @State private var selectedAnswer: String?
    @State private var showResult = false
    @State private var timeRemaining = 10
    @State private var timer: Timer?
    @State private var quizFinished = false
    @State private var navigateToCompleted = false
    
    @State private var questions: [QuizQuestion] = [
        QuizQuestion(
            question: "Hvor mange kontinenter er det i verden?",
            options: ["5", "6", "7", "8"],
            correctAnswer: "7"
        ),
        QuizQuestion(
            question: "Hva er hovedstaden i Australia?",
            options: ["Sydney", "Melbourne", "Canberra", "Brisbane"],
            correctAnswer: "Canberra"
        ),
        QuizQuestion(
            question: "Hvilket år ble Berlin-muren revet ned?",
            options: ["1987", "1989", "1991", "1993"],
            correctAnswer: "1989"
        )
    ]
    
    // Computed property for progress
    private var roundProgress: Double {
        guard coordinator.totalRounds > 0 else { return 0.0 }
        return Double(coordinator.currentRound) / Double(coordinator.totalRounds)
    }
    
    var currentQuestion: QuizQuestion {
        guard currentQuestionIndex < questions.count else {
            return QuizQuestion(question: "", options: [], correctAnswer: "")
        }
        return questions[currentQuestionIndex]
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.drinkYellow, Color.orange],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header with round info
                VStack(spacing: 15) {
                    HStack {
                        Text("🧠")
                            .font(.largeTitle)
                        Text("QUIZ")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    // Round progress
                    VStack(spacing: 10) {
                        ProgressView(value: roundProgress)
                            .progressViewStyle(LinearProgressViewStyle(tint: .white))
                            .scaleEffect(x: 1, y: 2)
                        
                        Text("Runde \(coordinator.currentRound) av \(coordinator.totalRounds)")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Text("Pakke: \(coordinator.selectedGamePack?.rawValue ?? "")")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("Spørsmål \(currentQuestionIndex + 1)/3")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(15)
                }
                
                if !quizFinished {
                    // Timer
                    VStack(spacing: 10) {
                        Text("⏱️ \(timeRemaining)")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(.white)
                        
                        ProgressView(value: Double(timeRemaining), total: 10)
                            .progressViewStyle(LinearProgressViewStyle(tint: .white))
                            .scaleEffect(x: 1, y: 2, anchor: .center)
                    }
                    
                    // Question
                    VStack(spacing: 25) {
                        Text(currentQuestion.question)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(20)
                        
                        // Answer options
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 15) {
                            ForEach(currentQuestion.options, id: \.self) { option in
                                Button(action: {
                                    selectAnswer(option)
                                }) {
                                    Text(option)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(selectedAnswer == option ? Color.drinkBlue : Color.white.opacity(0.2))
                                                .stroke(Color.white, lineWidth: selectedAnswer == option ? 2 : 1)
                                        )
                                }
                                .buttonStyle(PlainButtonStyle())
                                .disabled(selectedAnswer != nil)
                            }
                        }
                    }
                } else {
                    // Final results
                    VStack(spacing: 25) {
                        Text("🏁 QUIZ FERDIG!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        VStack(spacing: 15) {
                            Text("Du fikk \(wrongAnswers) feil")
                                .font(.title2)
                                .foregroundColor(.white)
                            
                            if wrongAnswers > 0 {
                                Text("Du må drikke \(coordinator.getDrinkPrompt(sips: wrongAnswers))")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.drinkYellow)
                                    .padding()
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(15)
                            } else {
                                Text("🎉 Perfekt! Ingen slurker!")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.drinkGreen)
                                    .padding()
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(15)
                            }
                        }
                    }
                }
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 15) {
                    if quizFinished {
                        VStack(spacing: 10) {
                            Button(action: {
                                coordinator.nextRound()
                                if coordinator.isGameFinished {
                                    navigateToCompleted = true
                                } else {
                                    resetQuiz()
                                }
                            }) {
                                GameButton(
                                    title: coordinator.currentRound < coordinator.totalRounds ?
                                        "Neste runde" : "Se resultat!",
                                    color: .drinkGreen
                                )
                            }
                            
                            Button(action: {
                                coordinator.endGame()
                                dismiss()
                            }) {
                                Text("Tilbake til lobby")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(15)
                            }
                        }
                    } else if showResult {
                        Button(action: {
                            nextQuestion()
                        }) {
                            GameButton(
                                title: currentQuestionIndex < 2 ? "Neste spørsmål" : "Se resultat",
                                color: .drinkGreen
                            )
                        }
                    }
                }
            }
            .padding()
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
        .navigationDestination(isPresented: $navigateToCompleted) {
            GameCompletedView()
        }
    }
    
    private func selectAnswer(_ answer: String) {
        selectedAnswer = answer
        timer?.invalidate()
        
        if answer != currentQuestion.correctAnswer {
            wrongAnswers += 1
        }
        
        showResult = true
        
        // Auto advance after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            nextQuestion()
        }
    }
    
    private func nextQuestion() {
        if currentQuestionIndex < 2 {
            currentQuestionIndex += 1
            selectedAnswer = nil
            showResult = false
            timeRemaining = 10
            startTimer()
        } else {
            quizFinished = true
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            timeRemaining -= 1
            if timeRemaining <= 0 {
                // Time up - count as wrong answer
                timer?.invalidate()
                wrongAnswers += 1
                showResult = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    nextQuestion()
                }
            }
        }
    }
    
    private func resetQuiz() {
        currentQuestionIndex = 0
        wrongAnswers = 0
        selectedAnswer = nil
        showResult = false
        timeRemaining = 10
        quizFinished = false
        questions.shuffle() // Shuffle questions for variety
        startTimer()
    }
}

#Preview {
    NavigationStack {
        QuizGameView()
    }
    .environmentObject(GameCoordinator())
}
