import UIKit
import SDWebImage

public struct LYImageGenerator {
    
    public init() {}
    
    public static func gradientImage(_ key: String) -> UIImage? {
        let imageKey = "gradient_\(key)"
        var image: UIImage? = getCacheImage(imageKey)
        guard image == nil else {
            return image
        }
        var cornerRadius: CGFloat = 0
        var size: CGSize = .zero
        var startColor: UIColor = .white
        var endColor: UIColor = .white
        var result: Bool = false
        (result, size) = scanGradient(key, cornerRadiusPt: &cornerRadius, startColorPt: &startColor, endColorPt: &endColor)
        guard result else {
            return image
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
    
    public static func intersectLine(_ key: String) -> UIImage? {
        let imageKey = "interserect_\(key)"
        var image: UIImage? = getCacheImage(imageKey)
        guard image == nil else {
            return image
        }
        
        var lineWidth: CGFloat = 0
        var size: CGSize = .zero
        var lineColor: UIColor = .white
        var result: Bool = false
        (result, size) = scanLine(key, lineWidthPt: &lineWidth, fillColorPt: &lineColor)
        guard result else {
            return image
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
    
    public static func rectangle(_ key: String, corners: UIRectCorner = .allCorners) -> UIImage? {
        let imageKey = key
        var image: UIImage? = getCacheImage(imageKey)
        guard image == nil else {
            return image
        }
        var borderWidth: CGFloat = 0, cornerRadius: CGFloat = 0
        var size: CGSize = .zero
        var fillColor: UIColor = .clear, borderColor: UIColor = .clear
        var result: Bool = false
        (result, size) = scanRectangle(key, borderWidthPt: &borderWidth, cornerRadiusPt: &cornerRadius, fillColorPt: &fillColor, borderColorPt: &borderColor)
        guard result else {
            return image
        }
        image = LYShapeImageGenerator.rectangle(size: size, fillColor: fillColor, borderColor: borderColor, borderWidth: borderWidth, corners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        return image
    }
    
    public static func circle(_ key: String) -> UIImage? {
        let imageKey = key
        var image: UIImage? = getCacheImage(imageKey)
        guard image == nil else {
            return image
        }
        var borderWidth: CGFloat = 0
        var size: CGSize = .zero
        var fillColor: UIColor = .clear, borderColor: UIColor = .clear
        var result: Bool = false
        (result, size) = scanCircle(key, borderWidthPt: &borderWidth, fillColorPt: &fillColor, borderColorPt: &borderColor)
        guard result else {
            return image
        }
        image = LYShapeImageGenerator.circle(size: size, fillColor: fillColor, borderColor: borderColor, borderWidth: borderWidth)
        cacheImage(image, key: imageKey)
        return image
    }
    
    public static func borderCircle(_ key: String) -> UIImage? {
        let imageKey = "border_\(key)"
        var image: UIImage? = getCacheImage(imageKey)
        guard image == nil else {
            return image
        }
        var borderWidth: CGFloat = 1
        var size: CGSize = .zero
        var borderColor: UIColor = .black
        var result: Bool = false
        (result, size) = scanCircle(key, borderWidthPt: &borderWidth, fillColorPt: nil, borderColorPt: &borderColor)
        guard result else {
            return image
        }
        image = LYShapeImageGenerator.circle(size: size, fillColor: nil, borderColor: borderColor, borderWidth: borderWidth)
        cacheImage(image, key: imageKey)
        return image
    }
    
    public static func circle(_ key: String, shadow: String) -> UIImage? {
        let imageKey = key + shadow
        var image: UIImage? = getCacheImage(imageKey)
        guard image == nil else {
            return image
        }
        var borderWidth: CGFloat = 0
        var size: CGSize = .zero
        var fillColor: UIColor = .clear, borderColor: UIColor = .clear
        var result: Bool = false
        (result, size) = scanCircle(key, borderWidthPt: &borderWidth, fillColorPt: &fillColor, borderColorPt: &borderColor)
        guard result else {
            return image
        }
        
        let circleImage: UIImage? = circle(key)
    
        var shadowOffset: CGSize = .zero
        var shadowColor: UIColor = .clear
        var opacity: CGFloat = 0,  radius: CGFloat = 0
        (result, shadowOffset) = scanShadow(shadow, shadowColorPt: &shadowColor, opacityPt: &opacity, radiusPt: &radius)
        guard result else {
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
            circleImage?.draw(in: rect)
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
    
    public static func popover(size: CGSize, triangleSize: CGSize, triangleInsets: UIEdgeInsets, cornerRadius: CGFloat, fillColor: UIColor?) -> UIImage? {
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
    
    public static func generateImage(size: CGSize, drawClosure: @escaping (CGContext)->Void) -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        if let ctx = UIGraphicsGetCurrentContext() {
            drawClosure(ctx)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    static func getCacheImage(_ key: String) -> UIImage? {
        return SDImageCache.shared.imageFromCache(forKey: key)
        //return YYImageCache.shared().getImageForKey(key)
    }
    
    static func cacheImage(_ image: UIImage?, key: String) {
        SDImageCache.shared.store(image, forKey: key, toDisk: false)
        //YYImageCache.shared().setImage(image, imageData: nil, forKey: key, with: .memory)
    }
}

public extension CGContext {
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
