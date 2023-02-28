//
//  CustomImagePicker.swift
//  MSG
//
//  Created by zooey on 2023/02/23.
//

import SwiftUI
import PhotosUI

struct CustomImagePicker<Content: View>: View {
    var content: Content
    var options: [Crop]
    @Binding var show: Bool
    @Binding var croppedImage: UIImage?
    init(options: [Crop], show: Binding<Bool>, croppedImage: Binding<UIImage?>, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self._show = show
        self._croppedImage = croppedImage
        self.options = options
    }
    
    @State private var photoItem: PhotosPickerItem?
    @State private var selectedImageData: Data? = nil
    @State private var profileImage: UIImage? = nil
    @State private var showDialog: Bool = false
    @State private var selectedCropType: Crop = .circle
    @State private var showCropView: Bool = false
    
    var body: some View {
        content
            .photosPicker(isPresented: $show, selection: $photoItem)
            .onChange(of: photoItem) { newItem in
                if let newItem {
                    Task {
                        if let imageData = try? await newItem.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                            await MainActor.run(body: {
                                profileImage = image
                                showDialog.toggle()
                            })
                        }
                    }
                }
            }
            .confirmationDialog("", isPresented: $showDialog) {
                ForEach(options.indices, id: \.self) { index in
                    Button(options[index].name()) {
                        selectedCropType = options[index]
                        showCropView.toggle()
                    }
                }
                Button("취소", role: .cancel) {}
            }
            .fullScreenCover(isPresented: $showCropView) {
                profileImage = nil
            } content: {
                CropView(crop: selectedCropType, image: profileImage) { croppedImage, status in
                    if let croppedImage {
                        self.croppedImage = croppedImage
                    }
                }
            }
    }
}

//struct CustomImagePicker_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomImagePicker(content: <#_#>)
//    }
//}


