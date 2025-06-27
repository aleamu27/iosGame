import Foundation

enum GameType: String, CaseIterable {
    case tapCompetition = "Tapp-konkurranse"
    case colorReaction = "Fargereaksjon"
    case neverHaveI = "Aldri har jeg"
    case quickQuiz = "Hurtigquiz"
    case spinWheel = "Lykkehjul"
    
    var description: String {
        switch self {
        case .tapCompetition:
            return "Hvem kan tappe raskest?"
        case .colorReaction:
            return "Reager på riktig farge"
        case .neverHaveI:
            return "Klassisk festspill"
        case .quickQuiz:
            return "Raske spørsmål"
        case .spinWheel:
            return "Spin hjulet!"
        }
    }
    
    var icon: String {
        switch self {
        case .tapCompetition: return "hand.tap"
        case .colorReaction: return "paintpalette"
        case .neverHaveI: return "person.3"
        case .quickQuiz: return "questionmark.circle"
        case .spinWheel: return "arrow.triangle.2.circlepath.circle"
        }
    }
}



class GameSession: ObservableObject {
    @Published var players: [Player] = []
    @Published var currentGame: GameType?
    @Published var gameInProgress = false
    
    func addPlayer(name: String) {
        players.append(Player(name: name))
    }
    
    func removePlayer(at index: Int) {
        players.remove(at: index)
    }
    
    func startGame(_ gameType: GameType) {
        currentGame = gameType
        gameInProgress = true
    }
    
    func endGame() {
        gameInProgress = false
        currentGame = nil
    }
}
