//
//  PushButton.swift
//  Flo
//
//  Created by Jason on 13/05/2018.
//  Copyright © 2018 Jason. All rights reserved.
//

import UIKit

// 支持在.storyboard中实时渲染
@IBDesignable class PushButton: UIButton {
    
    @IBInspectable var fillColor: UIColor = UIColor.green
    @IBInspectable var isAddButton: Bool = true
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        // Set the fill or stroke colors individually. These should be implemented by subclassers.
        // 设置填充色
        fillColor.setFill()
        path.fill()
        
        //set up the width and height variables
        //for the horizontal stroke
        let plusWidth = min(bounds.width,bounds.height) * Constants.plusButtonScale
        let halfPlusWidth = plusWidth / 2
        
        // create the path
        let plusPath = UIBezierPath()
        
        // set the path's line width to the height of the stroke
        plusPath.lineWidth = Constants.plusLineWidth
        
        // move the initial point of the path
        // to the start of the horizontal stroke
        // plusPath.move(to: CGPoint(x: halfWidth - halfPlusWidth, y: halfHeight))
        
        plusPath.move(to: CGPoint(
            x: halfWidth - halfPlusWidth + Constants.halfPointShift,
            y: halfHeight + Constants.halfPointShift))
        
        // add a point to the path the end of the stroke
        // plusPath.addLine(to: CGPoint(x: halfWidth + halfPlusWidth, y: halfHeight))
        
        /*
         If you have oddly sized straight lines, you’ll need to position them at plus or minus 0.5 points to prevent anti-aliasing. If you look at the diagrams above, you’ll see that a half point on the iPad 2 will move the line up half a pixel, on the iPhone 6, up one whole pixel, and on the iPhone 6 Plus, up one and a half pixels.
         如果你有奇怪的大小的直线，你需要将它们定位在正负0.5点，以防止锯齿。如果你看看上面的图表，你会发现在iPad 2上的半点会将线条向上移动半个像素，在iPhone 6上增加一个像素，在iPhone 6 Plus上增加1.5个像素。
        */
        // 偏移0.5个点,转化成偏移对应的像素(1x 0.5像素 2x 偏移1像素 3x 偏移1.5像素)
        plusPath.addLine(to: CGPoint(
            x: halfWidth + halfPlusWidth + Constants.halfPointShift,
            y: halfHeight + Constants.halfPointShift))
        
        // Vertical Line
        if isAddButton {            
            plusPath.move(to: CGPoint(
                x: halfWidth + Constants.halfPointShift,
                y: halfHeight - halfPlusWidth + Constants.halfPointShift))
            
            plusPath.addLine(to: CGPoint(
                x: halfWidth + Constants.halfPointShift,
                y: halfHeight + halfPlusWidth + Constants.halfPointShift))
        }
        
        // set the stroke color
        UIColor.white.setStroke()
        plusPath.stroke()
    }
    
    private struct Constants {
        static let plusLineWidth: CGFloat = 3.0
        static let plusButtonScale: CGFloat = 0.6
        static let halfPointShift: CGFloat = 0.5
    }
    
    private var halfWidth: CGFloat {
        return bounds.width / 2
    }
    
    private var halfHeight: CGFloat {
        return bounds.height / 2
    }
}
