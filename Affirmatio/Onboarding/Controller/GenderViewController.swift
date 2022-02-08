//
//  GenderViewController.swift
//  Affirmatio
//
//  Created by evpes on 24.01.2022.
//

import UIKit

class GenderViewController: UIViewController {

    
    @IBOutlet weak var maleButtonLO: UIButton!
    @IBOutlet weak var femaleButtonLO: UIButton!
    @IBOutlet weak var nextButtonLO: UIButton!
    
    var bgView: GradientBackground?
    
    
    var selectedGender: Float = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        maleButtonLO.layer.cornerRadius = 15
        femaleButtonLO.layer.cornerRadius = 15
        nextButtonLO.layer.cornerRadius = 15
        setButtonSelected(with: 1)
        setButtonUnselected(with: 0)
        
        bgView = GradientBackground(frame: self.view.bounds)
        self.view.insertSubview(bgView!, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bgView?.animateGradient()
    }
    
    @IBAction func genderButtonTapped(_ sender: UIButton) {
        selectedGender = Float(sender.tag)
        switch sender.tag {
        case 0:
            setButtonSelected(with: 0)
            setButtonUnselected(with: 1)
        case 1:
            setButtonSelected(with: 1)
            setButtonUnselected(with: 0)
        default:
            print("it can't be")
        }
    }
    
    func setButtonSelected(with tag: Int) {
        switch tag {
        case 0:
            maleButtonLO.layer.opacity = 1
            maleButtonLO.layer.borderWidth = 3
            maleButtonLO.layer.borderColor = UIColor.white.withAlphaComponent(0.8).cgColor
        case 1:
            femaleButtonLO.layer.opacity = 1
            femaleButtonLO.layer.borderWidth = 3
            femaleButtonLO.layer.borderColor = UIColor.white.withAlphaComponent(0.8).cgColor
        default:
            print("no")
        }
    }
    
    func setButtonUnselected(with tag: Int) {
        switch tag {
        case 0:
            maleButtonLO.layer.opacity = 0.5
            maleButtonLO.layer.borderWidth = 0
            maleButtonLO.layer.borderColor = UIColor.clear.cgColor
        case 1:
            femaleButtonLO.layer.opacity = 0.5
            femaleButtonLO.layer.borderWidth = 0
            femaleButtonLO.layer.borderColor = UIColor.clear.cgColor
        default:
            print("i said no")
        }
    }
    
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        let dataManager = DataManager()
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Settings.plist")
        let settings = ["pause" : 15, "volume" : 0.75, "voiceGender" : 1, "userGender" : selectedGender]
        dataManager.saveSettings(settings, to: path)
        
        if let pageController = parent as? MainPageViewController {
                pageController.pushNext()
            }
    }
    
    
    

    

}
