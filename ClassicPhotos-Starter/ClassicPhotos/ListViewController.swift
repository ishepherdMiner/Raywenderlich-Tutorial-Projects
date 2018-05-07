//
//  ListViewController.swift
//  ClassicPhotos
//
//  Created by Richard Turton on 03/07/2014.
//  Copyright (c) 2014 raywenderlich. All rights reserved.
//

import UIKit
import CoreImage

let dataSourceURL = URL(string:"http://www.raywenderlich.com/downloads/ClassicPhotosDictionary.plist")

class ListViewController: UITableViewController {
  
  // lazy var photos = NSDictionary(contentsOf: dataSourceURL!)
    
  var photos = [PhotoRecord]()
  let pendingOperations = PendingOperations()
    
  override func viewDidLoad() {    
    super.viewDidLoad()
    self.title = "Classic Photos"
    fetchPhotoDetails()
  }
    
    // 获得数据
    func fetchPhotoDetails() {
        let request = URLRequest(url:dataSourceURL!)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // 异步请求,成功后派发到主队列
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) { response,data,error in
            if data != nil {
                do {
                    let datasourceDictionary : NSDictionary = try PropertyListSerialization.propertyList(from: data!, options: PropertyListSerialization.MutabilityOptions.mutableContainers, format: nil) as! NSDictionary
                    for(key,value) in datasourceDictionary {
                        let name = key as? String
                        let url = URL(string: value as? String ?? "")
                        if name != nil && url != nil {
                            let photeRecord = PhotoRecord(name: name!, url: url!)
                            self.photos.append(photeRecord)
                        }
                    }
                }catch {
                    print(error)
                }
                
                self.tableView.reloadData()
            }
            
            if error != nil {
                let alert = UIAlertView(title:"Oops!",message:error?.localizedDescription, delegate:nil, cancelButtonTitle:"OK")
                alert.show()
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()    
  }
  
    
  override func tableView(_ tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
    // 首次预先加载空tableView
    if photos.count > 0 {
        return photos.count
    }
    return 0
  }
    
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) 
    
    // 1
    if cell.accessoryView == nil {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        cell.accessoryView = indicator
    }
    let indicator = cell.accessoryView as! UIActivityIndicatorView
    
    // 2 取出单个photoRecord对象
    let photoDetails = photos[indexPath.row]
    
    // 3
    cell.textLabel?.text = photoDetails.name
    cell.imageView?.image = photoDetails.image
    
    // 4
    switch (photoDetails.state){
    case .Filtered:
        indicator.stopAnimating()
    case .Failed:
        indicator.stopAnimating()
        cell.textLabel?.text = "Failed to load"
    case .New, .Downloaded:
        indicator.startAnimating()
        // 当tableView在滚动或减速时,不进行下载/滤镜操作
        if (!tableView.isDragging && !tableView.isDecelerating) {
            self.startOperationsForPhotoRecord(photoDetails: photoDetails, indexPath: indexPath as NSIndexPath)
        }
    }
    
    return cell
    /*
    let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath as IndexPath)
    let rowKey = photos[indexPath.row] as! String
    
    var image : UIImage?
    if let imageURL = URL(string:photos[rowKey] as! String),
        // Fix 1: 性能瓶颈,会同步等待
        // Important
        /*
    Don't use this synchronous method to request network-based URLs. For network-based URLs, this method can block the current thread for tens of seconds on a slow network, resulting in a poor user experience, and in iOS, may cause your app to be terminated. */
        
      let imageData = NSData.init(contentsOf:imageURL as URL){
      //1
      let unfilteredImage = UIImage(data:imageData as Data)
      //2
      image = self.applySepiaFilter(image: unfilteredImage!)
    }
    
    // Configure the cell...
    cell.textLabel?.text = rowKey
    if image != nil {
      cell.imageView?.image = image!
    }
    
