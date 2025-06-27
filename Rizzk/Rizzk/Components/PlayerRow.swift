import SwiftUI

struct PlayerRow: View {
    let player: Player
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.drinkGreen)
                .frame(width: 40, height: 40)
                .overlay(
                    Text(String(player.name.prefix(1)).uppercased())
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                )
            
            Text(player.name)
                .font(.headline)
                .foregroundColor(.drinkBlue)
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.drinkPink)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    PlayerRow(player: Player(name: "Test")) { }
}
