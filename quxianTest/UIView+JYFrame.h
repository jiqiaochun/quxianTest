//
//  UIView+JYFrame.h
//  减约
//
//  Created by Sunshine on 16/4/18.
//  Copyright © 2016年 北京减脂时代科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JYFrame)

/**
 *  宽度值
 */
@property CGFloat jy_width;
/**
 *  高度值
 */
@property CGFloat jy_height;
/**
 *  X值
 */
@property CGFloat jy_x;
/**
 *  Y值
 */
@property CGFloat jy_y;
/**
 *  中心点的X值
 */
@property CGFloat jy_centerX;
/**
 *  中心点的Y值
 */
@property CGFloat jy_centerY;

/**
 *  最大的Y值
 */
@property (readonly) CGFloat jy_maxY;
/**
 *  最大的X值
 */

@property (readonly) CGFloat jy_maxX;

@property (nonatomic, assign) CGSize jy_size;

/**
 *  从nib中加载控件
 *
 *  @return 返回控件
 */
+ (instancetype)jy_viewFromXib;


- (void)setShadow;
@end
