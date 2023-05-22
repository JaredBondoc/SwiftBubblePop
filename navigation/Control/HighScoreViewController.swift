//
//  HighScoreViewController.swift
//  navigation
//
//  Created by Jared Bondoc on 24/4/2023.
//

import Foundation
import UIKit

struct GameScore: Codable {
    var name: String
    var score: Int
}


let KEY_HIGH_SCORE = "highScore"

class HighScoreViewController: UIViewController {
    var UserScore: Int = 0
    var UserName:String = "No Name"
    @IBOutlet weak var tableView: UITableView!
    var highScores: [GameScore] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.highScores = readHighScroes()
        // Sort the High Score
        highScores.sort {
            $0.score > $1.score
        }

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
    
}

extension HighScoreViewController: UITableViewDelegate {
    
}

extension HighScoreViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // As table view, how many cells should I display in this section?
        return highScores.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // As table view, what cell should I display, when user's at this index?
        
        // Dequed a reusable cell from the table view
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        
        // Updated the UI for this Cell
        let score = highScores[indexPath.row]
        
        cell.textLabel?.text = score.name;
        cell.detailTextLabel?.text = "Score: \(score.score)";
        
        // Return the cell to TableView
        return cell;
        
    }
}
