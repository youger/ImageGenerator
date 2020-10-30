//
//  LYImageGenerator.m
//
//  Created by youger on 2019/7/5.
//  Copyright © 2019 LYCode. All rights reserved.
//

#import "LYImageGenerator.h"
#import "LYShapeImageGenerator.h"

#if __has_include(<YYWebImage/YYImageCache.h>)
#import <YYWebImage/YYImageCache.h>
#else

#endif

@implementation LYImageGenerator

+ (UIImage *)featureDecorationImage
{
    NSString *imageKey = NSStringFromSelector(_cmd);
    UIImage *image = [[YYImageCache sharedCache] getImageForKey:imageKey];
    if (!image) {
        
        CGSize size = CGSizeMake(41, 17);
        CGFloat triangleHeight = 2;
        CGFloat triangleWidth = 5;
        CGFloat left = (size.width - triangleWidth)/2.f;
        CGFloat rectangleHeight = size.height - triangleHeight;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height - triangleHeight) cornerRadius:2];
        
        UIBezierPath *trianglePath = [UIBezierPath bezierPath];
        [trianglePath moveToPoint:CGPointMake(left, rectangleHeight)];
        [trianglePath addLineToPoint:CGPointMake(left + triangleWidth / 2.f, size.height)];
        [trianglePath addLineToPoint:CGPointMake(left + triangleWidth, rectangleHeight)];
        
        [path appendPath:trianglePath];
        
//        CGSize triangleSize = CGSizeMake(5, 2);
//        CGFloat rectangleHeight = size.height - triangleSize.height;
//        UIBezierPath *path = [self popoverPathWithSize:size triangleSize:CGSizeMake(5, 2) triangleInsets:UIEdgeInsetsZero cornerRadius:2];
//        [path closePath];
//        [path applyTransform:CGAffineTransformRotate(CGAffineTransformIdentity, M_PI)];
        
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:11], NSForegroundColorAttributeName : [UIColor whiteColor]};
        NSString *text = @"新功能";
        CGSize fontSize = [text sizeWithAttributes:attributes];
        CGRect containerRect = CGRectMake((size.width - fontSize.width)/2, (rectangleHeight - fontSize.height)/2, size.width, size.height);
        
        UIColor *startColor = [LYImageGenerator colorWithHexString:@"FC665A"] ,*endColor = [LYImageGenerator colorWithHexString:@"FC2129"];
        CGPoint startPoint = CGPointMake(0, 0), endPoint = CGPointMake(size.width, 0);
        NSArray *colors = [NSArray arrayWithObjects: (id)[startColor CGColor], (id)[endColor CGColor],nil];
        NSArray *points = [NSArray arrayWithObjects: [NSValue valueWithCGPoint:startPoint], [NSValue valueWithCGPoint:endPoint],nil];

        image = [self generateImageInSize:size drawBlock:^(CGContextRef ctx) {
            
            CGContextAddPath(ctx, path.CGPath);
            CGContextEOClip(ctx);
            drawGradientInContext(ctx, points, colors);
            
            if (text && [text isKindOfClass:NSString.class] && text.length) {
                [text drawInRect:containerRect withAttributes:attributes];
            }
        }];
        [[YYImageCache sharedCache] setImage:image imageData:nil forKey:imageKey withType:YYImageCacheTypeMemory];
    }
    return image;
}

+ (UIImage *)gradientImageForKey:(NSString *)key
{
    NSString *imageKey = [NSString stringWithFormat:@"gradient_%@", key];
    UIImage *image = [[YYImageCache sharedCache] getImageForKey:imageKey];
    if (!image) {
        
        CGFloat cornerRadius = 0;
        CGSize size = CGSizeZero;
        UIColor *startColor;
        UIColor *endColor;
        if (scanImageSizeAndColorWithKey(key, &size, &cornerRadius, &startColor, &endColor) == NO) {
            return nil;
        }
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:cornerRadius];
        CGPoint startPoint = CGPointMake(0, 0), endPoint = CGPointMake(size.width, 0);
        NSArray *colors = [NSArray arrayWithObjects: (id)[startColor CGColor], (id)[endColor CGColor],nil];
        NSArray *points = [NSArray arrayWithObjects: [NSValue valueWithCGPoint:startPoint], [NSValue valueWithCGPoint:endPoint],nil];

        image = [self generateImageInSize:size drawBlock:^(CGContextRef ctx) {
            
            CGContextAddPath(ctx, path.CGPath);
            CGContextEOClip(ctx);
            drawGradientInContext(ctx, points, colors);
        }];
        [[YYImageCache sharedCache] setImage:image imageData:nil forKey:imageKey withType:YYImageCacheTypeMemory];
    }
    return image;
}

