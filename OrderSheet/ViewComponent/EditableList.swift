//
//  EditableList.swift
//  OrderSheet
//
//  Created by yum on 2021/09/16.
//

import SwiftUI

struct EditableListContent: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var text: String
}

struct EditableList: View {
    @State private var contents: [EditableListContent] = [EditableListContent(text: "🐶"),
                                                          EditableListContent(text: "🐱")]
    
    var body: some View {
        List {
            ForEach(self.contents, id: \.self) { content in
                HStack {
                    EditableListRow(container: self.$contents,
                                    content: content,
                                    text: content.text)
                    
                    if let index = self.contents.firstIndex(where: { $0.id == content.id }) {
                        if index == self.contents.count - 1 {
                            PlusMinusButton(icon: .plus,
                                            onTap: { self.contents.append(EditableListContent(text: "new" + String(index))) })
                        } else {
                            PlusMinusButton(icon: .minus,
                                            backgroundColor: .gray,
                                            onTap: { self.contents.remove(at: index) })
                        }
                    }
                }
            }
        }
    }
}

struct EditableListRow: View {
    @Binding var container: [EditableListContent]
    var content: EditableListContent
    @State var text = ""
    
    var body: some View {
        TextField("", text: self.$text, onCommit: {
            if let index = self.container.firstIndex(where: { $0.id == self.content.id }) {
                self.container[index].text = self.text
            }
        })
        
    }
}

struct EditableList_Previews: PreviewProvider {
    static var previews: some View {
        EditableList()
    }
}
