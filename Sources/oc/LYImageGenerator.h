//
//  LYImageGenerator.h
//
//  Created by youger on 2019/7/5.
//  Copyright © 2019 LYCode. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYImageGenerator : NSObject

+ (UIImage *)featureDecorationImage;

/**
渐变色
@param key 命名规则（width_height_startColor_cornerRadius_endColor;eg. 60_30_FBFCFD, 80_32_FB7200_2_FFFFFF）
@return 相应规则的图片
*/
+ (UIImage *)gradientImageForKey:(NSString *)key;

/**
叉
@param key 命名规则（width_height_lineColor_lineWidth;eg. 60_30_FBFCFD, 80_32_FB7200_2）
@return 相应规则的图片
*/
+ (UIImage *)intersectLineImageForKey:(NSString *)key;

/**
 边框圆角图
 @param key 命名规则（width_height_borderColor_borderWidth;eg. 60_30_FBFCFD, 80_32_FFFFFF_2）
 @return 相应规则的图片
 */
+ (UIImage *)borderCircleImageForKey:(NSString *)key;

/**
 圆角图
 @param key 命名规则（width_height_backgroundColor_border_borderColor;eg. 60_30_FBFCFD, 80_32_FB7200_2_FFFFFF）
 @return 相应规则的图片
 */
+ (UIImage *)circleImageForKey:(NSString *)key;

/**
 圆角带阴影图
 @param key 命名规则（width_height_backgroundColor_border_borderColor; eg. 60_30_FBFCFD, 80_32_FB7200_2_FFFFFF）
 @param shadowKey 命名规则（width_height_shadowColor_opacity _radius; eg. 6_-3_FBFCFD, 8_3_FB7200_1_0）
 @return 相应规则的图片
 */
+ (UIImage *)circleImageForKey:(NSString *)key shadow:(NSString *)shadowKey;

+ (UIImage *)popoverImageWithSize:(CGSize)size triangleSize:(CGSize)triangleSize triangleInsets:(UIEdgeInsets)triangleInsets cornerRadius:(CGFloat)radius fillColor:(nullable UIColor *)fillColor;

@end

NS_ASSUME_NONNULL_END
