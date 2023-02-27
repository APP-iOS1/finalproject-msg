//
//  CropView.swift
//  MSG
//
//  Created by zooey on 2023/02/23.
//

import SwiftUI

struct CropView: View {
    
    var crop: Crop
    var image: UIImage?
    var onCrop: (UIImage?, Bool) -> ()
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 0
    @State private var offset: CGSize = .zero
    @State private var lastStoredOffset: CGSize = .zero
    @GestureState private var isInteracting: Bool = false
    
    let attrs = [
        NSAttributedString.Key.foregroundColor: UIColor(Color("Color2")),
        NSAttributedString.Key.font: UIFont(name: "MaplestoryOTFBold", size: 24)!
    ]
    
    init(crop: Crop, image: UIImage?, onCrop: @escaping (UIImage?, Bool) -> ()) {
        self.crop = crop
        self.image = image
        self.onCrop = onCrop
        UINavigationBar.appearance().titleTextAttributes = attrs
    }
    
    var body: some View {
        
        NavigationStack {
            ImageView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("Color1").ignoresSafeArea())
                .navigationTitle("이미지 자르기")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            let renderer = ImageRenderer(content: ImageView())
                            renderer.proposedSize = .init(crop.size())
                            if let image = renderer.uiImage {
                                onCrop(image, true)
                            } else {
                                onCrop(nil, false)
                                print("Error---------------------->")
                            }
                            dismiss()
                        } label: {
                            Image(systemName: "checkmark")
                        }
                    }
                }
        }
        .foregroundColor(Color("Color2"))
    }
    
    @ViewBuilder
    func ImageView() -> some View {
        let cropSize = crop.size()
        GeometryReader {
            let size = $0.size
            
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay {
                        GeometryReader { proxy in
                            let rect = proxy.frame(in: .named("CROPVIEW"))
                            Color.clear
                                .onChange(of: isInteracting) { newValue in
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        if rect.minX > 0 {
                                            offset.width = (offset.width - rect.minX)
                                            haptics(.medium)
                                        }
                                        if rect.minY > 0 {
                                            offset.height = (offset.height - rect.minY)
                                            haptics(.medium)
                                        }
                                        if rect.maxX < size.width {
                                            offset.width = (rect.minX - offset.width)
                                            haptics(.medium)
                                        }
                                        if rect.maxY < size.height {
                                            offset.height = (rect.minY - offset.height)
                                            haptics(.medium)
                                        }
                                    }
                                    
                                    if !newValue {
                                        lastStoredOffset = offset
                                    }
                                }
                        }
                    }
                    .frame(size)
            }
        }
        .scaleEffect(scale)
        .offset(offset)
        .coordinateSpace(name: "CROPVIEW")
        .gesture(
            DragGesture()
                .updating($isInteracting, body: { _, out, _ in
                    out = true
                })
                .onChanged({ value in
                    let translation = value.translation
                    offset = CGSize(width: translation.width + lastStoredOffset.width, height: translation.height + lastStoredOffset.height)
                })
        )
        .gesture(
            MagnificationGesture()
                .updating($isInteracting, body: { _, out, _ in
                    out = true
                })
                .onChanged({ value in
                    let updatedScale = value + lastScale
                    scale = (updatedScale < 1 ? 1 : updatedScale)
                })
                .onEnded({ value in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if scale < 1 {
                            scale = 1
                            lastScale = 0
                        } else {
                            lastScale = scale - 1
                        }
                    }
                })
        )
        .frame(cropSize)
        .cornerRadius(crop == .circle ? cropSize.height / 2 : 0)
    }
}

//struct CropView_Previews: PreviewProvider {
//    static var previews: some View {
//        CropView(crop: .circle, image: UIImage(named: "Screen1")) { _, _ in
//
//        }
//    }
//}
