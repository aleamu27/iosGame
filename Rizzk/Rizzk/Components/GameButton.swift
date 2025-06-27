import SwiftUI

struct GameButton: View {
    let title: String
    let color: Color
    
    var body: some View {
        Text(title)
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(color)
            .cornerRadius(25)
            .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    GameButton(title: "Test Button", color: .drinkYellow)
}
