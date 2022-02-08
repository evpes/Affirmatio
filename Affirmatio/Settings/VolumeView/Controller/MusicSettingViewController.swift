//
//  MusicSettingViewController.swift
//  Affirmatio
//
//  Created by evpes on 31.01.2022.
//

import UIKit

class MusicSettingViewController: UIViewController {

    @IBOutlet weak var saveButtonOL: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var volumeLabel: UILabel!
    
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Settings.plist")
    var settings : [String : Float] = [:]
    
    let dataManager = DataManager()
    var bgView: GradientBackground?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButtonOL.layer.cornerRadius = 15
        settings = dataManager.loadSettings(from: dataFilePath)
        volumeSlider.value = settings["volume"] ?? 0
        volumeLabel.text = "\(Int(volumeSlider.value * 100))%"
        
        bgView = GradientBackground(frame: self.view.bounds)
        self.view.insertSubview(bgView!, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bgView!.animateGradient()
    }
    
    @IBAction func volumeSliderMoved(_ sender: UISlider) {
        volumeLabel.text = "\(Int(sender.value * 100))%"
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        settings["volume"] = volumeSlider.value
        dataManager.saveSettings(settings, to: dataFilePath)
        self.dismiss(animated: true, completion: nil)
    }
    

}
