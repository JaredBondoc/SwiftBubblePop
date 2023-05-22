//
//  SettingViewController.swift
//  navigation
//
//  Created by Jared Bondoc on 24/4/2023.
//

import Foundation
import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var timeSlider: UISlider!
    
    @IBOutlet weak var numberOfBubbles: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGame" {
            let VC = segue.destination as! GameViewController
            VC.name = nameTextField.text ?? "No Name"
            VC.remaningTime = Int(timeSlider.value)
            VC.numberOfBubbles = Int(numberOfBubbles.value)
        }
    }
}
