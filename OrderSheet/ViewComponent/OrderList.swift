//
//  OrderList.swift
//  OrderSheet
//
//  Created by yum on 2021/09/08.
//

import SwiftUI
import Firebase

struct OrderList: View {
    var orders: [Order] = []
    var onRowTap: (Order) -> Void = { _ in }
    var onUnlockButtonTap: (Order) -> Void = { _ in }
    
    var body: some View {
        let group = Dictionary(grouping: self.orders, by: { DateUtility.toString(date: $0.createdAt.dateValue(), template: "ydMMM") })
        let keys = group.map { $0.key }.sorted(by: { $0 > $1 })
        
        List {
            ForEach(keys, id: \.self) { key in
                Section(header: Text(key)) {
                    let values = group[key]?.compactMap { $0 }.sorted(by: { $0.createdAt.dateValue() > $1.createdAt.dateValue()})
                    
                    ForEach(values!, id: \.id) { value in
                        HStack(spacing: 0) {
                            HStack(spacing: 0) {
                                if value.committed {
                                    Text(value.name)
                                        .strikethrough()
                                } else {
                                    Text(value.name)
                                }
                                Spacer()
                            }
                            .background(Color(UIColor.systemBackground))
                            .onTapGesture {
                                self.onRowTap(value)
                            }
                            
                            if value.committed {
                                UnlockButton {
                                    self.onUnlockButtonTap(value)
                                }
                                .padding(0)
                                .buttonStyle(BorderlessButtonStyle())
                            }
                        }
                        .listRowInsets(.init(top: 0, leading: 20, bottom: 0, trailing: 20))
                    }
                }
            }
        }
    }
}

struct OrderList_Previews: PreviewProvider {
    static var previews: some View {
        let template = "yyyy/MM/dd HH:mm:ss"
        let orders = [Order(name: "オーダー1", committed: true, createdAt: DateUtility.toDate(dateString: "2021/01/01 01:00:00", template: template)),
                      Order(name: "オーダー2", createdAt: DateUtility.toDate(dateString: "2021/01/01 12:00:00", template: template)),
                      Order(name: "オーダー3", createdAt: DateUtility.toDate(dateString: "2021/01/02 01:00:00", template: template))]
        
        OrderList(orders: orders)
    }
}
