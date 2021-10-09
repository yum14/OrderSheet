//
//  NewTeamPresenter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/21.
//

import Foundation
import SwiftUI
import Combine

final class NewTeamPresenter: ObservableObject {
    private let interactor: NewTeamUsecase
    
    @Published var text: String
    private var onCommit: (String) -> Void = { _ in }
    private var onCanceled: () -> Void = {}
    
    init(interactor: NewTeamUsecase,
         onCommit: @escaping (String) -> Void = { _ in },
         onCanceled: @escaping () -> Void = {}) {
        
        self.interactor = interactor
        self.text = ""
        self.onCommit = onCommit
        self.onCanceled = onCanceled
    }
    
    func inputCommit(user: User) -> Void {
        self.interactor.addTeam(user: user, name: self.text, completion: { result in
            switch result {
            case .success(let team):
                if let team = team {
                    print("new team was registered. id: \(team.id)")
                } else {
                    print("new team creation was failed. team: \(self.text)")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
        
        self.onCommit(self.text)
    }
    
    func inputCancel() -> Void {
        self.onCanceled()
    }
}
