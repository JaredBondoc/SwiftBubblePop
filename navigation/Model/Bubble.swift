import Foundation
import UIKit

class Bubble: UIButton {
    
    let xPosition = Int.random(in: 20...400)
    let yPosition = Int.random(in: 20...800)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let color = randomColor()
        self.backgroundColor = color
        self.frame = CGRect(x: xPosition, y: yPosition, width: 50, height: 50)
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animation() {
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.duration = 0.6
        springAnimation.fromValue = 1
        springAnimation.toValue = 0.95
        springAnimation.repeatCount = 1
        springAnimation.initialVelocity = 0.1
        springAnimation.damping = 1
        
        layer.add(springAnimation, forKey: nil)
    }
    
    func flash() {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        
        layer.add(flash, forKey: nil)
    }
    
    //function to pick random colour with the provided probabilities
    private func randomColor() -> UIColor {
        let colors = [UIColor.red, UIColor.magenta, UIColor.green, UIColor.blue, UIColor.black]
        let probabilities = [0.4, 0.3, 0.15, 0.1, 0.05]
        
        let randomValue = Double.random(in: 0..<1)
        var cumulativeProbability = 0.0
        
        for (index, probability) in probabilities.enumerated() {
            cumulativeProbability += probability
            if randomValue < cumulativeProbability {
                return colors[index]
            }
        }
        
        return colors.last ?? UIColor.black
    }
}
