//
//  PlayListViewController.swift
//  Affirmatio
//
//  Created by evpes on 11.05.2021.
//

import UIKit
import RealmSwift
import AVFoundation

class PlayListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let fireworkController = ClassicFireworkController()
    
    var bgView: GradientBackground?
    
    var affirmsPlayer: AVAudioPlayer!
    var bgMusicPlayer: AVAudioPlayer!
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Settings.plist")
    var settings : [String : Float] = [:]
    let dataManager = DataManager()
    
    var affirmations: List<Affirmation>?
    
    var finishImageNum = Int.random(in: 1...6)
    var timers: [Timer] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        settings = dataManager.loadSettings(from: dataFilePath)
        
        bgView = GradientBackground(frame: self.view.bounds)
        self.tableView.backgroundView = bgView
        self.view.insertSubview(bgView!, at: 0)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bgView?.animateGradient()
        let url = Bundle.main.url(forResource: "meditation", withExtension: "mp3")
        bgMusicPlayer = try! AVAudioPlayer(contentsOf: url!)
        bgMusicPlayer.volume = 0
        bgMusicPlayer.play()
        bgMusicPlayer.setVolume(settings["volume"]!, fadeDuration: 6)
        let ti = Float(affirmations?.count ?? 1) * settings["pause"]! - settings["pause"]!
        Timer.scheduledTimer(withTimeInterval: Double(ti), repeats: false) { (timer) in
            self.bgMusicPlayer.setVolume(0.1, fadeDuration: 9)
        }
        playAffirms()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("disappear")
        stopAffirms()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.9
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let affirm = affirmations {
            if affirm.count > 0 {
                print("numbersOfRows: \(affirm.count + 1)")
                return affirm.count + 1
            } else {
                return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playListCell") as! PlayListViewCell
        if let affirms = affirmations {
            cell.affirmLabel.font = UIFont(name: "Helvetica Neue", size: 35)
            cell.affirmLabel.layer.shadowOffset = CGSize(width: 2, height: 3)
            cell.affirmLabel.layer.shadowOpacity = 0.75
            cell.affirmLabel.layer.shadowRadius = 3
            cell.affirmLabel.textAlignment = .center
            if indexPath.row == affirms.count  {
                print("indexPath for last row \(indexPath)")
                cell.affirmLabel.textAlignment = .center
                cell.affirmLabel.text = [
                    NSLocalizedString("Good job!", comment: ""),
                    NSLocalizedString("You rock!", comment: ""),
                    NSLocalizedString("You rule!", comment: ""),
                    NSLocalizedString("Well done!", comment: "")
                ][Int.random(in: 0...3)]
                cell.affirmImageView.image = UIImage(named: "award\(finishImageNum)")
                //cell.affirmView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            } else {
                
                cell.affirmLabel.text = affirms[indexPath.row].affitmText                
                cell.affirmImageView.image = UIImage(named: "nature\(Int.random(in: 1...55))")//"\(affirms[indexPath.row].categoryName)\(Int.random(in: 1...20))")
                
            }
            
        }
        
        return cell
    }
    
    //MARK:- Buttons
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        stopAffirms()
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        playAffirms()
    }
    
    @IBAction func closeButton(_ sender: Any) {
        stopAffirms()
        print("before dismiss")
        self.dismiss(animated: true)
        print("after dismiss")
    }
    
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard var scrollingToIP = tableView.indexPathForRow(at: CGPoint(x: 0, y: targetContentOffset.pointee.y)) else {
            return
        }
        var scrollingToRect = tableView.rectForRow(at: scrollingToIP)
        let roundingRow = Int(((targetContentOffset.pointee.y - scrollingToRect.origin.y) / scrollingToRect.size.height).rounded())
        scrollingToIP.row += roundingRow
        scrollingToRect = tableView.rectForRow(at: scrollingToIP)
        targetContentOffset.pointee.y = scrollingToRect.origin.y
    }
    func stopAffirms() {
        print("stop affirms")
        if let player = affirmsPlayer {
            player.stop()
        }
        bgMusicPlayer.stop()
        for timer in timers {
            timer.invalidate()
        }
    }
    
    func playAffirms() {
        let voiceGender = settings["voiceGender"] ?? 1
        let voice = voiceGender == 1 ? "f" : "m"
        if let affirms = affirmations {
            
            for n in 0...affirms.count {
                let indexPath = IndexPath(row: n, section: 0)
                
                if n < affirms.count {
                    let timer = Timer.scheduledTimer(withTimeInterval: Double(n) * Double(settings["pause"]!), repeats: false) { [self] (timer) in
                        DispatchQueue.main.async {
                            print("sound \(n) interval \(Double(n) * Double(settings["pause"]!))")
                            self.playSound(key: "\(affirms[n].affitmText)+\(voice)", format: "mp3")
                            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                        }
                    }
                    print("timer :\(timer)")
                    print("timers :\(timers)")
                    timers.append(timer)
                }
                
                else {
                    let timer = Timer.scheduledTimer(withTimeInterval: Double(n) * Double(settings["pause"]!), repeats: false) { (timer) in
                        print("gong interval \(Double(n) * Double(self.settings["pause"]!))")
                        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                        self.playSound(key: "gong", format: "wav")
                        print(indexPath)
                        //let cell = self.tableView.cellForRow(at: indexPath) as! PlayListViewCell
                        //self.fireworkController.addFireworks(count: 4, sparks: 8, around: cell.affirmLabel)
                    }
                    let timer2 = Timer.scheduledTimer(withTimeInterval: Double(n) * Double(settings["pause"]! + 0.5), repeats: false) { (timer) in
                        print("firework interval \(Double(n) * Double(self.settings["pause"]!))")
                        let cell = self.tableView.cellForRow(at: indexPath) as! PlayListViewCell
                        self.fireworkController.addFireworks(count: 8, sparks: 8, around: cell.affirmLabel)
                        self.fireworkController.addFireworks(count: 8, sparks: 8, around: cell.affirmImageView)
                    }
                    timers.append(timer)
                    timers.append(timer2)
                    let timer3 = Timer.scheduledTimer(withTimeInterval: Double(n) * Double(settings["pause"]!) + 10, repeats: false) { (timer) in
                        //DispatchQueue.main.async {
                        print("dismiss interval \(Double(n) * Double(self.settings["pause"]!) + 10)")
                        self.dismiss(animated: true, completion: nil)
                        //}
                    }
                    timers.append(timer3)
                }
            }
            
        }
    }
    
    func playSound(key: String, format: String = "m4a") {
        let urlOp = Bundle.main.url(forResource: key, withExtension: format)
        if let url = urlOp {
            print(url)
            affirmsPlayer = try! AVAudioPlayer(contentsOf: url)
            affirmsPlayer.play()
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        print("dismiss")
        if let _ = affirmsPlayer {
            affirmsPlayer.stop()
        }
        
        bgMusicPlayer.stop()
        super.dismiss(animated: flag, completion: completion)
        
    }
    
    
}


