//
//  UIImage+Ext.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/11/22.
//

import CloudKit
import UIKit


extension UIImage{
    func convertToCKAsset() -> CKAsset?{
        // Get our apps base document directory URL
        guard let urlPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("documnet Directory url came back nil")
            return nil
        }
        // Append some unique identifier for our profile image
        let fileURL = urlPath.appendingPathComponent("selectedAvatarImage")
        
        // write the image data to the location the address points to
        guard let imageData = jpegData(compressionQuality: 0.25) else {
            return nil
        }
        // Create our CKAsset with that fileURL
        do {
            try imageData.write(to: fileURL)
            return CKAsset(fileURL: fileURL)
        } catch let e{
            print(e.localizedDescription)
            return nil
        }
    }
}
