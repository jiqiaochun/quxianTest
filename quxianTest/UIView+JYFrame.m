//
//  UIView+JYFrame.m
//  减约
//
//  Created by Sunshine on 16/4/18.
//  Copyright © 2016年 北京减脂时代科技有限公司. All rights reserved.
//

#import "UIView+JYFrame.h"

@implementation UIView (JYFrame)


+ (instancetype)jy_viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)setJy_height:(CGFloat)jy_height
{
    CGRect rect      = self.frame;
    rect.size.height = jy_height;
    self.frame       = rect;
}

- (CGFloat)jy_height
{
    return self.frame.size.height;
}

- (CGFloat)jy_width
{
    return self.frame.size.width;
}
- (void)setJy_width:(CGFloat)jy_width
{
    CGRect rect     = self.frame;
    rect.size.width = jy_width;
    self.frame      = rect;
}

- (CGFloat)jy_x
{
    return self.frame.origin.x;
    
}

- (void)setJy_x:(CGFloat)jy_x
{
    CGRect rect   = self.frame;
    rect.origin.x = jy_x;
    self.frame    = rect;
}

- (void)setJy_y:(CGFloat)jy_y
{
    CGRect rect   = self.frame;
    rect.origin.y = jy_y;
    self.frame    = rect;
}

- (CGFloat)jy_y
{
    
    return self.frame.origin.y;
}

- (void)setJy_centerX:(CGFloat)jy_centerX
{
    CGPoint center = self.center;
    center.x       = jy_centerX;
    self.center    = center;
}

- (CGFloat)jy_centerX
{
    return self.center.x;
}

- (void)setJy_centerY:(CGFloat)jy_centerY
{
    CGPoint center = self.center;
    center.y       = jy_centerY;
    self.center    = center;
}

- (CGFloat)jy_centerY
{
    return self.center.y;
}

- (CGFloat)jy_maxX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)jy_maxY {
    return CGRectGetMaxY(self.frame);
}

-(void)setJy_size:(CGSize)ym_size
{
    CGRect frame = self.frame;
    frame.size = ym_size;
    self.frame = frame;
}

-(CGSize)jy_size
{
    return self.frame.size;
}

- (void)setShadow {
    
    self.layer.shadowColor = [UIColor yellowColor].CGColor;//shadowColor阴影颜色
    self.layer.shadowOffset = CGSizeMake(-2,-2);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowOpacity = 1;//阴影透明度，默认0
    self.layer.shadowRadius = 0;//阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    float x = self.bounds.origin.x;
    float y = self.bounds.origin.y;
    float addWH = 0;
    
    CGPoint topLeft      = self.bounds.origin;
    CGPoint topMiddle = CGPointMake(x+(width/2),y-addWH);
    CGPoint topRight     = CGPointMake(x+width,y);
    
    CGPoint rightMiddle = CGPointMake(x+width+addWH,y+(height/2));
    
    CGPoint bottomRight  = CGPointMake(x+width,y+height);
    CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+addWH);
    CGPoint bottomLeft   = CGPointMake(x,y+height);
    
    
    CGPoint leftMiddle = CGPointMake(x-addWH,y+(height/2));
    
    [path moveToPoint:topLeft];
    //添加四个二元曲线
    [path addQuadCurveToPoint:topRight
                 controlPoint:topMiddle];
    [path addQuadCurveToPoint:bottomRight
                 controlPoint:rightMiddle];
    [path addQuadCurveToPoint:bottomLeft
                 controlPoint:bottomMiddle];
    [path addQuadCurveToPoint:topLeft
                 controlPoint:leftMiddle];
    //设置阴影路径
    self.layer.shadowPath = path.CGPath;
}

@end
