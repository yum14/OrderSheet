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
    var length: CGFloat = 120
    
    @State private var showingImagePicker = false
    private let magnification: Double = 0.75
    
    var body: some View {
        ZStack {
            AvatarImage(image: self.selectedImage, defaultImageName: self.defaultImageName, length: self.length)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: "camera.circle.fill")
                        .resizable()
                        .frame(width: self.length * 0.3, height: self.length * 0.3)
                        .foregroundColor(Color("Main"))
                        .background(Color(UIColor.systemBackground))
                        .clipShape(Circle())
                }
            }
            .frame(width: self.length, height: self.length)
        }
        .onTapGesture {
            self.showingImagePicker = true
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePickerController(sourceType: .photoLibrary) { uiImage in
                
                let originScale = uiImage.size.width > uiImage.size.height ? uiImage.size.height / self.length : uiImage.size.width / self.length
                let scale = originScale * self.magnification
                
                let xOffset = (uiImage.size.width - self.length * scale) / 2
                let yOffset = (uiImage.size.height - self.length * scale) / 2
                
                if let cgImage = uiImage.cgImage {
                    let clipRect = CGRect(x: xOffset, y: yOffset, width: self.length * scale, height: self.length * scale)
                    let crippedImage = UIImage(cgImage: cgImage.cropping(to: clipRect)!)
                    let compressionImageData = crippedImage.jpegData(compressionQuality: 0.01)!
                    
                    self.selectedImage = UIImage(data: compressionImageData)
                }
            }
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
