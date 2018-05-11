/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import Foundation
import JavaScriptCore

@objc protocol MovieJSExports: JSExport {
    var title: String { get set }
    var price: String { get set }
    var imageUrl: String { get set }
    
    static func movieWith(title: String, price: String, imageUrl: String) -> Movie
}

// 原生代码导入到js的方法二: 遵守 JSExport 协议
class Movie: NSObject, MovieJSExports {
    
    dynamic var title: String
    dynamic var price: String
    dynamic var imageUrl: String
    
    init(title: String, price: String, imageUrl: String) {
        self.title = title
        self.price = price
        self.imageUrl = imageUrl
    }
    
    class func movieWith(title: String, price: String, imageUrl: String) -> Movie {
        return Movie(title: title, price: price, imageUrl: imageUrl)
    }
}

/*
class Movie: NSObject {
  
  var title: String
  var price: String
  var imageUrl: String
  
  init(title: String, price: String, imageUrl: String) {
    self.title = title
    self.price = price
    self.imageUrl = imageUrl
  }
    
    // 原生代码导入到js的方法一
    /*
     One way to run native code in the JavaScript runtime is to define blocks; they’ll be bridged automatically to JavaScript methods. There is, however, one tiny issue: this approach only works with Objective-C blocks, not Swift closures.
     
     // MovieService.swift
     // 1
     let builderBlock = unsafeBitCast(Movie.movieBuilder, to: AnyObject.self)
     
     // 2 Calling setObject(_:forKeyedSubscript:) on the context lets you load the block into the JavaScript runtime. You then use evaluateScript() to get a reference to your block in JavaScript.
     // 原生代码 => js
     context.setObject(builderBlock, forKeyedSubscript: "movieBuilder" as (NSCopying & NSObjectProtocol)?)
     let builder = context.evaluateScript("movieBuilder")
     builder?.call....
    */
    static let movieBuilder: @convention(block) ([[String : String]]) -> [Movie] = { object in
        return object.map { dict in
            
            guard
                let title = dict["title"],
                let price = dict["price"],
                let imageUrl = dict["imageUrl"] else {
                    print("unable to parse Movie objects.")
                    fatalError()
            }
            
            return Movie(title: title, price: price, imageUrl: imageUrl)
        }
    }
}
 */
