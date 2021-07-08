////
////  ConciergeViewController.swift
////  Affirmatio
////
////  Created by evpes on 12.05.2021.
////
//
//import UIKit
//
//class ConciergeViewController: UINavigationController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        if LandscapeManager.shared.isFirstLaunch {
//            performSegue(withIdentifier: "toOnboarding", sender: nil)
//            LandscapeManager.shared.isFirstLaunch = true
//        } else {
//            performSegue(withIdentifier: "toMain", sender: nil)
//        }
//    }
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
