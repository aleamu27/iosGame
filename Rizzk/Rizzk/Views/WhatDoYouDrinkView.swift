//
//  WhatDoYouDrinkView.swift
//  Rizzk
//
//  Created by Alexander Amundsen on 25/06/2025.
//

import SwiftUI

struct WhatDoYouDrinkView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var coordinator: GameCoordinator
    @State private var selectedDrink: DrinkType?
    @State private var navigateNext = false
    
    enum DrinkType: String, CaseIterable {
        case beer = "Øl/Cider"
        case wine = "Vin"
        case spirits = "Sprit"
        
        var emoji: String {
            switch self {
            case .beer:
                return "🍺"
            case .wine:
                return "🍷"
            case .spirits:
                return "🥃"
            }
        }
        
        var description: String {
            switch self {
            case .beer:
                return "Øl, cider, eller andre lettere drikker"
            case .wine:
                return "Vin, champagne, eller andre vindrikker"
            case .spirits:
                return "Sprit, shots, eller sterke drikker"
            }
        }
        
        var color: Color {
            switch self {
            case .beer:
                return .drinkYellow
            case .wine:
                return .drinkPink
            case .spirits:
                return .drinkBlue
            }
        }
        
        // Text multipliers for game prompts
        var sipMultiplier: Int {
            switch self {
            case .beer:
                return 3 // "3 slurker"
            case .wine:
                return 2 // "2 slurker"
            case .spirits:
                return 1 // "1 slurk"
            }
        }
        
        var drinkText: String {
            switch self {
            case .beer:
                return "slurker"
            case .wine:
                return "slurker"
            case .spirits:
                return "slurk"
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
                    Text("Hva drikker du?")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Velg hva du hovedsakelig drikker i kveld")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: 20) {
                    ForEach(DrinkType.allCases, id: \.self) { drink in
                        DrinkSelectionCard(
                            drink: drink,
                            isSelected: selectedDrink == drink
                        ) {
                            selectedDrink = drink
                        }
                    }
                }
                
                if selectedDrink != nil {
                    VStack(spacing: 15) {
                        Text("Perfekt! 🎉")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.drinkYellow)
                        
                        Text("Spillene vil tilpasse seg hva du drikker")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            coordinator.drinkTypeSelected(selectedDrink!)
                            navigateNext = true
                        }) {
                            GameButton(
                                title: "Fortsett",
                                color: .drinkYellow
                            )
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: selectedDrink)
                }
                
                Spacer()
                
                VStack(spacing: 10) {
                    Text("💡 Tips")
                        .font(.headline)
                        .foregroundColor(.drinkYellow)
                    
                    Text("Du kan alltids bytte drikke underveis i spillet")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(15)
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
            destinationView
        }
    }
    
    @ViewBuilder
    private var destinationView: some View {
        switch coordinator.gameMode {
        case .host:
            GameHostView()
        case .join:
            JoinLobbyView()
        case .none:
            Text("Error: No game mode selected")
        }
    }
}

struct DrinkSelectionCard: View {
    let drink: WhatDoYouDrinkView.DrinkType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Text(drink.emoji)
                    .font(.system(size: 40))
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(drink.rawValue)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(drink.description)
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
                    .fill(isSelected ? drink.color : Color.white.opacity(0.1))
                    .stroke(drink.color, lineWidth: isSelected ? 2 : 1)
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationStack {
        WhatDoYouDrinkView()
    }
    .environmentObject(GameCoordinator())
}
