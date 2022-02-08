//
//  NewNotificationViewController.swift
//  Affirmatio
//
//  Created by evpes on 17.05.2021.
//

import UIKit

class NewNotificationViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var mon: UIButton!
    @IBOutlet weak var tue: UIButton!
    @IBOutlet weak var wed: UIButton!
    @IBOutlet weak var thu: UIButton!
    @IBOutlet weak var fri: UIButton!
    @IBOutlet weak var sat: UIButton!
    @IBOutlet weak var sun: UIButton!
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var unselectAllButton: UIButton!
    @IBOutlet weak var repeatSwitcherOutlet: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addNotificationButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    let center = UNUserNotificationCenter.current()
    
    var bgView : GradientBackground?
    var notificationEdit : AffirmNotification?
    var weekButtons : [UIButton] = []
    var allButtons : [UIButton] = []
    var daysSelected : [Int] = []
    var previousVC : NotificationsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weekButtons = [mon, tue, wed, thu, fri, sat,sun ]
        allButtons = [mon, tue, wed, thu, fri, sat, sun, selectAllButton, unselectAllButton]
        for button in allButtons {
            button.layer.cornerRadius = 15
            //button.isSelected = true
            //button.layer.borderWidth = 1
            button.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            button.titleLabel?.tintColor = .black
            button.isEnabled = false
            
            if button.tag == 11 {
                button.backgroundColor = UIColor.black.withAlphaComponent(0.7)
                button.titleLabel?.tintColor = .white
            }
            
            datePicker.setValue(UIColor.white, forKeyPath: "textColor")
            
            bgView = GradientBackground(frame: self.view.bounds)
            self.view.insertSubview(bgView!, at: 0)
            
        }
        
        addNotificationButton.layer.cornerRadius = 15
        //addNotificationButton.layer.borderWidth = 1
        addNotificationButton.titleLabel?.tintColor = .black
        addNotificationButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        
        
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("All set!")
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        
        
        if let _ = notificationEdit {
            setEditView()
        }
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bgView?.animateGradient()
        
        //self.checkNotificationsEnabled()
        
        
    }
    
    func setEditView() {
        if let notif = notificationEdit {
            if notif.repeatable {
                repeatSwitcherOutlet.isOn = true
                for button in allButtons {
                    button.isEnabled = true
                    if notif.weekDays.contains(button.tag) {
                        button.backgroundColor = .black
                        button.titleLabel?.tintColor = .white
                    }
                }
            }
            //addNotificationButton.titleLabel?.text = "Done"
            addNotificationButton.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)// = "Done"
            titleLabel.text = NSLocalizedString("Edit notification", comment: "")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let date = dateFormatter.date(from: "\(notif.hour):\(notif.minute)")
            datePicker.date = date!
            daysSelected = notif.weekDays
            
        }
    }
    
    @IBAction func repeatSwitcher(_ sender: UISwitch) {
        
        for button in allButtons {
            if sender.isOn {
                button.isEnabled = true
            } else {
                button.isEnabled = false
            }
        }
        
    }
    
    
    @IBAction func selectDay(_ sender: UIButton) {
        let isSelected = daysSelected.contains(sender.tag)
        print(sender.tag)
        if isSelected {
            let index = daysSelected.firstIndex(of: sender.tag)
            daysSelected.remove(at: index!)
            sender.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            sender.titleLabel?.tintColor = .black
            //print("unselected")
        } else {
            daysSelected.append(sender.tag)
            sender.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            sender.titleLabel?.tintColor = .white
            //print("selected")
        }
        print(daysSelected)
        //check array
        
    }
    
    @IBAction func selectAllButtonPressed(_ sender: UIButton) {
        daysSelected = []
        for (n,button) in weekButtons.enumerated() {
            Timer.scheduledTimer(withTimeInterval: Double(n)*0.025, repeats: false) { timer in
                self.daysSelected.append(button.tag)
                button.backgroundColor = UIColor.black.withAlphaComponent(0.7)
                button.titleLabel?.tintColor = .white
                
            }
            
        }
        //print("select all")
    }
    
    
    @IBAction func unselectAll(_ sender: UIButton) {
        daysSelected = []
        for (n,button) in weekButtons.reversed().enumerated() {
            Timer.scheduledTimer(withTimeInterval: 0.025 * Double(n), repeats: false) { timer in
                button.backgroundColor = UIColor.white.withAlphaComponent(0.2)
                button.titleLabel?.tintColor = .black
            }
        }
        //print("unselect all")
    }
    
    
    
    @IBAction func addNotificationButtonPressed(_ sender: Any) {
        
        let notificationAffirmsCount = Affirmations.notificationAffirmations.count
        print("add notification button pressed")
        if let notif = notificationEdit {
            center.removePendingNotificationRequests(withIdentifiers: notif.identifiers)
        }
        let date = datePicker.date
        let hour = Calendar.current.component(.hour, from: date)
        let minnute = Calendar.current.component(.minute, from: date)
        let id = UUID().uuidString
        //print(isNotificationsEnabled())
        if repeatSwitcherOutlet.isOn && daysSelected.count > 0 {
            for day in daysSelected {
                let notDate = createDate(weekDay: day, hour: hour, minute: minnute)
                //if isNotificationsEnabled() {
                scheduleNotification(at: notDate, body: Affirmations.notificationAffirmations[Int.random(in: 0...notificationAffirmsCount-1)], titles: "Affirmare", repeatWeekDays: true, id: id)
                print("button many notifications")
                //}
            }
        } else {
            let notDate = createDate(hour: hour, minute: minnute)
            //if isNotificationsEnabled() {
            scheduleNotification(at: notDate, body: Affirmations.notificationAffirmations[Int.random(in: 0...notificationAffirmsCount-1)], titles: "Affirmare", repeatWeekDays: false, id: id)
            print("button ine notification")
            //}
        }
        
        
    }
    
    func createDate(weekDay: Int = 0, hour: Int, minute: Int) -> Date {
        
        var components = DateComponents()
        if weekDay > 0 {
            components.weekday = weekDay
        }
        components.hour = hour
        components.minute = minute
        components.weekdayOrdinal = 10
        components.timeZone = .current
        
        let calendar = Calendar(identifier: .gregorian)
        
        return calendar.date(from: components)!
    }
    
    func isNotificationsEnabled(completion:@escaping (Bool)->() ) {
        center.getNotificationSettings() { (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                completion(true)
            default:
                completion(false)
            }
        }
    }
    
    func checkNotificationsEnabled() {
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
                DispatchQueue.main.async {
                    self.displayAlert()
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        }
    }
    
    func scheduleNotification(at date: Date, body: String, titles:String, repeatWeekDays: Bool, id: String) {
        
        isNotificationsEnabled { enabled in
            if enabled {
                var triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute], from: date)
                if !repeatWeekDays {
                    triggerWeekly = Calendar.current.dateComponents([.hour,.minute], from: date)
                }
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: repeatWeekDays)
                
                let content = UNMutableNotificationContent()
                content.title = titles
                content.body = body
                content.sound = UNNotificationSound.default
                content.categoryIdentifier = id
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().delegate = self
                
                UNUserNotificationCenter.current().add(request) {(error) in
                    print("notification added")
                    print(trigger)
                    if let error = error {
                        print("Uh oh! We had an error: \(error)")
                    }
                }
                if let vc = self.previousVC {
                                       
                    vc.loadNotifications()
                    DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.displayAlert()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
//        var triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute], from: date)
//        if !repeatWeekDays {
//            triggerWeekly = Calendar.current.dateComponents([.hour,.minute], from: date)
//        }
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: repeatWeekDays)
//
//        let content = UNMutableNotificationContent()
//        content.title = titles
//        content.body = body
//        content.sound = UNNotificationSound.default
//        content.categoryIdentifier = id
//
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().delegate = self
//        //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//        UNUserNotificationCenter.current().add(request) {(error) in
//            print("notification added")
//            print(trigger)
//            if let error = error {
//                print("Uh oh! We had an error: \(error)")
//            }
//        }
    }
    
    //MARK:- alert functions
    
    func displayAlert() {
        let alert = UIAlertController(title: NSLocalizedString("Notifications disabled", comment: ""), message: NSLocalizedString("To turn on notifications, you need enable notifications in Settings -> Affirmare -> Notifications", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default , handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Open Settings", comment: ""), style: .cancel, handler: { (action) in
            print("Open Settings")
            if let bundleIdentifier = Bundle.main.bundleIdentifier, let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
                if UIApplication.shared.canOpenURL(appSettings) {
                    UIApplication.shared.open(appSettings)
                }
            }
        }))
        UIApplication.shared.windows.last?.rootViewController?.present(alert, animated: true)
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
