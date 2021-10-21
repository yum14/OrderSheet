//
//  TeamSelectList.swift
//  OrderSheet
//
//  Created by yum on 2021/10/20.
//

import SwiftUI

struct TeamSelectList: View {
    var teams: [Team]?
    @Binding var selectedTeam: Team?
    
    var body: some View {
        VStack {
            ForEach(self.teams ?? [], id: \.self) { team in
                HStack {
                    Circle()
                        .frame(width: 28, height: 28)
                    
                    Text(team.name)
                        .padding(.horizontal, 8)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if let selectedTeam = self.selectedTeam, selectedTeam.id == team.id {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color("Main"))
                            .font(.title2)
                    }
                }
                .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                .contentShape(Rectangle())
                .onTapGesture {
                    self.selectedTeam = team
                }
                
                if team.id != self.teams!.last!.id {
                    Divider()
                }
            }
        }
    }
}

struct TeamSelectRow_Previews: PreviewProvider {
    static var previews: some View {
        TeamSelectList(teams: [Team(name: "A", members: [], owner: ""),
                               Team(name: "B", members: [], owner: ""),
                               Team(name: "C", members: [], owner: "")],
                       selectedTeam: .constant(nil))
    }
}
