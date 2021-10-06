//
//  HomeInteractor.swift
//  OrderSheet
//
//  Created by yum on 2021/10/06.
//

import Foundation

protocol HomeUsecase {
    func addSnapshotListener(onListen: @escaping ([Team]) -> Void)
}

final class HomeInteractor {
    let store = TeamStore()
    
    init() {}
}

extension HomeInteractor: HomeUsecase {
    func addSnapshotListener(onListen: @escaping ([Team]) -> Void) {
        self.store.addSnapshotListener(onListen: onListen)
    }
}
