//
//  GradientBackground.swift
//  Affirmatio
//
//  Created by evpes on 14.05.2021.
//

import Foundation
import UIKit

class GradientBackground: UIView {
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
    //standart
//    let gradientOne = UIColor(red: 48/255, green: 62/255, blue: 103/255, alpha: 1).cgColor
//    let gradientTwo = UIColor(red: 244/255, green: 88/255, blue: 53/255, alpha: 1).cgColor
//    let gradientThree = UIColor(red: 196/255, green: 70/255, blue: 107/255, alpha: 1).cgColor
    //blue
//    let gradientOne = UIColor(red: 34/255, green: 210/255, blue: 255/255, alpha: 1).cgColor
//    let gradientTwo = UIColor(red: 104/255, green: 122/255, blue: 254/255, alpha: 1).cgColor
//    let gradientThree = UIColor(red: 150/255, green: 78/255, blue: 254/255, alpha: 1).cgColor
    //purple-blue
//    let gradientOne = UIColor(red: 255/255, green: 152/255, blue: 182/255, alpha: 1).cgColor
//    let gradientTwo = UIColor(red: 160/255, green: 180/255, blue: 220/255, alpha: 1).cgColor
//    let gradientThree = UIColor(red: 60/255, green: 190/255, blue: 250/255, alpha: 1).cgColor
    //dark purple
    //20 25 190
//    let gradientZero = UIColor(red: 20/255, green: 125/255, blue: 190/255, alpha: 1).cgColor
//    let gradientOne = UIColor(red: 41/255, green: 21/255, blue: 142/255, alpha: 1).cgColor
//    let gradientTwo = UIColor(red: 106/255, green: 14/255, blue: 200/255, alpha: 1).cgColor
//    let gradientThree = UIColor(red: 119/255, green: 23/255, blue: 189/255, alpha: 1).cgColor
        
        let gradientOne = UIColor(red: 20/255, green: 125/255, blue: 190/255, alpha: 1).cgColor
        let gradientTwo = UIColor(red: 41/255, green: 21/255, blue: 142/255, alpha: 1).cgColor
        let gradientThree = UIColor(red: 139/255, green: 29/255, blue: 183/255, alpha: 1).cgColor
    
    override init(frame: CGRect ) {
        
        gradientSet.append([gradientOne, gradientTwo])
        gradientSet.append([gradientTwo, gradientThree])
        gradientSet.append([gradientThree, gradientOne])
        
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        gradient.drawsAsynchronously = true
        super.init(frame: frame)
        gradient.frame = self.bounds
        gradientChangeAnimation.delegate = self
        self.layer.addSublayer(gradient)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    func animateGradient() {
        
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        

        gradientChangeAnimation.duration = 8.0
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradient.add(gradientChangeAnimation, forKey: "colorChange")
        //print("animation begins")
    }
    
    
}

extension GradientBackground: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        //print("animation did stop")
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
}
