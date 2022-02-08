//
//  SettingsTVC.swift
//  Affirmatio
//
//  Created by evpes on 31.01.2022.
//

import UIKit
import StoreKit

class SettingsTVC: UITableViewController {

    var bgView: GradientBackground?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bgView = GradientBackground(frame: self.view.bounds)
        self.tableView.backgroundView = bgView!
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        bgView!.animateGradient()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        case 2:
            return 2
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("Audio settings", comment: "")
        case 1:
            return NSLocalizedString("Premium", comment: "")
        case 2:
            return NSLocalizedString("Feedback", comment: "")
        default:
            return "  "
        }
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .clear
            headerView.backgroundView?.backgroundColor = .clear
            headerView.textLabel?.textColor = .white
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        if indexPath.section == 0 {
            let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right")?.withTintColor(.white))
            cell.accessoryView = chevronImageView
            cell.accessoryView?.tintColor = .white
            
            
            switch indexPath.row {
            case 0:
                configuration.text = NSLocalizedString("Time between affirmations", comment: "")
            case 1:
                configuration.text = NSLocalizedString("Background music volume", comment: "")
            case 2:
                configuration.text = NSLocalizedString("Affirmations voice", comment: "")
            default:
                print("default row")
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                configuration.text = NSLocalizedString("Get premium subscription", comment: "")
                configuration.image = UIImage(systemName: "star.fill")
                cell.tintColor = .yellow
            default:
                print("default row")
            }
        } else if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                configuration.text = NSLocalizedString("Rate us on App Store", comment: "")
                configuration.image = UIImage(systemName: "star.square.fill")
                cell.tintColor = .systemBlue
            case 1:
                configuration.text = NSLocalizedString("Contact the Developer", comment: "")
                configuration.image = UIImage(systemName: "mail")
                cell.tintColor = .systemBlue
            default:
                print("default row")
            }
        } else if indexPath.section == 3 {
            switch indexPath.row {
            case 0:
                configuration.text = NSLocalizedString("Close settings", comment: "") 
                configuration.image = UIImage(systemName: "xmark.circle")
                cell.tintColor = .systemRed
            default:
                print("default row")
            }
        }
        configuration.textProperties.color = .white
        
        cell.backgroundColor = .clear
        cell.contentConfiguration = configuration

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                performSegue(withIdentifier: "settingsTime", sender: self)
            case 1:
                performSegue(withIdentifier: "settingsMusic", sender: self)
            case 2:
                performSegue(withIdentifier: "settingsVoice", sender: self)
            default:
                print("default row")
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                performSegue(withIdentifier: "settingsToSubscription", sender: self)
            default:
                print("default row")
            }
        } else if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                rateApp()
            case 1:
                mailDev()
            default:
                print("default row")
            }
        } else if indexPath.section == 3 {
            switch indexPath.row {
            case 0:
                self.dismiss(animated: true, completion: nil)
            default:
                print("default row")
            }
        }
        
        
    }
    
    func mailDev() {
        let email = "apsterio.anima@gmail.com"
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }
    
    func rateApp() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    

}
