import UIKit
import YYWebImage

public enum LYImageGenerator {
    
    static func gradientImage(_ key: String) -> UIImage? {
        let imageKey = "gradient_\(key)"
        var image: UIImage? = getCacheImage(imageKey)
        guard image == nil else {
            return image
        }
        var cornerRadius: CGFloat = 0
        var size: CGSize = .zero
        var startColor: UIColor = .white
        var endColor: UIColor = .white
        if !scan(key, sizePt: &size, borderWidthPt: &cornerRadius, firstColorPt: &startColor, sencondColorPt: &endColor) {
            return nil
        }
        let path = UIBezierPath.init(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: cornerRadius).cgPath
        let startPoint: CGPoint = .zero
        let endPoint = CGPoint(x: size.width, y: 0)
        let colors = [startColor.cgColor, endColor.cgColor]
        let points = [startPoint, endPoint]
        image = generateImage(size: size) { ctx in
            ctx.addPath(path)
            ctx.clip()
            ctx.drawGradient(points: points, colors: colors)
        }
        cacheImage(image, key: imageKey)
        return image
    }
    
    static func intersectLine(_ key: String) -> UIImage? {
        let imageKey = "interserect_\(key)"
        var image: UIImage? = getCacheImage(imageKey)
        guard image == nil else {
            return image
        }
        
        var lineWidth: CGFloat = 0
        var size: CGSize = .zero
        var lineColor: UIColor = .white
        if !scan(key, sizePt: &size, borderWidthPt: &lineWidth, firstColorPt: &lineColor, sencondColorPt: nil) {
            return nil
        }
        let margin: CGFloat = lineWidth * 0.5 * sin(Double.pi/4)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: margin, y: margin))
        path.addLine(to: CGPoint(x: size.width - margin, y: size.height - margin))
        path.move(to: CGPoint(x: size.width - margin, y: margin))
        path.addLine(to: CGPoint(x: margin, y: size.height - margin))

        image = generateImage(size: size) { ctx in
            ctx.addPath(path.cgPath)
            ctx.setLineWidth(lineWidth)
            ctx.setStrokeColor(lineColor.cgColor)
            ctx.strokePath()
            ctx.clip()
        }
        cacheImage(image, key: imageKey)
        return image
    }
    
    static func borderCircle(_ key: String) -> UIImage? {
        let imageKey = "border_\(key)"
        var image: UIImage? = getCacheImage(imageKey)
        guard image == nil else {
            return image
        }
        var borderWidth: CGFloat = 1
        var size: CGSize = .zero
        var borderColor: UIColor = .clear
        if !scan(key, sizePt: &size, borderWidthPt: &borderWidth, firstColorPt: &borderColor, sencondColorPt: nil) {
            return nil
        }
        image = LYShapeImageGenerator.circle(size: size, fillColor: nil, borderColor: borderColor, borderWidth: borderWidth)
        cacheImage(image, key: imageKey)
        return image
    }
    
    static func cirle(_ key: String) -> UIImage? {
        let imageKey = key
        var image: UIImage? = getCacheImage(imageKey)
        guard image == nil else {
            return image
        }
        var borderWidth: CGFloat = 0
        var size: CGSize = .zero
        var fillColor: UIColor = .clear, borderColor: UIColor = .clear
        if !scan(key, sizePt: &size, borderWidthPt: &borderWidth, firstColorPt: &fillColor, sencondColorPt: &borderColor) {
            return nil
        }
        image = LYShapeImageGenerator.circle(size: size, fillColor: fillColor, borderColor: borderColor, borderWidth: borderWidth)
        cacheImage(image, key: imageKey)
        return image
    }
    
    static func circle(_ key: String, with shadow: String) -> UIImage? {
        let imageKey = key + shadow
        var image: UIImage? = getCacheImage(imageKey)
        guard image == nil else {
            return image
        }
        var borderWidth: CGFloat = 0
        var size: CGSize = .zero
        var fillColor: UIColor = .clear, borderColor: UIColor = .clear
        if !scan(key, sizePt: &size, borderWidthPt: &borderWidth, firstColorPt: &fillColor, sencondColorPt: &borderColor) {
            return nil
        }
        
        let circleImage: UIImage? = cirle(key)
    
        var shadowOffset: CGSize = .zero
        var shadowColor: UIColor = .clear
        var opacity: CGFloat = 0,  radius: CGFloat = 0
        if scanShadow(shadow, sizePt: &shadowOffset, shadowColorPt: &shadowColor, opacityPt: &opacity, radiusPt: &radius) {
            return circleImage
        }
        
        let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: size.height/2.0)
        var circlePath = path.cgPath
        if borderWidth > 0 {
            let scaleTransform = CGAffineTransform(scaleX: (size.width - 2*borderWidth)/size.width, y: (size.height - 2*borderWidth)/size.height)
            let moveTransform = CGAffineTransform.init(translationX: borderWidth, y: borderWidth)
            var transform = scaleTransform.concatenating(moveTransform)
            if let transformPath = circlePath.copy(using: &transform) {
                circlePath = transformPath
            }
        }

        image = generateImage(size: size) { ctx in
            var rect = CGRect(origin: .zero, size: size)
            circleImage?.draw(in: CGRect(origin: .zero, size: size))
            ctx.saveGState()
            if borderWidth > 0 {
                rect = rect.insetBy(dx: borderWidth, dy: borderWidth)
            }
            // 创建 inner shadow 的镂空路径
            ctx.addPath(circlePath)
            ctx.clip()

            // 创建阴影填充区域，并镂空中心
            let shadowPath = CGMutablePath()
            let shadowRect = rect.insetBy(dx: -rect.width, dy: -rect.width)
            shadowPath.addRect(shadowRect)
            shadowPath.addPath(circlePath)
            shadowPath.closeSubpath()
            
            ctx.setShadow(offset: shadowOffset, blur: radius, color: shadowColor.cgColor)
            ctx.addPath(shadowPath)
            ctx.fillPath(using: .evenOdd)
            ctx.restoreGState()
        }
        cacheImage(image, key: imageKey)
        return image
    }
    
    static func popover(size: CGSize, triangleSize: CGSize, triangleInsets: UIEdgeInsets, cornerRadius: CGFloat, fillColor: UIColor?) -> UIImage? {
        let path = popoverPath(size: size, triangleSize: triangleSize, offsetInsets: triangleInsets, cornerRadius: cornerRadius)
        let image = LYShapeImageGenerator.shapeImage(path: path.cgPath, size: size, fillColor: fillColor, borderColor: nil, borderWidth: 0)
        return image
    }
    
    static func popoverPath(size: CGSize, triangleSize: CGSize, offsetInsets: UIEdgeInsets, cornerRadius: CGFloat) -> UIBezierPath {
        let tHeight = triangleSize.height
        let tWidth = triangleSize.width
        var triangleX: CGFloat = 0
        if offsetInsets == UIEdgeInsets.zero {
            triangleX = (size.width - tWidth)/2.0
        }else if offsetInsets.left > 0 {
            triangleX = offsetInsets.left
        }else {
            triangleX = size.width - offsetInsets.right - tWidth
        }
        
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: tHeight, width: size.width, height: size.height - tHeight), cornerRadius: cornerRadius)
        
        let trianglePath = LYShapeImageGenerator.triangle(size: triangleSize, borderWidth: 0)
        var moveTransform = CGAffineTransform(translationX: triangleX, y: 0)
        if let transformPath = trianglePath.cgPath.copy(using: &moveTransform) {
            trianglePath.cgPath = transformPath
        }
        path.append(trianglePath)
        
        return path
    }
    
    static func scan(_ key: String?, sizePt: UnsafeMutablePointer<CGSize>?, borderWidthPt: UnsafeMutablePointer<CGFloat>?, firstColorPt: UnsafeMutablePointer<UIColor>?, sencondColorPt: UnsafeMutablePointer<UIColor>?) -> Bool {
        guard let key = key, key.isEmpty == false else {
            return false
        }
        
        let components = key.components(separatedBy: "_")
        guard components.count != 0 else {
            return false
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
        if let sizePt = sizePt {
            var width: Float = 0, height: Float = 0
            width = safeGetNextElement().floatValue
            height = safeGetNextElement().floatValue
            if width == 0 || height == 0 {
                return false
            }
            sizePt.pointee = CGSize(width: CGFloat(width), height: CGFloat(height))
        }
        
        let color = LYImageGenerator.color(with: safeGetNextElement() as String)
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
                    sencondColorPt.pointee = LYImageGenerator.color(with: hexString)
                }
            }
        }
        return true
    }
    
    static func scanShadow(_ key: String?, sizePt: UnsafeMutablePointer<CGSize>?, shadowColorPt: UnsafeMutablePointer<UIColor>?, opacityPt: UnsafeMutablePointer<CGFloat>?, radiusPt: UnsafeMutablePointer<CGFloat>?) -> Bool {
        guard let key = key, key.isEmpty == false else {
            return false
        }
        
        let components = key.components(separatedBy: "_")
        guard components.count != 0 else {
            return false
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
        if let sizePt = sizePt {
            var width: Float = 0, height: Float = 0
            width = safeGetNextElement().floatValue
            height = safeGetNextElement().floatValue
            if width == 0 || height == 0 {
                return false
            }
            sizePt.pointee = CGSize(width: CGFloat(width), height: CGFloat(height))
        }
        if let shadowColorPt = shadowColorPt {
            shadowColorPt.pointee = LYImageGenerator.color(with: safeGetNextElement() as String)
        }
        if let opacityPt = opacityPt {
            opacityPt.pointee = CGFloat(safeGetNextElement().floatValue)
        }
        if let radiusPt = radiusPt {
            radiusPt.pointee = CGFloat(safeGetNextElement().floatValue)
        }
        return true
    }
    
    static func generateImage(size: CGSize, drawClosure: @escaping (CGContext)->Void) -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        if let ctx = UIGraphicsGetCurrentContext() {
            drawClosure(ctx)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    static func color(with hexString: String) -> UIColor {
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
            return UIColor.white
        }
    }
    
    static func getCacheImage(_ key: String) -> UIImage? {
        return YYImageCache.shared().getImageForKey(key)
    }
    
    static func cacheImage(_ image: UIImage?, key: String) {
        YYImageCache.shared().setImage(image, imageData: nil, forKey: key, with: .memory)
    }
}

extension CGContext {
    func drawGradient(points: [CGPoint], colors: [CGColor]) {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let start = points.first ?? .zero
        let end = points.last ?? .zero
        if let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: nil) {
            drawLinearGradient(gradient, start: start, end: end, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
        }
    }
    
    func drawFillColor(path: CGPath, color: CGColor) {
        addPath(path)
        setFillColor(color)
        fillPath()
    }
}
