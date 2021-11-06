//
//  AvatarImagePicker.swift
//  OrderSheet
//
//  Created by yum on 2021/11/05.
//

import SwiftUI

struct AvatarImagePicker: View {
    @Binding var selectedImage: UIImage?
    var defaultImageName: String
    var width: CGFloat = 120
    var height: CGFloat = 120
    
    @State private var showingImagePicker = false
    
    var body: some View {
        ZStack {
            AvatarImage(image: self.selectedImage, defaultImageName: self.defaultImageName, width: self.width, height: self.height)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: "camera.circle.fill")
                        .resizable()
                        .frame(width: self.width * 0.4, height: self.height * 0.4)
                        .foregroundColor(Color("Main"))
                        .background(Color(UIColor.systemBackground))
                        .clipShape(Circle())
                }
            }
            .frame(width: self.width, height: self.height)
        }
        .onTapGesture {
            self.showingImagePicker = true
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePickerController(sourceType: .photoLibrary, selectedImage: self.$selectedImage)
        }
    }
}

struct AvatarImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AvatarImagePicker(selectedImage: .constant(nil), defaultImageName: "person.crop.circle.fill")
            AvatarImagePicker(selectedImage: .constant(nil), defaultImageName: "person.2.circle.fill")
        }
    }
}
