//
//  FileManager+Ext.swift
//  Affirmatio
//
//  Created by evpes on 23.05.2021.
//

import Foundation

extension FileManager {
  static func sharedContainerURL() -> URL {
    return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: "group.affirmatio.contents"
    )!
  }
}
