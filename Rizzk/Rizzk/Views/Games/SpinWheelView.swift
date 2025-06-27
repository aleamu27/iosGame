import SwiftUI

struct SpinWheelView: View {
    @ObservedObject var gameSession: GameSession
    @State private var rotationAngle: Double = 0
    @State private var isSpinning = false
    @State private var result = ""
    
    let wheelOptions = [
        "Drikk 1", "Drikk 2", "Drikk 3", "Del ut 2", "Del ut 3",
        "Alle drikker", "Du velger", "Hopp over"
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.drinkGreen, Color.drinkYellow],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("LYKKEHJUL")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // Wheel
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 250, height: 250)
                        .shadow(radius: 10)
                    
                    // Wheel segments
                    ForEach(0..<wheelOptions.count, id: \.self) { index in
                        WheelSegment(
                            text: wheelOptions[index],
                            angle: Double(index) * 45,
                            color: index % 2 == 0 ? Color.drinkPink : Color.drinkBlue
                        )
                    }
                    
                    // Center circle
                    Circle()
                        .fill(Color.drinkYellow)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Text("SPIN")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                }
                .rotationEffect(.degrees(rotationAngle))
                .animation(.easeOut(duration: 3), value: rotationAngle)
                
                if !result.isEmpty {
                    Text("Resultat: \(result)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                }
                
                Button(action: spinWheel) {
                    GameButton(title: isSpinning ? "Spinner..." : "Spin hjulet", color: .drinkPink)
                }
                .disabled(isSpinning)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func spinWheel() {
        isSpinning = true
        result = ""
        
        let spins = Double.random(in: 3...6) * 360
        rotationAngle += spins
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isSpinning = false
            let normalizedAngle = Int(rotationAngle.truncatingRemainder(dividingBy: 360))
            let segmentIndex = (8 - (normalizedAngle / 45)) % 8
            result = wheelOptions[segmentIndex]
        }
    }
}

struct WheelSegment: View {
    let text: String
    let angle: Double
    let color: Color
    
    var body: some View {
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: 125, y: 125))
                path.addArc(center: CGPoint(x: 125, y: 125),
                           radius: 125,
                           startAngle: .degrees(angle - 22.5),
                           endAngle: .degrees(angle + 22.5),
                           clockwise: false)
                path.closeSubpath()
            }
            .fill(color)
            
            Text(text)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .rotationEffect(.degrees(angle))
                .offset(y: -70)
        }
        .frame(width: 250, height: 250)
    }
}

#Preview {
    SpinWheelView(gameSession: GameSession())
}
