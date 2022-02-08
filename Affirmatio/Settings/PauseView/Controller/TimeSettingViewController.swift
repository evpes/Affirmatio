//
//  TimeSettingViewController.swift
//  Affirmatio
//
//  Created by evpes on 31.01.2022.
//

import UIKit

class TimeSettingViewController: UIViewController {

    @IBOutlet weak var saveButtonOL: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    let dataManager = DataManager()
    var bgView: GradientBackground?
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Settings.plist")
    var settings : [String : Float] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButtonOL.layer.cornerRadius = 15
        settings = dataManager.loadSettings(from: dataFilePath)
        timeSlider.value = settings["pause"] ?? 0
        timeLabel.text = "\(Int(timeSlider.value)) s"
        bgView = GradientBackground(frame: self.view.bounds)
        self.view.insertSubview(bgView!, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bgView!.animateGradient()
    }
    
    @IBAction func timeSliderMoved(_ sender: UISlider) {
        timeLabel.text = "\(Int(sender.value)) s"
    }
    
    

    @IBAction func saveButtonTapped(_ sender: Any) {
        settings["pause"] = timeSlider.value
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
