//
//  GameViewController.swift
//  navigation
//
//  Created by Jared Bondoc on 24/4/2023.
//

import Foundation
import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var remainingTimeLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var name:String = "No Name"
    var remaningTime = 60
    var timer = Timer()
    var score:Int = 0
    var numberOfBubbles = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameLabel.text = name
        remainingTimeLabel.text = String(remaningTime)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            timer in
            self.counting()
            self.generateBubble()
        }
    }
    
    func counting(){
        remaningTime -= 1
        remainingTimeLabel.text = String(remaningTime)
        if remaningTime == 0 {
            writeHighScores()
            timer.invalidate()
            
            //show highscore screen
            let vc =
            storyboard?.instantiateViewController(identifier: "HighScoreViewController") as! HighScoreViewController
            self.navigationController?.pushViewController(vc, animated: true)
            vc.navigationItem.setHidesBackButton(true, animated: true)
            //provide name and score for highscore table

        }
    }
    
    var existingBubblePositions: [(CGFloat, CGFloat)] = []
    var currentNumberOfBubbles: Int = 0

    func generateBubble() {
        // Calculate the minimum and maximum number of bubbles to add or remove
        let maxChange = min(numberOfBubbles - currentNumberOfBubbles, 3)
        let minChange = min(maxChange, 1)
        let change = Int.random(in: minChange...maxChange)

        // Remove existing bubbles
        for subview in self.view.subviews {
            if subview is Bubble {
                subview.removeFromSuperview()
            }
        }
        existingBubblePositions.removeAll()
        // Add bubbles
        currentNumberOfBubbles += change
        for _ in 1...currentNumberOfBubbles {
            let bubble = Bubble()
            var isOverlapping = true
            var xPosition: CGFloat = 0
            var yPosition: CGFloat = 0
            while isOverlapping {
                // ensure the bubbles are within the screen boundary and below the top labels
                xPosition = CGFloat.random(in: 25...(UIScreen.main.bounds.width - 75))
                yPosition = CGFloat.random(in: 130...(UIScreen.main.bounds.height - 75))
                isOverlapping = existingBubblePositions.contains { (existingX, existingY) in
                    let distance = sqrt(pow(existingX - xPosition, 2) + pow(existingY - yPosition, 2))
                    // check if new bubble overlaps with existing bubble
                    return distance < 50
                }
            }
            bubble.frame = CGRect(x: xPosition, y: yPosition, width: 50, height: 50)
            existingBubblePositions.append((xPosition, yPosition))
            bubble.animation()
            bubble.addTarget(self, action: #selector(bubblePressed), for: .touchUpInside)
            self.view.addSubview(bubble)
        }
    }
    
    func writeHighScores() {
        // Write high scores to User Defaults
        let defaults = UserDefaults.standard;
        // Read existing high scores
        var existingHighScores = readHighScroes()
        // Append the new score
        existingHighScores.append(GameScore(name: self.name, score: self.score))
        // Write the updated array back to User Defaults
        defaults.set(try? PropertyListEncoder().encode(existingHighScores), forKey: KEY_HIGH_SCORE)
    }
    
    func readHighScroes() -> [GameScore] {
        // Read from User Defaults
        let defaults = UserDefaults.standard;
        if let savedArrayData = defaults.value(forKey:KEY_HIGH_SCORE) as? Data {
            if let array = try? PropertyListDecoder().decode(Array<GameScore>.self, from: savedArrayData) {
                return array
            } else {
                return []
            }
        } else {
            return []
        }
    }
    

    var lastColor: UIColor?
    var comboCount = 0
    
    // provide different points for bubble colour
    @objc func bubblePressed(sender: UIButton) {
        let color = sender.backgroundColor
        var points = 0
        switch color {
        case UIColor.red:
            points = 1
        case UIColor.magenta:
            points = 2
        case UIColor.green:
            points = 5
        case UIColor.blue:
            points = 8
        case UIColor.black:
            points = 10
        default:
            break
        }
        //extra points for combos
        if let lastColor = lastColor, lastColor == color {
            comboCount += 1
            points = Int(ceil(Double(points) * 1.5))
        } else {
            comboCount = 0
        }
        lastColor = color
        score += points
        scoreLabel.text = String(score)
        sender.removeFromSuperview()
    }
}
