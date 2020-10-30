//
//  LYShapeImageGenerator.h
//
//  Created by youger on 2019/9/6.
//  Copyright © 2019 LYCode. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYShapeImageGenerator : NSObject

+ (UIImage *)circleWithSize:(CGSize)size fillColor:(UIColor *)fillColor;
+ (UIImage *)circleWithSize:(CGSize)size borderColor:(UIColor *)borderColor;
+ (UIImage *)circleWithSize:(CGSize)size fillColor:(nullable UIColor *)fillColor borderColor:(nullable UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

+ (UIImage *)triangleWithSize:(CGSize)size fillColor:(UIColor *)fillColor;
+ (UIImage *)triangleWithSize:(CGSize)size borderColor:(UIColor *)borderColor;
+ (UIImage *)triangleWithSize:(CGSize)size fillColor:(nullable UIColor *)fillColor borderColor:(nullable UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

+ (UIImage *)imageWithPath:(CGPathRef)path inSize:(CGSize)size fillColor:(nullable UIColor *)fillColor borderColor:(nullable UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

@end

NS_ASSUME_NONNULL_END
