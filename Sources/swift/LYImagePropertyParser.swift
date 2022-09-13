//
//  LYImagePropertyParser.swift
//  
//
//  Created by youger on 2022/9/9.
//

import UIKit

enum LYShape {
    case circle, rectangle, triangle, gradient
}

func scanRectangle(_ key: String?, borderWidthPt: UnsafeMutablePointer<CGFloat>?, cornerRadiusPt: UnsafeMutablePointer<CGFloat>? = nil, fillColorPt: UnsafeMutablePointer<UIColor>?, borderColorPt: UnsafeMutablePointer<UIColor>?) -> (Bool, CGSize) {
    return scan(key, shape: .rectangle, bw: borderWidthPt, cr: cornerRadiusPt, color1: fillColorPt, color2: borderColorPt)
}

func scanGradient(_ key: String?, cornerRadiusPt: UnsafeMutablePointer<CGFloat>?, startColorPt: UnsafeMutablePointer<UIColor>?, endColorPt: UnsafeMutablePointer<UIColor>?) -> (Bool, CGSize) {
    return scan(key, shape: .gradient, cr: cornerRadiusPt, color1: startColorPt, color2: endColorPt)
}

func scanLine(_ key: String?, lineWidthPt: UnsafeMutablePointer<CGFloat>?, cornerRadiusPt: UnsafeMutablePointer<CGFloat>? = nil, fillColorPt: UnsafeMutablePointer<UIColor>?, borderColorPt: UnsafeMutablePointer<UIColor>? = nil) -> (Bool, CGSize) {
    return scan(key, shape: .circle, bw: lineWidthPt, cr: cornerRadiusPt, color1: fillColorPt, color2: borderColorPt)
}

func scanCircle(_ key: String?, borderWidthPt: UnsafeMutablePointer<CGFloat>?, fillColorPt: UnsafeMutablePointer<UIColor>?, borderColorPt: UnsafeMutablePointer<UIColor>?) -> (Bool, CGSize) {
    return scan(key, shape: .circle, bw: borderWidthPt, color1: fillColorPt, color2: borderColorPt)
}

fileprivate func scan(_ key: String?, shape: LYShape, bw borderWidthPt: UnsafeMutablePointer<CGFloat>? = nil, cr cornerRadiusPt: UnsafeMutablePointer<CGFloat>? = nil, color1 firstColorPt: UnsafeMutablePointer<UIColor>?, color2 sencondColorPt: UnsafeMutablePointer<UIColor>?) -> (Bool, CGSize) {
    guard let key = key, key.isEmpty == false else {
        return (false, .zero)
    }
    
    let components = key.components(separatedBy: "_")
    guard components.count != 0 else {
        return (false, .zero)
    }
    
    var idx = 0
    let safeGetNextElement: () -> NSString = {
        var elem: String = ""
        if components.count > idx {
            elem = components[idx]
            idx += 1
        }
        return elem as NSString
    }
    var size: CGSize = .zero
    var width: Float = 0, height: Float = 0
    width = safeGetNextElement().floatValue
    height = safeGetNextElement().floatValue
    if width == 0 || height == 0 {
        return (false, .zero)
    }
    size = CGSize(width: CGFloat(width), height: CGFloat(height))
    
    switch shape {
    case .circle:
        let color = scanColor(with: safeGetNextElement() as String)
        if let firstColorPt = firstColorPt {
            firstColorPt.pointee = color
        }else if let sencondColorPt = sencondColorPt {
            sencondColorPt.pointee = color
        }
        
        if let borderWidthPt = borderWidthPt {
            let borderWidth = safeGetNextElement().floatValue
            if borderWidth > 0 {
                borderWidthPt.pointee = CGFloat(borderWidth)
                let hexString = safeGetNextElement() as String
                if let sencondColorPt = sencondColorPt, hexString.count > 0 {
                    sencondColorPt.pointee = scanColor(with: hexString)
                }
            }
        }
    case .rectangle:
        let color = scanColor(with: safeGetNextElement() as String)
        if let firstColorPt = firstColorPt {
            firstColorPt.pointee = color
        }else if let sencondColorPt = sencondColorPt {
            sencondColorPt.pointee = color
        }
        
        if let borderWidthPt = borderWidthPt {
            let borderWidth = safeGetNextElement().floatValue
            if borderWidth > 0 {
                borderWidthPt.pointee = CGFloat(borderWidth)
                let hexString = safeGetNextElement() as String
                if let sencondColorPt = sencondColorPt, hexString.count > 0 {
                    sencondColorPt.pointee = scanColor(with: hexString)
                }
            }
        }
        if let cornerRadiusPt = cornerRadiusPt {
            cornerRadiusPt.pointee = CGFloat(safeGetNextElement().floatValue)
        }
    case .triangle:
        break
    case .gradient:
        if let cornerRadiusPt = cornerRadiusPt {
            cornerRadiusPt.pointee = CGFloat(safeGetNextElement().floatValue)
        }
        if let firstColorPt = firstColorPt {
            firstColorPt.pointee =  scanColor(with: safeGetNextElement() as String)
        }
        if let sencondColorPt = sencondColorPt {
            sencondColorPt.pointee =  scanColor(with: safeGetNextElement() as String)
        }
    }
    return (true, size)
}

func scanShadow(_ key: String?, shadowColorPt: UnsafeMutablePointer<UIColor>?, opacityPt: UnsafeMutablePointer<CGFloat>?, radiusPt: UnsafeMutablePointer<CGFloat>?) -> (Bool, CGSize) {
    guard let key = key, key.isEmpty == false else {
        return (false, .zero)
    }
    
    let components = key.components(separatedBy: "_")
    guard components.count != 0 else {
        return (false, .zero)
    }
    
    var idx = 0
    let safeGetNextElement: () -> NSString = {
        var elem: String = ""
        if components.count > idx {
            elem = components[idx]
            idx += 1
        }
        return elem as NSString
    }
    
    var size: CGSize = .zero
    var width: Float = 0, height: Float = 0
    width = safeGetNextElement().floatValue
    height = safeGetNextElement().floatValue
    if width == 0, height == 0 {
        return (false, .zero)
    }
    size = CGSize(width: CGFloat(width), height: CGFloat(height))
    
    if let shadowColorPt = shadowColorPt {
        shadowColorPt.pointee = scanColor(with: safeGetNextElement() as String)
    }
    if let opacityPt = opacityPt {
        opacityPt.pointee = CGFloat(safeGetNextElement().floatValue)
    }
    if let radiusPt = radiusPt {
        radiusPt.pointee = CGFloat(safeGetNextElement().floatValue)
    }
    return (true, size)
}

public func scanColor(with hexString: String) -> UIColor {
    // abcdef00 || 2b2b2b
    if(hexString.count == 6 || hexString.count == 8){
        var rgba: UInt64 = 0
        guard Scanner(string: hexString).scanHexInt64(&rgba) else {
            return UIColor.white
        }
        
        var red: Int = 0, green = 0, blue = 0
        var alpha: CGFloat = 1.0
        // 带alpha
        if hexString.count == 8 {
            red = Int((rgba >> 24) & 0xFF)
            green = Int((rgba >> 16) & 0xFF)
            blue = Int((rgba >> 8) & 0xFF)
            alpha = CGFloat(rgba & 0xFF)/255.0
        }else {
            red = Int((rgba >> 16) & 0xFF)
            green = Int((rgba >> 8) & 0xFF)
            blue = Int(rgba & 0xFF)
        }
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }else{
        return UIColor.clear
    }
}
