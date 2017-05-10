//
//  UIColor+JYColor.h
//  减约
//
//  Created by nick on 16/4/14.
//  Copyright © 2016年 北京减脂时代科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (JYColor)
/**
 *  Create a color from a HEX string
 *
 *  @param hexString HEX string
 *
 *  @return Return the UIColor instance
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/**
 *  Create a color from HEX
 *
 *  @param hex HEX value
 *
 *  @return Return the UIColor instance
 */
+ (UIColor *)colorWithHex:(unsigned int)hex;

/**
 *  Create a color from HEX with alpha
 *
 *  @param hex   HEX value
 *  @param alpha Alpha value
 *
 *  @return Return the UIColor instance
 */
+ (UIColor *)colorWithHex:(unsigned int)hex
                    alpha:(float)alpha;

/**
 *  Create a random color
 *
 *  @return Return the UIColor instance
 */
+ (UIColor *)randomColor;

/**
 *  Create a color from a given color with alpha
 *
 *  @param color UIColor value
 *  @param alpha Alpha value
 *
 *  @return Return the UIColor instance
 */
+ (UIColor *)colorWithColor:(UIColor *)color
                      alpha:(float)alpha;
@end
