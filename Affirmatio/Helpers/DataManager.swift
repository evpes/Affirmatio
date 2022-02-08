//
//  DataManager.swift
//  Affirmatio
//
//  Created by evpes on 24.05.2021.
//

import Foundation
import RealmSwift

public class DataManager {
    let realm = try! Realm()
    
    // MARK: - Data manipulation methods
    
    func loadAffirmLists() -> Results<AffirmationsList> {
        return realm.objects(AffirmationsList.self)
    }
    
    func loadCategories() -> Results<AffirmationsCategory> {
        return realm.objects(AffirmationsCategory.self)
    }
    
    
    //MARK:- Data manipulation methods
    
    func saveCategories(category: AffirmationsCategory) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving categories context: \(error)")
        }
        
    }
    
    func addAffirmation(affirmationTxt: String,to category: AffirmationsCategory, withSound: String = "") {
        do {
            try self.realm.write {
                let newAffirm = Affirmation()
                newAffirm.affitmText = affirmationTxt
                newAffirm.categoryName = category.name
                newAffirm.soundPath = withSound
                category.affirmations.append(newAffirm)
            }
        } catch {
            print(error)
        }
    }
    
    func deleteList(list: AffirmationsList) {
        do {
            try realm.write {
                realm.delete(list)
            }
        } catch {
            print("Error while deleteng list:\(error)")
        }
    }
    
    //delete affirmation from ListVC
    func deleteAffirm(at path: IndexPath, from affirmsList: AffirmationsList?) {        
        if let _ = affirmsList?.affirmations[path.row] {
            do {
                try realm.write {
                    affirmsList?.affirmations.remove(at: path.row)
                }
            } catch  {
                print("Error during delete affirmation from list: \(error)")
            }
        }
        
    }
    
    //delete affirmation from CategoriesVC from List
    func deleteAffirm(_ affirm: Affirmation, from currentList: AffirmationsList?) {
        var idx = 0
        for (n, a) in currentList!.affirmations.enumerated() {
            if a.affitmText == affirm.affitmText {
                idx = n
            }
        }
        do {
            try realm.write {
                currentList?.affirmations.remove(at: idx)
            }
        } catch {
            print("Error while delete affirm from list: \(error)")
        }
    }
    
    //delete affirmation from CategoriesVC from Category
    func deleteAffirm(at affirmIndex: Int, from category: AffirmationsCategory) {
        do {
            try realm.write {
                category.affirmations.remove(at: affirmIndex)
            }
        } catch {
            print("Error while delete affirm from category: \(error)")
        }
    }
    
    //add new affirm to category from CategoriesVC
    func addAffirm(to category: AffirmationsCategory, with text: String, withSound: String = "") {
        do {
            try realm.write {
                let newAffirm = Affirmation()
                newAffirm.affitmText = text
                newAffirm.soundPath = withSound
                category.affirmations.append(newAffirm)
            }
        } catch {
            print("Error while add neew affirmation to category: \(error)")
        }
    }
    
    //add affirm to List from CategoriesVC
    func addAffirm(_ affirm: Affirmation, to currentList: AffirmationsList?) {
        do {
            try realm.write {
                currentList?.affirmations.append(affirm)
            }
        } catch {
            print("Error while append new affirm: \(error)")
        }
    }
    
    // MARK: - read/write contents
    
    func readContents() -> [WidgetContent] {
      var contents: [WidgetContent] = []
      let archiveURL = FileManager.sharedContainerURL().appendingPathComponent("contents.json")
      print(">>> \(archiveURL)")

      let decoder = JSONDecoder()
      if let codeData = try? Data(contentsOf: archiveURL) {
        do {
          contents = try decoder.decode([WidgetContent].self, from: codeData)
        } catch {
          print("Error: Can't decode contents")
        }
      }
      return contents
    }
    
    func writeContents( _ contents : [WidgetContent] ) {
        //var contents: [WidgetContent] = []
        
        
        let archiveURL = FileManager.sharedContainerURL().appendingPathComponent("contents.json")
        //archiveURL.removeAllCachedResourceValues()
        print(">>> \(archiveURL)")
        let encoder = JSONEncoder()
        if let dataToSave = try? encoder.encode(contents) {
          do {
            try dataToSave.write(to: archiveURL)
          } catch {
            print("Error: Can't write contents")
            return
          }
        }
    }
    
    //MARK: - Read/write settings
    
    func loadSettings(from path: URL?) -> [String : Float]  {
        var result : [String : Float] = [:]
        if let data = try? Data(contentsOf: path!) {
            let decoder = PropertyListDecoder()
            do {
                result = try decoder.decode([String : Float].self, from: data)
            } catch {
                print("Error decoding data to settings dict: \(error)")
            }
        } else {
            result = ["pause" : 15, "volume" : 0.25, "voiceGender" : 1, "userGender" : 1]
        }
        return result
    }
    
    func saveSettings(_ settings : [String : Float], to path : URL?) {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(settings)
            try data.write(to: path!)
        } catch {
            print("Error encoding settings dict:\(error)")
        }
    }
    
    func rewriteSettings() {
        //0 - male, 1 - female
        let settings = ["pause" : 15, "volume" : 0.25, "voiceGender" : 1, "userGender" : 1]
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Settings.plist")
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(settings)
            try data.write(to: path!)
        } catch {
            print("Error encoding settings dict:\(error)")
        }
    }
    
    func checkSettingsUpToDate() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Settings.plist")
        let currentSettings = loadSettings(from: path)
        if !currentSettings.keys.contains("userGender") {
            rewriteSettings()
        }
        
    }
    
}
