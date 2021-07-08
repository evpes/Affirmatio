//
//  EntryContent.swift
//  Affirmatio
//
//  Created by evpes on 23.05.2021.
//

import SwiftUI
struct EntryView : View {
    
    let model: WidgetContent

    var body: some View {
        Text(model.affirmText)
            .padding(5)
    }

}