+ (UIImage *)intersectLineImageForKey:(NSString *)key
{
    NSString *imageKey = [NSString stringWithFormat:@"interserect_%@", key];
    UIImage *image = [[YYImageCache sharedCache] getImageForKey:imageKey];
    if (!image) {
        
        CGFloat lineWidth = 1;
        CGSize size = CGSizeZero;
        UIColor *lineColor;
        if (scanImageSizeAndColorWithKey(key, &size, &lineWidth, &lineColor, NULL) == NO) {
            return nil;
        }
        CGFloat margin = lineWidth * 0.5f * sin(M_PI/4);
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(margin, margin)];
        [path addLineToPoint:CGPointMake(size.width - margin, size.height - margin)];
        [path moveToPoint:CGPointMake(size.width - margin , margin)];
        [path addLineToPoint:CGPointMake(margin, size.height - margin)];

        image = [self generateImageInSize:size drawBlock:^(CGContextRef ctx) {
            CGContextAddPath(ctx, path.CGPath);
            CGContextSetLineWidth(ctx, lineWidth);
            CGContextSetStrokeColorWithColor(ctx, lineColor.CGColor);
            CGContextStrokePath(ctx);
            CGContextEOClip(ctx);
        }];
        [[YYImageCache sharedCache] setImage:image imageData:nil forKey:imageKey withType:YYImageCacheTypeMemory];
    }
    return image;
}

+ (UIImage *)borderCircleImageForKey:(NSString *)key
{
    NSString *circleImageKey = [NSString stringWithFormat:@"border_%@", key];
    UIImage *circleImage = [[YYImageCache sharedCache] getImageForKey:circleImageKey];
    if (!circleImage) {
        
        CGFloat borderWidth = 1;
        CGSize size = CGSizeZero;
        UIColor *borderColor;
        if (scanImageSizeAndColorWithKey(key, &size, &borderWidth, NULL, &borderColor) == NO) {
            return nil;
        }
        circleImage = [LYShapeImageGenerator circleWithSize:size fillColor:nil borderColor:borderColor borderWidth:borderWidth];
        [[YYImageCache sharedCache] setImage:circleImage imageData:nil forKey:circleImageKey withType:YYImageCacheTypeMemory];
    }
    return circleImage;
}

+ (UIImage *)circleImageForKey:(NSString *)key
{
    NSString *circleImageKey = key;
    UIImage *circleImage = [[YYImageCache sharedCache] getImageForKey:circleImageKey];
    if (!circleImage) {
        
        CGFloat borderWidth = 0;
        CGSize size = CGSizeZero;
        UIColor *fillColor, *borderColor;
        if (scanImageSizeAndColorWithKey(key, &size, &borderWidth, &fillColor, &borderColor) == NO) {
            return nil;
        }
        circleImage = [LYShapeImageGenerator circleWithSize:size fillColor:fillColor borderColor:borderColor borderWidth:borderWidth];
        [[YYImageCache sharedCache] setImage:circleImage imageData:nil forKey:circleImageKey withType:YYImageCacheTypeMemory];
    }
    return circleImage;
}

