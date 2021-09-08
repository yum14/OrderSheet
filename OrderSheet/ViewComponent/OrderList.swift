//
//  OrderList.swift
//  OrderSheet
//
//  Created by yum on 2021/09/08.
//

import SwiftUI

struct OrderList: View {
    var orders: [Order] = []
    
    var body: some View {
        
        let group = Dictionary(grouping: self.orders, by: { DateUtility.toString(date: $0.createdAt, template: "ydMMM") })
        let keys = group.map { $0.key }.sorted(by: { $0 > $1 })
        
        List {
            ForEach(keys, id: \.self) { key in
                Section(header: Text(key)) {
                    let values = group[key]?.compactMap { $0 }.sorted(by: { $0.createdAt > $1.createdAt})
                    
                    ForEach(values!, id: \.id) { value in
                        Text(value.name)
                    }
                }
            }
        }
    }
}

struct OrderList_Previews: PreviewProvider {
    static var previews: some View {
        let template = "yyyy/MM/dd HH:mm:ss"
        let orders = [Order(name: "オーダー1", createdAt: DateUtility.toDate(dateString: "2021/01/01 01:00:00", template: template)),
                      Order(name: "オーダー2", createdAt: DateUtility.toDate(dateString: "2021/01/01 12:00:00", template: template)),
                      Order(name: "オーダー3", createdAt: DateUtility.toDate(dateString: "2021/01/02 01:00:00", template: template))
        ]
        
        OrderList(orders: orders)
    }
}
