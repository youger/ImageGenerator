//
//  LYShapeImageGenerator.swift
//  ImageGenerator
//
//  Created by youger on 2022/9/8.
//

import Foundation
import CoreGraphics
import UIKit

struct LYShapeImageGenerator {

    static func circle(size: CGSize, fillColor: UIColor?, borderColor: UIColor?, borderWidth: CGFloat = 1) -> UIImage? {
        let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: size.height/2)
        let circleImage = shapeImage(path: path.cgPath, size: size, fillColor: fillColor, borderColor: borderColor, borderWidth: borderWidth)
        return circleImage
    }
    
    static func triangle(size: CGSize, fillColor: UIColor?, borderColor: UIColor?, borderWidth: CGFloat = 2) -> UIImage? {
        let path = triangle(size: size, borderWidth: borderWidth)
        let triangleImage = shapeImage(path: path.cgPath, size: size, fillColor: fillColor, borderColor: borderColor, borderWidth: borderWidth)
        return triangleImage
    }
    
    static func triangle(size: CGSize, borderWidth: CGFloat) -> UIBezierPath {
        let width = size.width
        let height = size.height
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: CGFloat(borderWidth), y: height))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: width/2.0, y: borderWidth))
        path.addLine(to: CGPoint(x: borderWidth, y: height))
        return path
    }
    
    static func shapeImage(path: CGPath, size: CGSize, fillColor: UIColor?, borderColor: UIColor?, borderWidth: CGFloat) -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return nil
        }
        var transformPath = path
        //默认边框是居中，画内边框需要把path往右下方移动且缩小
        if (borderWidth > 0) {
            let delta = borderWidth/2.0
            let scaleTransform = CGAffineTransform(scaleX: (size.width - borderWidth)/size.width, y: (size.height - borderWidth)/size.height)
            let moveTransform = CGAffineTransform(translationX: delta, y: delta)
            var transform = scaleTransform.concatenating(moveTransform)
            if let tp = path.copy(using: &transform) {
                transformPath = tp
            }
        }
        if let color = fillColor {
            ctx.addPath(transformPath)
            ctx.setFillColor(color.cgColor)
            ctx.fillPath()
        }
        if let color = borderColor {
            ctx.addPath(transformPath)
            ctx.setLineWidth(borderWidth)
            ctx.setStrokeColor(color.cgColor)
            ctx.strokePath()
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
