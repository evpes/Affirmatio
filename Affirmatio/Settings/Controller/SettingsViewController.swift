//
//  SettingsViewController.swift
//  Affirmatio
//
//  Created by evpes on 25.05.2021.
//

import UIKit
import StoreKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var pauseDurationSlider: UISlider!
    @IBOutlet weak var volumeMusicSlider: UISlider!
    @IBOutlet weak var okButtonOutlet: UIButton!
    @IBOutlet weak var pauseLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    
    @IBOutlet weak var contactButtonOutlet: UIButton!
    @IBOutlet weak var rateButtonOutlet: UIButton!
    
    
    let dataManager = DataManager()
    var bgView: GradientBackground?
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Settings.plist")
    var settings : [String : Float] = [:]
    
    override func viewDidLoad() {
        
        okButtonOutlet.layer.cornerRadius = 15
        okButtonOutlet.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        okButtonOutlet.titleLabel?.tintColor = .white
        
        contactButtonOutlet.layer.cornerRadius = 15
        contactButtonOutlet.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        contactButtonOutlet.titleLabel?.tintColor = .black
        
        rateButtonOutlet.layer.cornerRadius = 15
        rateButtonOutlet.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        rateButtonOutlet.titleLabel?.tintColor = .black
        
        super.viewDidLoad()
//        print("setting file path:\(dataFilePath)")
        settings = dataManager.loadSettings(from: dataFilePath)
        for s in settings {
            switch s.key {
            case "pause":
                pauseDurationSlider.value = Float(s.value)
                pauseLabel.text = "\(Int(s.value)) s"
            case "volume":
                volumeMusicSlider.value = Float(s.value)
                volumeLabel.text = "\(Int(s.value * 100))%"
            default:
                print("default")
            }
        }
        // Do any additional setup after loading the view.
        bgView = GradientBackground(frame: self.view.bounds)
        self.view.insertSubview(bgView!, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bgView!.animateGradient()
    }
    
    @IBAction func pauseSliderMoved(_ sender: UISlider) {
        pauseLabel.text = "\(Int(sender.value)) s"
    }
    
    @IBAction func volumeSliderMoved(_ sender: UISlider) {
        volumeLabel.text = "\(Int(sender.value * 100))%"
    }
    
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        settings["pause"] = pauseDurationSlider.value
        settings["volume"] = volumeMusicSlider.value
        print(settings)
        dataManager.saveSettings(settings, to: dataFilePath)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func mailDev(_ sender: UIButton) {
        let email = "apsterio.anima@gmail.com"
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }
    
    @IBAction func rateApp(_ sender: UIButton) {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    
    

}
