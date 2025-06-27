//
//  GameHostView.swift
//  Rizzk
//
//  Created by Alexander Amundsen on 25/06/2025.
//

import SwiftUI

struct GameHostView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var coordinator: GameCoordinator
    @State private var selectedDrinkLevel: DrinkLevel?
    @State private var navigateNext = false
    
    enum DrinkLevel: String, CaseIterable {
        case pussy = "Pussy"
        case faded = "Faded"
        case murings = "Murings"
        
        var description: String {
            switch self {
            case .pussy:
                return "For de som vil ha det rolig"
            case .faded:
                return "Perfekt balanse mellom moro og kontroll"
            case .murings:
                return "Full gass - ingen nåde!"
            }
        }
        
        var color: Color {
            switch self {
            case .pussy:
                return .drinkGreen
            case .faded:
                return .drinkYellow
            case .murings:
                return .drinkPink
            }
        }
        
        var emoji: String {
            switch self {
            case .pussy:
                return "🌿"
            case .faded:
                return "🍻"
            case .murings:
                return "🔥"
            }
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.drinkBlue, Color.drinkGreen],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                VStack(spacing: 20) {
                    Text("Velg drikkenivå")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Hvor hardt skal dere kjøre på i kveld?")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: 20) {
                    ForEach(DrinkLevel.allCases, id: \.self) { level in
                        DrinkLevelCard(
                            level: level,
                            isSelected: selectedDrinkLevel == level
                        ) {
                            selectedDrinkLevel = level
                        }
                    }
                }
                
                if selectedDrinkLevel != nil {
                    Button(action: {
                        coordinator.drinkLevelSelected(selectedDrinkLevel!)
                        navigateNext = true
                    }) {
                        GameButton(
                            title: "Fortsett",
                            color: .drinkYellow
                        )
                    }
                    .animation(.easeInOut(duration: 0.3), value: selectedDrinkLevel)
                }
                
                Spacer()
            }
            .padding()
            
            // Back button
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.black.opacity(0.2))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding()
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(isPresented: $navigateNext) {
            HostLobbyView()
        }
    }
}

struct DrinkLevelCard: View {
    let level: GameHostView.DrinkLevel
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Text(level.emoji)
                    .font(.system(size: 30))
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(level.rawValue)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(level.description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? level.color : Color.white.opacity(0.1))
                    .stroke(level.color, lineWidth: isSelected ? 2 : 1)
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationStack {
        GameHostView()
    }
    .environmentObject(GameCoordinator())
}
