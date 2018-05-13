//
//  CounterView.swift
//  Flo
//
//  Created by Jason on 13/05/2018.
//  Copyright © 2018 Jason. All rights reserved.
//

import UIKit

@IBDesignable
class CounterView: UIView {

    override func draw(_ rect: CGRect) {
        
    }
    
    private struct Constants {
        static let numberOfGlasses = 8
        static let lineWidth: CGFloat = 5.0
        static let arcWidth: CGFloat = 76
        static var halfOfLineWidth : CGFloat {
            return lineWidth / 2
        }
    }
    
    @IBInspectable var counter: Int = 5
    @IBInspectable var outlineColor = UIColor.blue
    @IBInspectable var counterColor = UIColor.orange
}

/*
 import UIKit
 
 @IBDesignable class CounterView: UIView {
 
 private struct Constants {
 static let numberOfGlasses = 8
 static let lineWidth: CGFloat = 5.0
 static let arcWidth: CGFloat = 76
 
 static var halfOfLineWidth: CGFloat {
 return lineWidth / 2
 }
 }
 
 @IBInspectable var counter: Int = 5
 @IBInspectable var outlineColor: UIColor = UIColor.blue
 @IBInspectable var counterColor: UIColor = UIColor.orange
 
 override func draw(_ rect: CGRect) {
 
 }
 }
 */
