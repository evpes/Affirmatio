//
//  HowToWriteAffirmsController.swift
//  Affirmatio
//
//  Created by evpes on 11.07.2021.
//

import UIKit

class HowToWriteAffirmsController: UIViewController {
    var bgView: GradientBackground?
    override func viewDidLoad() {
        super.viewDidLoad()
        bgView = GradientBackground(frame: self.view.bounds)
        self.view.insertSubview(bgView!, at: 0)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bgView?.animateGradient()
    }
    

    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
