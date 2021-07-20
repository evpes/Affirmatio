//
//  NotificationsViewController.swift
//  Affirmatio
//
//  Created by evpes on 17.05.2021.
//

import UIKit

class NotificationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let center = UNUserNotificationCenter.current()
    var notifications: [AffirmNotification] = []
    var bgView : GradientBackground?
    
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        // Do any additional setup after loading the view.
        
        loadNotifications()
        
        bgView = GradientBackground(frame: self.view.bounds)
        self.view.insertSubview(bgView!, at: 0)
        
        //print("notifications \(notifications)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //print("notifications \(notifications)")
        tableView.reloadData()
        bgView?.animateGradient()
    }
    
    @IBAction func addNotificationButton(_ sender: Any) {
    }
    
    // MARK : - TableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(notifications.count)
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       if editingStyle == .delete {
           // Delete the row from the data source
           //print("delete")
           deleteNotification(path: indexPath)
           tableView.deleteRows(at: [indexPath], with: .fade)
       } else if editingStyle == .insert {
           // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
       }
   }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationViewCell
        
            cell.selectionStyle = .none
        
        let hour = "\(notifications[indexPath.row].hour)"
        let minute = notifications[indexPath.row].minute < 10 ? "0\(notifications[indexPath.row].minute)" : "\(notifications[indexPath.row].minute)"
        var days = ""
        for day in notifications[indexPath.row].weekDays.sorted() {
            switch day {
            case 2:
                days += NSLocalizedString("Mon ", comment: "")
            case 3:
                days += NSLocalizedString("Tue ", comment: "")
            case 4:
                days += NSLocalizedString("Wed ", comment: "")
            case 5:
                days += NSLocalizedString("Thu ", comment: "")
            case 6:
                days += NSLocalizedString("Fri ", comment: "")
            case 7:
                days += NSLocalizedString("Sat ", comment: "")
            case 1:
                days += NSLocalizedString("Sun ", comment: "")
            default:
                print("default")
            }
        }
        
        cell.timeLabel.text = "\(hour):\(minute)"
        cell.daysLabel.text = days
        //cell.textLabel?.text = "\(notifications[indexPath.row].hour):\(notifications[indexPath.row].minute) "
        return cell
    }
    
    func loadNotifications() {
        //print("load notifications")
        center.getPendingNotificationRequests(completionHandler: { requests in
            //print("getPendingNotificationRequests")
            DispatchQueue.main.async {
                //print("requests: \(requests)")
                self.notifications = requests.reduce([]) { (res, req) -> [AffirmNotification] in
                    //print("res = \(res)")
                    var result = res
                    let trigger = req.trigger as! UNCalendarNotificationTrigger
                    if res.count == 0 {
                        return [AffirmNotification(hour: trigger.dateComponents.hour!, minute: trigger.dateComponents.minute!, weekDays: [trigger.dateComponents.weekday ?? 0], groupId: req.content.categoryIdentifier, identifiers: [req.identifier])]
                    } else {
                        for (n,r) in res.enumerated() {
                            if req.content.categoryIdentifier == r.groupId {
                                result[n].identifiers.append(req.identifier)
                                result[n].weekDays.append(trigger.dateComponents.weekday ?? 0)
                                //print("middle result \(result))")
                                print(req.identifier)
                                return result
                            }
                        }
                    }
                    print(req.identifier)
                    let newNotification = AffirmNotification(hour: trigger.dateComponents.hour!, minute: trigger.dateComponents.minute!, weekDays: [trigger.dateComponents.weekday ?? 0], groupId: req.content.categoryIdentifier, identifiers: [req.identifier])
                    result.append(newNotification)
                    //print("last result \(result)")
                    return result
                }
                self.tableView.reloadData()
            }//outer dispatcqueue
        })
    }
    
    func deleteNotification(path: IndexPath) {
        let identifiers = notifications[path.row].identifiers
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
        notifications.remove(at: path.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "newNotification", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newNotification" {
            let vc = segue.destination as! NewNotificationViewController
            vc.previousVC = self
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.notificationEdit = notifications[indexPath.row]
            }
        }
    }

    
}
