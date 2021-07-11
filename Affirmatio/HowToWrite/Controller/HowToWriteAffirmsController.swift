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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
