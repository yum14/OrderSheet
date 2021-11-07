//
//  AvatarImage.swift
//  OrderSheet
//
//  Created by yum on 2021/11/06.
//

import SwiftUI

struct AvatarImage: View {
    var image: UIImage?
    var defaultImageName: String = "person.crop.circle.fill"
    var length: CGFloat = 120
    
    var body: some View {
        Group {
            if let image = self.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                Image(systemName: self.defaultImageName)
                    .resizable()
                    .foregroundColor(Color.secondary)
            }
        }
        .frame(width: self.length, height: self.length)
        .clipShape(Circle())
    }
}

struct AvatarImage_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AvatarImage()
            AvatarImage(defaultImageName: "person.2.circle.fill")
        }
    }
}
