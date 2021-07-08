//
//  SettingsViewController.swift
//  Affirmatio
//
//  Created by evpes on 25.05.2021.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var pauseDurationSlider: UISlider!
    @IBOutlet weak var volumeMusicSlider: UISlider!
    let dataManager = DataManager()
    var bgView: GradientBackground?
    @IBOutlet weak var okButtonOutlet: UIButton!
    @IBOutlet weak var pauseLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Settings.plist")
    var settings : [String : Float] = [:]
    
    override func viewDidLoad() {
        
        okButtonOutlet.layer.cornerRadius = 15
        okButtonOutlet.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        okButtonOutlet.titleLabel?.tintColor = .white
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
