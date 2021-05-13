//
//  ThirdStepViewController.swift
//  Affirmatio
//
//  Created by evpes on 12.05.2021.
//

import UIKit

class ThirdStepViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        if let pageController = parent as? MainPageViewController {
            pageController.dismiss(animated: true, completion: nil)
            //self.dismiss(animated: true, completion: nil)
            //pageController.pushNext()
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
