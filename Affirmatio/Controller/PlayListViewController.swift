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
    
    
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
        
    let gradientOne = UIColor(red: 48/255, green: 62/255, blue: 103/255, alpha: 1).cgColor
    let gradientTwo = UIColor(red: 244/255, green: 88/255, blue: 53/255, alpha: 1).cgColor
    let gradientThree = UIColor(red: 196/255, green: 70/255, blue: 107/255, alpha: 1).cgColor
    
    var player: AVAudioPlayer!
    var player2: AVAudioPlayer!
    
    var affrirmations: List<Affirmation>?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let bgView = UIView()
        gradientSet.append([gradientOne, gradientTwo])
        gradientSet.append([gradientTwo, gradientThree])
        gradientSet.append([gradientThree, gradientOne])
        
        
        gradient.frame = self.view.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        gradient.drawsAsynchronously = true
    
    self.tableView.backgroundView = bgView
    bgView.layer.addSublayer(gradient)
        animateGradient()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let url = Bundle.main.url(forResource: "meditation", withExtension: "mp3")
        player2 = try! AVAudioPlayer(contentsOf: url!)
        player2.volume = 0
        player2.play()
        player2.setVolume(0.4, fadeDuration: 6)
        let ti = Double(affrirmations?.count ?? 1) * 15.0 - 15
        Timer.scheduledTimer(withTimeInterval: ti, repeats: false) { (timer) in
            self.player2.setVolume(0.1, fadeDuration: 9)
        }
        
        
        
        //playSound(key: "meditation", format: "mp3")
        playAffirms()
        
    }
    
    func animateGradient() {
            if currentGradient < gradientSet.count - 1 {
                currentGradient += 1
            } else {
                currentGradient = 0
            }
            
            let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
            gradientChangeAnimation.duration = 5.0
            gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
            gradientChangeAnimation.isRemovedOnCompletion = false
            gradient.add(gradientChangeAnimation, forKey: "colorChange")
        }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.9
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return affrirmations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playListCell") as! PlayListViewCell
        if let affirms = affrirmations {
            let cornerRadius : CGFloat = 25.0
            cell.affirmLabel.text = affirms[indexPath.row].affitmText
            cell.affirmImageView.image = UIImage(named: "nature\(indexPath.row + 1)")
            cell.affirmView.layer.cornerRadius = cornerRadius
            cell.affirmView.layer.shadowOffset = CGSize(width: 3, height: 3)
            cell.affirmView.layer.shadowColor = UIColor.darkGray.cgColor
            cell.affirmView.layer.shadowOpacity = 0.7
            cell.affirmImageView.layer.cornerRadius = cornerRadius
            cell.affirmImageView.clipsToBounds = true
            cell.backgroundColor = .clear
            
            cell.affirmLabel.textColor = .white
            cell.affirmLabel.shadowOffset = CGSize(width: 1.0, height: 1.0)
            cell.affirmLabel.shadowColor = .black
            
//            let cornerRadius : CGFloat = 25.0
//
//            override func viewDidLoad() {
//                super.viewDidLoad()
//
//                // Do any additional setup after loading the view.
//
//                containerView.layer.cornerRadius = cornerRadius
//                containerView.layer.shadowColor = UIColor.darkGray.cgColor
//                containerView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
//                containerView.layer.shadowRadius = 25.0
//                containerView.layer.shadowOpacity = 0.9
//
//                imageView.layer.cornerRadius = cornerRadius
//                imageView.clipsToBounds = true
        }
        
        return cell
    }
    
    func playAffirms() {
        if let affirms = affrirmations {
            for (n,a) in affirms.enumerated() {
                Timer.scheduledTimer(withTimeInterval: Double(n) * 15, repeats: false) { (timer) in
                    let indexPath = IndexPath(row: n, section: 0)
                    DispatchQueue.main.async {
                        self.playSound(key: affirms[n].affitmText)
                        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    }
                    
                }
                
                if n == affirms.count - 1 {
                    Timer.scheduledTimer(withTimeInterval: Double(n + 1) * 15, repeats: false) { (timer) in
                        let indexPath = IndexPath(row: n, section: 0)
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                    }
                }
            }
        }
    }
    
    func playSound(key: String, format: String = "m4a") {
        let url = Bundle.main.url(forResource: key, withExtension: format)
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
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

extension PlayListViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
}
