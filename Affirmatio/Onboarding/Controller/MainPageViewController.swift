//
//  MainPageViewController.swift
//  Affirmatio
//
//  Created by evpes on 12.05.2021.
//

import UIKit

class MainPageViewController: UIPageViewController {

    
    // MARK: - UI Elements
    private var viewControllerList: [UIViewController] = {
        var controllers: [UIViewController] = []
        let storyboard = UIStoryboard.main //UIStoryboard.onboarding
        let firstVC = storyboard.instantiateViewController(withIdentifier: "FirstStepVC")
        firstVC.isModalInPresentation = true
        controllers.append(firstVC)
        
        //check localization
        let locale = NSLocale.current.languageCode ?? ""
        if locale == "ru" {
            let genderVC = storyboard.instantiateViewController(withIdentifier: "GenderVC")
            controllers.append(genderVC)
        } else {
            //set default settings
            let dataManager = DataManager()
            dataManager.rewriteSettings()
        }
                
        let secondVC = storyboard.instantiateViewController(withIdentifier: "SecondStepVC")
        controllers.append(secondVC)
        
        let mainSubscriptionVC = storyboard.instantiateViewController(withIdentifier: "MainSubscriptionVC")
        controllers.append(mainSubscriptionVC)
        
        let thirdVC = storyboard.instantiateViewController(withIdentifier: "ThirdStepVC")
        controllers.append(thirdVC)
        
        return controllers
    }()
    
    // MARK: - Properties
    private var currentIndex = 0
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isModalInPresentation = true
        self.setViewControllers([viewControllerList[0]], direction: .forward, animated: false, completion: nil)

        // Do any additional setup after loading the view.
    }
    
 
    // MARK: - Functions
    func pushNext() {
        if currentIndex + 1 < viewControllerList.count {
          self.setViewControllers([self.viewControllerList[self.currentIndex + 1]], direction: .forward, animated: true, completion: nil)
            currentIndex += 1
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
