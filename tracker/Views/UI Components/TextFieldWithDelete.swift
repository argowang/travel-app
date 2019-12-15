//
//  TextFieldWithDeleteView.swift
//  tracker
//
//  Created by TechLead on 12/15/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import SwiftUI

struct TextFieldWithDelete: View {
    private var defaultText: String
    @Binding var text: String
    
    init(_ defaultTextInput: String, text textBinding:Binding<String>) {
        defaultText = defaultTextInput
        self._text = textBinding
    }
    
    var body: some View {
        HStack {
            TextField(defaultText, text: $text).foregroundColor(.primary)
            
            Button(action: {
                self.text = ""
            }) {
                Image(systemName: "xmark.circle.fill").opacity(text == "" ? 0 : 1)
            }.foregroundColor(.gray)
        }
    }
}

struct TextFieldWithDelete_Previews: PreviewProvider {
    @State static var searchString = "s"
    static var previews: some View {
        TextFieldWithDelete("Search",text: $searchString)
    }
}
