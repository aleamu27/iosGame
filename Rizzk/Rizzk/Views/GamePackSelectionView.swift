//
//  GamePackSelectionView.swift
//  Rizzk
//
//  Created by Alexander Amundsen on 25/06/2025.
//

import SwiftUI

struct GamePackSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var coordinator: GameCoordinator
    @State private var selectedPack: GamePack?
    @State private var navigateNext = false
    @State private var showPremiumAlert = false
    
    enum GamePack: String, CaseIterable {
        case jentekveld = "Jentekveld"
        case mix = "Mix"
        case guttastemning = "Guttastemning"
        case premium1 = "Voksen 18+"
        case premium2 = "Ekstrem"
        case premium3 = "Couples"
        
        var isFree: Bool {
            switch self {
            case .jentekveld, .mix, .guttastemning:
                return true
            case .premium1, .premium2, .premium3:
                return false
            }
        }
        
        var description: String {
            switch self {
            case .jentekveld:
                return "Perfekt for jentekvelder med morsomme utfordringer og leker"
            case .mix:
                return "En blanding av alt - noe for enhver smak og anledning"
            case .guttastemning:
                return "Tøffe utfordringer og konkurranser for gutta"
            case .premium1:
                return "Vokseninnhold med spicier utfordringer og dypere spørsmål"
            case .premium2:
                return "De villeste og mest ekstreme utfordringene vi har"
            case .premium3:
                return "Spesiallaget for par - styrk båndet mellom dere"
            }
        }
        
        var icon: String {
            switch self {
            case .jentekveld:
                return "💄"
            case .mix:
                return "🎭"
            case .guttastemning:
                return "💪"
            case .premium1:
                return "🔥"
            case .premium2:
                return "⚡"
            case .premium3:
                return "💕"
            }
        }
        
        var gradientColors: [Color] {
            switch self {
            case .jentekveld:
                return [Color.drinkPink, Color.purple]
            case .mix:
                return [Color.drinkYellow, Color.drinkGreen]
            case .guttastemning:
                return [Color.drinkBlue, Color.blue]
            case .premium1:
                return [Color.red, Color.orange]
            case .premium2:
                return [Color.black, Color.gray]
            case .premium3:
                return [Color.pink, Color.red]
            }
        }
        
        var price: String? {
            switch self {
            case .jentekveld, .mix, .guttastemning:
                return nil
            case .premium1, .premium2, .premium3:
                return "49 kr"
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
            
            VStack(spacing: 30) {
                VStack(spacing: 15) {
                    Text("Velg spillpakke")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Hvilken stemning skal dere ha i kveld?")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 15),
                        GridItem(.flexible(), spacing: 15)
                    ], spacing: 20) {
                        
                        // Free packs
                        Text("GRATIS PAKKER")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.drinkYellow)
                            .gridColumnSpan(2)
                            .padding(.top)
                        
                        ForEach([GamePack.jentekveld, .mix, .guttastemning], id: \.self) { pack in
                            GamePackCard(
                                pack: pack,
                                isSelected: selectedPack == pack
                            ) {
                                selectedPack = pack
                            }
                        }
                        
                        // Premium packs
                        Text("PREMIUM PAKKER")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.drinkYellow)
                            .gridColumnSpan(2)
                            .padding(.top, 30)
                        
                        ForEach([GamePack.premium1, .premium2, .premium3], id: \.self) { pack in
                            GamePackCard(
                                pack: pack,
                                isSelected: selectedPack == pack
                            ) {
                                if pack.isFree {
                                    selectedPack = pack
                                } else {
                                    selectedPack = pack
                                    showPremiumAlert = true
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                if selectedPack != nil {
                    Button(action: {
                        if selectedPack!.isFree {
                            coordinator.gamePackSelected(selectedPack!)
                            navigateNext = true
                        } else {
                            showPremiumAlert = true
                        }
                    }) {
                        GameButton(
                            title: selectedPack!.isFree ? "Fortsett" : "Kjøp og fortsett",
                            color: .drinkYellow
                        )
                    }
                    .animation(.easeInOut(duration: 0.3), value: selectedPack)
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
        .alert("Premium innhold", isPresented: $showPremiumAlert) {
            Button("Kjøp nå") {
                // TODO: Implementer kjøpslogikk
                coordinator.gamePackSelected(selectedPack!)
                navigateNext = true
            }
            Button("Avbryt", role: .cancel) {
                selectedPack = nil
            }
        } message: {
            if let pack = selectedPack {
                Text("Vil du kjøpe \"\(pack.rawValue)\" for \(pack.price ?? "")? Du får tilgang til eksklusivt innhold og støtter utviklingen av appen.")
            }
        }
        .navigationDestination(isPresented: $navigateNext) {
            PlayerNameView()
        }
    }
}

struct GamePackCard: View {
    let pack: GamePackSelectionView.GamePack
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 15) {
                // App icon style container
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(
                            colors: pack.gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 80, height: 80)
                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    
                    Text(pack.icon)
                        .font(.system(size: 35))
                    
                    // Premium badge
                    if !pack.isFree {
                        VStack {
                            HStack {
                                Spacer()
                                Text("💎")
                                    .font(.caption)
                                    .padding(4)
                                    .background(Color.yellow)
                                    .clipShape(Circle())
                            }
                            Spacer()
                        }
                        .frame(width: 80, height: 80)
                    }
                }
                
                VStack(spacing: 5) {
                    Text(pack.rawValue)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    if let price = pack.price {
                        Text(price)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.drinkYellow)
                    } else {
                        Text("GRATIS")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                    
                    Text(pack.description)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(isSelected ? 0.2 : 0.1))
                    .stroke(Color.white.opacity(isSelected ? 0.8 : 0.3), lineWidth: isSelected ? 2 : 1)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Extension for GridItem column span
extension View {
    func gridColumnSpan(_ span: Int) -> some View {
        self
    }
}

#Preview {
    NavigationStack {
        GamePackSelectionView()
    }
    .environmentObject(GameCoordinator())
}
