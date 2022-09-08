//
//  LYShapeImageGenerator.m
//
//  Created by youger on 2019/9/6.
//  Copyright © 2019 LYCode. All rights reserved.
//

#import "LYShapeImageGenerator.h"

@implementation LYShapeImageGenerator

static CGSize scaleSizeWithSize(CGSize size)
{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat width = size.width * scale;
    CGFloat height = size.height * scale;
    return CGSizeMake(width, height);
}

+ (UIImage *)circleWithSize:(CGSize)size fillColor:(UIColor *)fillColor
{
    return [self circleWithSize:size fillColor:fillColor borderColor:nil borderWidth:0];
}

+ (UIImage *)circleWithSize:(CGSize)size borderColor:(UIColor *)borderColor
{
    return [self circleWithSize:size fillColor:nil borderColor:borderColor borderWidth:1];
}

+ (UIImage *)circleWithSize:(CGSize)size fillColor:(UIColor *)fillColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:size.height/2.f];
    UIImage *circlImage = [self imageWithPath:path.CGPath inSize:size fillColor:fillColor borderColor:borderColor borderWidth:borderWidth];
    
    return circlImage;
}

+ (UIImage *)triangleWithSize:(CGSize)size fillColor:(UIColor *)fillColor
{
    return [self triangleWithSize:size fillColor:fillColor borderColor:nil borderWidth:0];
}

+ (UIImage *)triangleWithSize:(CGSize)size borderColor:(UIColor *)borderColor
{
    return [self triangleWithSize:size fillColor:nil borderColor:borderColor borderWidth:2];
}

+ (UIImage *)triangleWithSize:(CGSize)size fillColor:(UIColor *)fillColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
{
    UIBezierPath *path = [self trianglePathWithSize:size borderWidth:borderWidth];
    UIImage *triangleImage = [self imageWithPath:path.CGPath inSize:size fillColor:fillColor borderColor:borderColor borderWidth:borderWidth];
    return triangleImage;
}

+ (UIImage *)imageWithPath:(CGPathRef)path inSize:(CGSize)size fillColor:(UIColor *)fillColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
{
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, scale);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGPathRef transformPath = path;
    //默认边框是居中，画内边框需要把path往右下方移动且缩小
    if (borderWidth > 0) {
        CGFloat delta = borderWidth /2.f;
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale((size.width - borderWidth)/size.width, (size.height - borderWidth)/size.height);
        CGAffineTransform moveTransform = CGAffineTransformMakeTranslation(delta, delta);
        CGAffineTransform transform = CGAffineTransformConcat(scaleTransform, moveTransform);
        transformPath = CGPathCreateCopyByTransformingPath(path, &transform);
    }
    if (fillColor) {
        CGContextAddPath(ctx, transformPath);
        CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
        CGContextFillPath(ctx);
    }
    if (borderColor) {
        CGContextAddPath(ctx, transformPath);
        CGContextSetLineWidth(ctx, borderWidth);
        CGContextSetStrokeColorWithColor(ctx, borderColor.CGColor);
        CGContextStrokePath(ctx);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIBezierPath *)trianglePathWithSize:(CGSize)size borderWidth:(CGFloat)borderWidth
{
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(borderWidth, height)];
    [path addLineToPoint:CGPointMake(width, height)];
    [path addLineToPoint:CGPointMake(width / 2.f, borderWidth)];
    [path addLineToPoint:CGPointMake(borderWidth, height)];
    
    return path;
}

@end