+ (UIImage *)circleImageForKey:(NSString *)key shadow:(NSString *)shadowKey
{
    NSString *imageKey = [key stringByAppendingString:shadowKey];
    UIImage *circleShadowImage = [[YYImageCache sharedCache] getImageForKey:imageKey];
    if (!circleShadowImage) {
    
        UIImage *circleImage = [[YYImageCache sharedCache] getImageForKey:key];
        CGFloat borderWidth = 0;
        CGSize size = CGSizeZero;
        if (scanImageSizeAndColorWithKey(key, &size, &borderWidth, NULL, NULL) == NO) {
            return nil;
        }
        if (!circleImage) {
            circleImage = [self circleImageForKey:key];
        }
        CGSize shadowOffset = CGSizeZero;
        UIColor *shadowColor;
        CGFloat opacity = 0,  radius = 0;
        if (scanShadowOffsetAndColorWithKey(shadowKey, &shadowOffset, &shadowColor, &opacity, &radius) == NO) {
            return circleImage;
        }
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:size.height/2.f];
        CGPathRef circlePath = path.CGPath;
        if (borderWidth > 0) {
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale((size.width - 2*borderWidth)/size.width, (size.height - 2*borderWidth)/size.height);
            CGAffineTransform moveTransform = CGAffineTransformMakeTranslation(borderWidth, borderWidth);
            CGAffineTransform transform = CGAffineTransformConcat(scaleTransform, moveTransform);
            circlePath = CGPathCreateCopyByTransformingPath(path.CGPath, &transform);
        }

        circleShadowImage = [self generateImageInSize:size drawBlock:^(CGContextRef ctx) {
            
            [circleImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
            CGContextSaveGState(ctx);
            CGRect rect = CGRectMake(0, 0, size.width, size.height);
            if (borderWidth > 0) {
                rect = CGRectInset(rect, borderWidth, borderWidth);
            }
            // 创建 inner shadow 的镂空路径
            CGContextAddPath(ctx, circlePath);
            CGContextClip(ctx);

            // 创建阴影填充区域，并镂空中心
            CGMutablePathRef shadowPath = CGPathCreateMutable();
            CGRect shadowRect = CGRectInset(rect, -rect.size.width, -rect.size.width);
            CGPathAddRect(shadowPath, nil, shadowRect);
            CGPathAddPath(shadowPath, nil, circlePath);
            CGPathCloseSubpath(shadowPath);
            
            CGContextSetShadowWithColor(ctx, shadowOffset, radius, shadowColor.CGColor);
            CGContextAddPath(ctx, shadowPath);
            CGContextEOFillPath(ctx);
            
            CGContextRestoreGState(ctx);
        }];
    }
    return circleShadowImage;
}

+ (UIImage *)popoverImageWithSize:(CGSize)size triangleSize:(CGSize)triangleSize triangleInsets:(UIEdgeInsets)triangleInsets cornerRadius:(CGFloat)radius fillColor:(nullable UIColor *)fillColor
{
    UIBezierPath *path = [self popoverPathWithSize:size triangleSize:triangleSize triangleInsets:triangleInsets cornerRadius:radius];
    
    UIImage *popoverImage = [LYShapeImageGenerator imageWithPath:path.CGPath inSize:size fillColor:fillColor borderColor:nil borderWidth:0];
    return popoverImage;
}

+ (UIBezierPath *)popoverPathWithSize:(CGSize)size triangleSize:(CGSize)triangleSize triangleInsets:(UIEdgeInsets)triangleInsets cornerRadius:(CGFloat)radius
{
    CGFloat tHeight = triangleSize.height;
    CGFloat tWidth = triangleSize.width;
    CGFloat tLeft = 0;
    if (UIEdgeInsetsEqualToEdgeInsets(triangleInsets, UIEdgeInsetsZero)) {
        tLeft = (size.width - tWidth)/2.f;
    }else if (triangleInsets.left > 0){
        tLeft = triangleInsets.left;
    }else{
        tLeft = size.width - triangleInsets.right - tWidth;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, tHeight, size.width, size.height - tHeight) cornerRadius:radius];
    
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:CGPointMake(tLeft, tHeight)];
    [trianglePath addLineToPoint:CGPointMake(tLeft + tWidth / 2.f, 0)];
    [trianglePath addLineToPoint:CGPointMake(tLeft + tWidth, tHeight)];
    
    [path appendPath:trianglePath];
    
    return path;
}

