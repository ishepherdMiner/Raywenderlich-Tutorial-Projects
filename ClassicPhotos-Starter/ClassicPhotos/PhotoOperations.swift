//
//  PhotoOperations.swift
//  ClassicPhotos
//
//  Created by Jason on 29/04/2018.
//  Copyright © 2018 raywenderlich. All rights reserved.
//

import UIKit

// This enum contains all the possible states a photo record can be in
enum PhotoRecordState {
    case New, Downloaded, Filtered, Failed
}

class PhotoRecord {
    let name:String
    let url:URL
    var state = PhotoRecordState.New
    var image = UIImage(named: "Placeholder")
    
    init(name:String, url:URL) {
        self.name = name
        self.url = url
    }
}

class PendingOperations {
    // 用(第几行:操作状态)这样的结构还管理
    lazy var downloadsInProgress = [NSIndexPath:Operation]()
    lazy var downloadQueue : OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Donwload queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    lazy var filtrationsInProgress = [NSIndexPath:Operation]()
    lazy var filtrationQueue:OperationQueue = {
       var queue = OperationQueue()
        queue.name = "Image Filtration queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}

class ImageDownloader : Operation {
    // 1
    let photoRecord: PhotoRecord
    
    // 2
    init(photoRecord:PhotoRecord) {
        self.photoRecord = photoRecord
    }
    
    // 3
    override func main() {
        // 4
        if self.isCancelled {
            return
        }
        // 5
        do {
            let imageData = try Data(contentsOf: self.photoRecord.url)
            // 6
            if self.isCancelled {
                return
            }
            
            // 7
            if imageData.count > 0 {
                // self.photoRecord.image = UIImage(data: <#T##Data#>)
                self.photoRecord.image = UIImage(data: imageData)
                self.photoRecord.state = .Downloaded
            }else {
                self.photoRecord.state = .Failed
                self.photoRecord.image = UIImage(named: "Failed")
            }
        }catch {
            print(error)
        }
    }
}

class ImageFiltration: Operation {
    let photoRecord: PhotoRecord
    init(photoRecord:PhotoRecord) {
        self.photoRecord = photoRecord
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        if self.photoRecord.state != .Downloaded {
            return
        }
        
        if let filteredImage = self.applySepiaFilter(image: self.photoRecord.image!) {
            self.photoRecord.image = filteredImage
            self.photoRecord.state = .Filtered
        }
    }
    
    func applySepiaFilter(image:UIImage) -> UIImage? {
        let inputImage = CIImage(data:UIImagePNGRepresentation(image)!)
        
        if self.isCancelled {
            return nil
        }
        let context = CIContext(options:nil)
        let filter = CIFilter(name:"CISepiaTone")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(0.8, forKey: "inputIntensity")
        let outputImage = filter?.outputImage
        
        if self.isCancelled {
            return nil
        }
        
        let outImage = context.createCGImage(outputImage!, from: outputImage!.extent)
        let returnImage = UIImage(cgImage: outImage!)
        return returnImage
    }
}
