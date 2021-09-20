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
    @Binding var contents: [EditableListContent]
    
    var body: some View {
        
        List {
            ForEach(self.contents, id: \.self) { content in
                HStack {
                    
                    EditableListRow(id: content.id, text: content.text) { id, text in
                        if let index = self.contents.firstIndex(where: { $0.id == id }) {
                            if text.isEmpty {
                                self.contents.remove(at: index)
                            } else {
                                self.contents[index].text = text
                            }
                        }
                    }
                    .contentShape(Rectangle())
                    
                    RemoveButton(backgroundColor: .gray) {
                        if let index = self.contents.firstIndex(where: { $0.id == content.id }) {
                            self.contents.remove(at: index)
                        }
                        UIApplication.shared.closeKeyboard()
                    }
                }
            }
        }
    }
}

struct EditableListRow: View {
    var id: String
    @State var text = ""
    var onCommit: (String, String) -> Void = { _, _ in }
    var body: some View {
        TextField("新しいアイテム", text: self.$text, onCommit: {
            self.onCommit(id, self.text)
        })
    }
}

struct EditableList_Previews: PreviewProvider {
    static var previews: some View {
        let contents: [EditableListContent] = [EditableListContent(text: "🐶"),
                                               EditableListContent(text: "🐱")]

        EditableList(contents: .constant(contents))
    }
}
