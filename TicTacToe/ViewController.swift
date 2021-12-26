//
//  ViewController.swift
//  TicTacToe
//
//  Created by Erick Restituyo on 26/12/21.
//

import UIKit

private let CIRCLE = "O"
private let CROSS = "X"

class ViewController: UIViewController {
    enum Player {
        case O
        case X
        
        var text: String {
            switch self {
            case .O:
                return CIRCLE
            case .X:
                return CROSS
            }
        }
    }
    
    @IBOutlet weak var a1: UIButton!
    @IBOutlet weak var a2: UIButton!
    @IBOutlet weak var a3: UIButton!
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var c1: UIButton!
    @IBOutlet weak var c2: UIButton!
    @IBOutlet weak var c3: UIButton!
    @IBOutlet weak var turnLabel: UILabel!
    
    private let players: [Player] = [.O, .X]
    
    private var turn = 0
    private var board: [UIButton] = []
    
    private let amountOfPlayers = 2
    private var scoreCounter: [Player:Int] = [.O: 0, .X: 0]
    
    private func getCurrentPlayer() -> Player {
        let playersTurn = (turn % amountOfPlayers)
        return players[playersTurn]
    }
    
    func getCounterMessage() -> String {
        let counters = scoreCounter.map { (key, value) in
            "\(key.text): \(value)"
        }
        return counters.joined(separator: "\n")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        turnLabel.text = getCurrentPlayer().text
        initBoard()
    }


    @IBAction func boardButtonTapped(_ sender: UIButton) {
        guard sender.title(for: .normal) == nil else {
            return
        }
        
        let currentPlayer = getCurrentPlayer()
        sender.setTitle(currentPlayer.text, for: .normal)
        sender.isEnabled = false
        
        guard !isGameWon(by: currentPlayer) else {
            updateScore(for: currentPlayer)
            showResetBoardAlert(title: "\(currentPlayer.text) has won.")
            return
        }
        
        turn += 1
        let nextPlayer = getCurrentPlayer()
        turnLabel.text = nextPlayer.text
        
        if fullBoard() {
            showResetBoardAlert(title: "Game Finished")
        }
    }
    
    func fullBoard() -> Bool {
        return !board.contains() {
            $0.title(for: .normal) == nil
        }
    }
    
    func updateScore(for player: Player) {
        guard let score = scoreCounter[player] else {
            return
        }
        
        scoreCounter[player] = score + 1
    }
    
    func initBoard() {
        board.append(a1)
        board.append(a2)
        board.append(a3)
        board.append(b1)
        board.append(b2)
        board.append(b3)
        board.append(c1)
        board.append(c2)
        board.append(c3)
    }
    
    func showResetBoardAlert(title: String) {
        let message = getCounterMessage()
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let resetAction = UIAlertAction(title: "Reset", style: .default) { (_) in
            self.resetBoard()
        }
        alertController.addAction(resetAction)
        self.present(alertController, animated: true)
    }
    
    func resetBoard() {
        for button in board {
            button.setTitle(nil, for: .normal)
            button.isEnabled = true
        }
        
        turn = 0
        let currentPlayer = getCurrentPlayer()
        turnLabel.text = currentPlayer.text
    }
    
    func isGameWon(by player: Player) -> Bool {
        
        return isHorizontalWin(by: player) || isVerticalWin(by: player) || isDiagonalWin(by: player)
    }
    
    func isHorizontalWin(by player: Player) -> Bool {
        return (a1.hasSymbol(player.text) && a2.hasSymbol(player.text) && a3.hasSymbol(player.text)) ||
        (b1.hasSymbol(player.text) && b2.hasSymbol(player.text) && b3.hasSymbol(player.text)) ||
        (c1.hasSymbol(player.text) && c2.hasSymbol(player.text) && c3.hasSymbol(player.text))
    }
    
    func isVerticalWin(by player: Player) -> Bool {
        return (a1.hasSymbol(player.text) && b1.hasSymbol(player.text) && c1.hasSymbol(player.text)) ||
        (a2.hasSymbol(player.text) && b2.hasSymbol(player.text) && c2.hasSymbol(player.text)) ||
        (a3.hasSymbol(player.text) && b3.hasSymbol(player.text) && c3.hasSymbol(player.text))
    }
    
    func isDiagonalWin(by player: Player) -> Bool {
        return (a1.hasSymbol(player.text) && b2.hasSymbol(player.text) && c3.hasSymbol(player.text)) ||
        (a3.hasSymbol(player.text) && b2.hasSymbol(player.text) && c1.hasSymbol(player.text))
    }
}

extension UIButton {
    func hasSymbol(_ symbol: String) -> Bool {
        return self.title(for: .normal) == symbol
    }
}

