//
//  MainGameViewController.swift
//  WarCards
//
//  Created by Chethan Nayak  on 01/08/24.
//

import UIKit

class MainGameViewController: UIViewController {
    var username: String?
    
    var dealButtonTimer: Timer?
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerScore: UILabel!
    @IBOutlet weak var cpuScore: UILabel!
    
    
    @IBOutlet weak var playerCard: UIImageView!
    @IBOutlet weak var cpuCard: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        resetScores()
//        let mySceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate
//        let delegate = UIApplication.shared.delega
        SceneDelegate.viewController = self
        playerName.text = username?.uppercased() ?? "Player"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Deal(_ sender: Any) {
        if let timer = dealButtonTimer {
            timer.invalidate()
        }
        dealButtonTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.dealtapped()
        }
    }
    
    func dealtapped(){
        let cardPoints: [Int: Int] = [2: 2, 3: 3, 4: 4, 5: 5, 6: 6, 7: 7, 8: 8, 9: 9, 10: 10, 11: 10, 12: 10, 13: 10, 14: 11]
        let playerCardNumber = Int.random(in: 2...14)
        let cpuCardNumber = Int.random(in: 2...14)
        
        // Animate card flip
        UIView.transition(with: playerCard, duration: 0.5, options: .transitionCurlDown, animations: {
            self.playerCard.image = UIImage(named: "card\(playerCardNumber)")
        }, completion: nil)
        
        UIView.transition(with: cpuCard, duration: 0.5, options: .transitionCurlUp, animations: {
            self.cpuCard.image = UIImage(named: "card\(cpuCardNumber)")
        }, completion: nil)
        
        // Update scores after a delay to allow the card flip animation to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updateScores(playerCardNumber: playerCardNumber, cpuCardNumber: cpuCardNumber, cardPoints: cardPoints)
        }
    }
    
    func updateScores(playerCardNumber: Int, cpuCardNumber: Int, cardPoints: [Int: Int]) {
        
        guard let playerCurrentScore = Int(playerScore.text ?? "0") else { return }
        guard let cpuCurrentScore = Int(cpuScore.text ?? "0") else { return }
        
        
        let playerNewScore = playerCurrentScore + (cardPoints[playerCardNumber] ?? 0)
        let cpuNewScore = cpuCurrentScore + (cardPoints[cpuCardNumber] ?? 0)
        
        
        playerScore.text = "\(playerNewScore)"
        cpuScore.text = "\(cpuNewScore)"
        
        
        if playerNewScore >= 100 {
            self.gameOver(message: "\(username?.uppercased() ?? "Player") Wins")
        } else if cpuNewScore >= 100 {
            self.gameOver(message: "CPU Wins")
        } else if playerNewScore >= 100 && cpuNewScore >= 100 {
            if playerNewScore > cpuNewScore {
                self.gameOver(message: "\(username?.uppercased() ?? "Player") Wins")
            } else if cpuNewScore > playerNewScore {
                self.gameOver(message: "CPU Wins")
            } else if cpuNewScore == playerNewScore {
                self.gameOver(message: "Its a Tie")
            }
        }
        
        
        self.updateScoreStyles(pScore: playerNewScore, cScore: cpuNewScore)
    }
    
    func gameOver(message: String) {
        let alert = UIAlertController(title: "Game Over!", message: message, preferredStyle: .alert)
        let reset = UIAlertAction(title: "Play Again", style: .default, handler: self.Reset(_:))
        let quitAction = UIAlertAction(title: "Quit", style: .destructive) { _ in
            print("Exited")
            exit(0)
        }
        
        alert.addAction(reset)
        alert.addAction(quitAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateScoreStyles(pScore: Int, cScore: Int) {
        let isPlayerLeading = pScore > cScore
        let isTied = pScore == cScore
        
        playerScore.font = isTied || isPlayerLeading ? UIFont(name: "Helvetica-BoldOblique", size: 28) : UIFont(name: "Helvetica-BoldOblique", size: 24)
        playerScore.textColor = isTied || isPlayerLeading ? .green : .white
        
        cpuScore.font = isTied || !isPlayerLeading ? UIFont(name: "Helvetica-BoldOblique", size: 28) : UIFont(name: "Helvetica-BoldOblique", size: 24)
        cpuScore.textColor = isTied || !isPlayerLeading ? .green : .white
        
        print(isPlayerLeading ? "p > c" : isTied ? "p = c" : "c > p")
    }

    
    @IBAction func Reset(_ sender: Any) {
        playerScore.text = "0"
        cpuScore.text = "0"
        playerScore.font = UIFont(name: "Helvetica-BoldOblique", size: 24)
        cpuScore.font = UIFont(name: "Helvetica-BoldOblique", size: 24)
        playerScore.textColor = .white
        cpuScore.textColor = .white
        playerCard.image = UIImage(named: "back")
        cpuCard.image = UIImage(named: "back")
        print("Scores have been Reset")
    }
    
    @IBAction func Quit(_ sender: Any) {
        let alert = UIAlertController(title: "Quit Game", message: "Are you sure you want to quit?", preferredStyle: .alert)
        
        let quitAction = UIAlertAction(title: "Quit", style: .destructive) { _ in
            print("Exited")
            exit(0)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(quitAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func resetScores() {
        playerScore.text = "0"
        cpuScore.text = "0"
        playerScore.font = UIFont(name: "Helvetica-BoldOblique", size: 24)
        cpuScore.font = UIFont(name: "Helvetica-BoldOblique", size: 24)
        playerScore.textColor = .white
        cpuScore.textColor = .white
        playerCard.image = .back
        cpuCard.image = .back
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
