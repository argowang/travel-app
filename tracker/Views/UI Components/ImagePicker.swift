//
//  ImagePicker.swift
//  tracker
//
//  Created by Bingxin Zhu on 12/14/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode)
    var presentationMode

    @Binding var uiimage: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var presentationMode: PresentationMode
        @Binding var uiimage: UIImage?

        init(presentationMode: Binding<PresentationMode>, uiimage: Binding<UIImage?>) {
            _presentationMode = presentationMode
            _uiimage = uiimage
        }

        func imagePickerController(_: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            uiimage = uiImage
            presentationMode.dismiss()
        }

        func imagePickerControllerDidCancel(_: UIImagePickerController) {
            presentationMode.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, uiimage: $uiimage)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_: UIImagePickerController,
                                context _: UIViewControllerRepresentableContext<ImagePicker>) {}
}