static inline BOOL scanImageSizeAndColorWithKey(NSString *key, CGSize *sizePt, CGFloat *borderWidthPt, UIColor **fillColorPt, UIColor **borderColorPt)
{
    if (![key isKindOfClass:[NSString class]] || key.length == 0) {
        return NO;
    }
    NSArray *components = [key componentsSeparatedByString:@"_"];
    if (components.count == 0) {
        return NO;
    }
    __block NSInteger idx = 0;
    id (^safeGetNextElement)(void) = (id)^{
        id elem = nil;
        if (components.count > idx) {
            elem = [components objectAtIndex:idx];
            idx++;
        }
        return elem;
    };
    if (sizePt) {
        CGFloat width = 0, height = 0;
        width = [safeGetNextElement() floatValue];
        height = [safeGetNextElement() floatValue];
        if (width == 0 || height == 0) {
            return NO;
        }
        *sizePt = CGSizeMake(width, height);
    }
    
    UIColor *color = [LYImageGenerator colorWithHexString:(NSString *)safeGetNextElement()];
    if (fillColorPt) {
        *fillColorPt = color;
    }else if (borderColorPt){
        *borderColorPt = color;
    }
    
    if (borderWidthPt) {
        CGFloat borderWidth = [safeGetNextElement() floatValue];
        if (borderWidth > 0) {
            *borderWidthPt = borderWidth;
            NSString *hexColor = (NSString *)safeGetNextElement();
            if (borderColorPt && hexColor) {
                *borderColorPt = [LYImageGenerator colorWithHexString:hexColor];
            }
        }
    }
    return YES;
}

static inline BOOL scanShadowOffsetAndColorWithKey(NSString *key, CGSize *sizePt, UIColor **shadowColorPt, CGFloat *opacityPt, CGFloat *radiusPt)
{
    if (![key isKindOfClass:[NSString class]] || key.length == 0) {
        return NO;
    }
    NSArray *components = [key componentsSeparatedByString:@"_"];
    if (components.count == 0) {
        return NO;
    }
    __block NSInteger idx = 0;
    id (^safeGetNextElement)(void) = (id)^{
        id elem = nil;
        if (components.count > idx) {
            elem = [components objectAtIndex:idx];
            idx++;
        }
        return elem;
    };
    if (sizePt) {
        CGFloat width = [safeGetNextElement() floatValue];
        CGFloat height = [safeGetNextElement() floatValue];
        if (width == 0 && height == 0) {
            return NO;
        }
        *sizePt = CGSizeMake(width, height);
    }
    
    if (shadowColorPt) {
        *shadowColorPt = [LYImageGenerator colorWithHexString:(NSString *)safeGetNextElement()];
    }
    if (opacityPt) {
        *opacityPt = [safeGetNextElement() floatValue];
    }
    if (radiusPt) {
        *radiusPt = [safeGetNextElement() floatValue];
    }
    return YES;
}

+ (UIImage *)generateImageInSize:(CGSize)size drawBlock:(void(^)(CGContextRef ctx))drawBlock
{
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, scale);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (drawBlock) {
        drawBlock(ctx);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

static void drawPathFillColorInContext(CGContextRef ctx, CGPathRef path, CGColorRef color)
{
    CGContextAddPath(ctx, path);
    CGContextSetFillColorWithColor(ctx, color);
    CGContextFillPath(ctx);
}

static void drawGradientInContext(CGContextRef ctx, NSArray *points, NSArray *colors)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGPoint startPoint = [points.firstObject CGPointValue];
    CGPoint endPoint = [points.lastObject CGPointValue];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

+ (UIColor *)colorWithHexString:(NSString *)hexColor
{
    if(hexColor.length == 6 || hexColor.length == 8){
        __block int location = 0;
        unsigned int(^scanNextValue)(void) = ^(){
            unsigned int hexValue;
            NSRange range = NSMakeRange(location, 2);
            [[NSScanner scannerWithString:[hexColor substringWithRange:range]]
             scanHexInt:&hexValue];
            location += 2;
            return hexValue;
        };
        
        unsigned int red = scanNextValue();
        unsigned int green = scanNextValue();
        unsigned int blue = scanNextValue();
        
        float alpha = 1.f;
        if (hexColor.length == 8) {
            // 取透明度的值
            unsigned int alphaInt = scanNextValue();
            alpha = (float)alphaInt/255.f;
        }
        
        return [UIColor colorWithRed:(float)(red/255.0f)
                               green:(float)(green/255.0f)
                                blue:(float)(blue/255.0f)
                               alpha:alpha];
    }else{
        return [UIColor whiteColor];
    }
}

@end
