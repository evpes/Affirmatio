//
//  SecondStepViewController.swift
//  Affirmatio
//
//  Created by evpes on 12.05.2021.
//

import UIKit

class SecondStepViewController: UIViewController {

    @IBOutlet weak var buttonOutlet: UIButton!
    var bgView: GradientBackground?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonOutlet.layer.cornerRadius = 15
        //buttonOutlet.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        // Do any additional setup after loading the view.
        bgView = GradientBackground(frame: self.view.bounds)
        self.view.insertSubview(bgView!, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bgView?.animateGradient()
    }
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        if let pageController = parent as? MainPageViewController {
                pageController.pushNext()
            }
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
