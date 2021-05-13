//
//  ListImageSelectionViewController.swift
//  Affirmatio
//
//  Created by evpes on 12.05.2021.
//

import UIKit

class ListImageSelectionViewController: UIViewController {
    
    let sectionsInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    let itemsPerRow: CGFloat = 2
    var currentImage: String?
    var previousImageIndex: IndexPath?
    var prevVC : CreatePlaylistViewController?
    
    var images : [String] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        // Do any additional setup after loading the view.
        for i in 1..<13 {
            images.append("nature\(i)")
        }
        print("images.count = \(images.count)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        let cell = collectionView.cellForItem(at: indexPath) as! ListImageViewCell
        if let index = previousImageIndex {
            let previousCell = collectionView.cellForItem(at: index) as! ListImageViewCell
            previousCell.layer.borderWidth = 0
        }
        cell.layer.borderWidth = 5
        cell.layer.borderColor = UIColor.black.cgColor
        previousImageIndex = indexPath
        currentImage = images[indexPath.row]
        print(currentImage)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        if let vc = prevVC {
            vc.pictureName = currentImage!
            vc.listImage.image = UIImage(named: currentImage!)
        }
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension ListImageSelectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ListImageViewCell
        let imageIndex = indexPath.row 
        cell.listImageView.image = UIImage(named: images[imageIndex])
        
        cell.listImageView.contentMode = .scaleAspectFill
        cell.listImageView.layer.masksToBounds = true
        cell.listImageView.clipsToBounds = true
        
        cell.backgroundColor = .clear
        
        //configure the cell
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.cornerRadius = 13
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        cell.layer.shadowRadius = 3.0
        cell.layer.shadowOpacity = 0.6
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
    
}

extension ListImageSelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingWidth = sectionsInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionsInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionsInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionsInsets.left
    }
}