    return cell
    */
    
  }
  
    func startOperationsForPhotoRecord(photoDetails: PhotoRecord, indexPath: NSIndexPath){
        switch (photoDetails.state) {
        case .New:
            startDownloadForRecord(photoDetails: photoDetails, indexPath: indexPath)
        case .Downloaded:
            startFiltrationForRecord(photoDetails: photoDetails, indexPath: indexPath)
        default:
            NSLog("do nothing")
        }
    }
    
    func startDownloadForRecord(photoDetails: PhotoRecord, indexPath: NSIndexPath){
        // 1 已经在下载了,直接返回
        if let _ = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        
        // 2 初始化
        let downloader = ImageDownloader(photoRecord: photoDetails)
        // 3 设置完成回调,回到主线程刷新指定行
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.tableView.reloadRows(at: [indexPath as IndexPath], with: .fade)
            }
        }
        // 4 持有downloader
        pendingOperations.downloadsInProgress[indexPath] = downloader
        // 5 添加到队列中 执行Operation子类的 main 方法
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    func startFiltrationForRecord(photoDetails: PhotoRecord, indexPath: NSIndexPath){
        // 同上
        if pendingOperations.filtrationsInProgress[indexPath] != nil{
            return
        }
        
        let filterer = ImageFiltration(photoRecord: photoDetails)
        filterer.completionBlock = {
            if filterer.isCancelled {
                return
            }
            DispatchQueue.main.async {
                self.pendingOperations.filtrationsInProgress.removeValue(forKey: indexPath)
                self.tableView.reloadRows(at: [indexPath as IndexPath], with: .fade)
            }
        }
        pendingOperations.filtrationsInProgress[indexPath] = filterer
        pendingOperations.filtrationQueue.addOperation(filterer)
    }
  
  func applySepiaFilter(image:UIImage) -> UIImage? {
    let inputImage = CIImage(data:UIImagePNGRepresentation(image)!)
    let context = CIContext(options:nil)
    let filter = CIFilter(name:"CISepiaTone")
    filter?.setValue(inputImage, forKey: kCIInputImageKey)
    filter?.setValue(0.8, forKey: "inputIntensity")
    if let outputImage = filter?.outputImage {
        let outImage = context.createCGImage(outputImage, from: outputImage.extent)
        return UIImage.init(cgImage:outImage!)
    }
    return nil
  }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 1
        suspendAllOperations()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 2
        if !decelerate {
            loadImagesForOnscreenCells()
            resumeAllOperations()
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 3
        loadImagesForOnscreenCells()
        resumeAllOperations()
    }
  
    func suspendAllOperations () {
        pendingOperations.downloadQueue.isSuspended = true
        pendingOperations.filtrationQueue.isSuspended = true
    }
    
    func resumeAllOperations () {
        pendingOperations.downloadQueue.isSuspended = false
        pendingOperations.filtrationQueue.isSuspended = false
    }
    
    func loadImagesForOnscreenCells () {
        // 1 当前显示的的行
        if let pathsArray = tableView.indexPathsForVisibleRows {
            // 2 已经在下载 || 滤镜的行
            var allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
            allPendingOperations = allPendingOperations.union(Set(pendingOperations.filtrationsInProgress.keys))
            // allPendingOperations.unionInPlace(Set(pendingOperations.filtrationsInProgress.key))
            
            //3 下载 || 滤镜的行 - 当前显示的行 => 要取消操作的行
            var toBeCancelled = allPendingOperations
            let visiblePaths = Set(pathsArray as [NSIndexPath])
            toBeCancelled.subtract(visiblePaths)
            
            // 4 Construct a set of index paths that need their operations started. Start with index paths all visible rows, and then remove the ones where operations are already pending.
            // 4 当前显示的行 - 下载 || 滤镜的行(已经开始执行) => 需要开始操作的行
            var toBeStarted = visiblePaths
            toBeStarted.subtract(allPendingOperations)
            
            // 5 取消操作,并移除引用
            for indexPath in toBeCancelled {
                if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
                    pendingDownload.cancel()
                }
                pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                if let pendingFiltration = pendingOperations.filtrationsInProgress[indexPath] {
                    pendingFiltration.cancel()
                }
                pendingOperations.filtrationsInProgress.removeValue(forKey: indexPath)
            }
            
            // 6 开始操作,并添加引用
            for indexPath in toBeStarted {
                let indexPath = indexPath as NSIndexPath
                let recordToProcess = self.photos[indexPath.row]
                startOperationsForPhotoRecord(photoDetails: recordToProcess, indexPath: indexPath)
            }
        }
    }
}
