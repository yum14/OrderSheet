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
    @Published var text: String
    @Published var showingDismissConfirm = false

    private let interactor: NewTeamUsecase
    private var onCommit: ((String) -> Void)?
    private var onCanceled: (() -> Void)?

    private var profile: Profile
    
    var editing: Bool {
        return !self.text.isEmpty
    }
    
    init(interactor: NewTeamUsecase,
         profile: Profile,
         onCommit: ((String) -> Void)?,
         onCanceled: (() -> Void)?) {
        
        self.interactor = interactor
        self.profile = profile
        self.text = ""
        self.onCommit = onCommit
        self.onCanceled = onCanceled
    }
    
    func inputCommit() -> Void {
        if self.profile.teams.count >= 10 {
            return
        }
        
        self.interactor.addTeam(profile: self.profile, name: self.text) { result in
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
            
            self.onCommit?(self.text)
        }
    }
    
    func inputCancel() -> Void {
        self.onCanceled?()
    }
    
    func showDismissConfirm() {
        self.showingDismissConfirm = true
    }
}
