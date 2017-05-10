//
//  JYRunningGraphView.m
//  减约
//
//  Created by 姬巧春 on 2017/3/20.
//  Copyright © 2017年 北京减脂时代科技有限公司. All rights reserved.
//

#import "JYRunningGraphView.h"

#import "JYRunningGraphModel.h"
#import "UIColor+JYColor.h"
#import "UIView+JYFrame.h"


/** 坐标轴信息区域高度 */
static const CGFloat kBottomPadding = 65.0;

/** 坐标轴信息区域宽度 */
static const CGFloat kleftPadding = 39.0;

/** 坐标系中横线的宽度 */
static const CGFloat kCoordinateLineWith = 0.5;

@interface JYRunningGraphView ()

// 总时长
@property (nonatomic,copy) NSString *totalTime;

/** X轴速度所有点单位长度 */
@property (nonatomic, assign) CGFloat pointxAxisSpacing;

/** X轴区间的单位长度 */
@property (nonatomic, assign) CGFloat xAxisSpacing;
/** Y轴的单位长度 */
@property (nonatomic, assign) CGFloat yAxisSpacing;
/** X轴的信息 */
@property (nonatomic, strong) NSMutableArray<NSString *> *xAxisInformationArray;
/** Y轴的信息 */
@property (nonatomic, strong) NSMutableArray<NSString *> *yAxisInformationArray;

/** 折线转折点数组 */
@property (nonatomic, strong) NSArray *pointArray;

/** 折线转折点数组 */
@property (nonatomic, strong) NSArray *speedRangeArray;

/** 颜色数组 */
@property (nonatomic, strong) NSMutableArray *gradientLayerColors;

@end

#define graphLineWidth 3
#define maxSpeedYmiduChange 12

@implementation JYRunningGraphView

// 初始化
- (instancetype)initWithFrame:(CGRect)frame andPointArray:(NSArray<JYRunningGraphModel *> *)pointArray andSpeedRangeArray:(NSArray<NSString *> *)speedRangeArray andTotalTime:(NSString *)totalTime{
    
    
    // 注释
    if (self = [super initWithFrame:frame]) {
        
        self.totalTime = totalTime;
        self.pointArray = pointArray;
        self.speedRangeArray = speedRangeArray;
        
        // 设置折线图的背景色
        self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        
        [self setupLineChartLayerAppearance];
        
    }
    return self;
}

// 速度点X轴间距
- (CGFloat)pointxAxisSpacing{
    if (_pointxAxisSpacing == 0) {
        _pointxAxisSpacing = (self.bounds.size.width - kleftPadding-15) / (float)((self.xAxisInformationArray.count-1)*5*3);
    }
    return _pointxAxisSpacing;
}

// x轴时间间距
- (CGFloat)xAxisSpacing {
    if (_xAxisSpacing == 0) {
        _xAxisSpacing = (self.bounds.size.width - kleftPadding - 15) / (float)(self.xAxisInformationArray.count - 1)-1;
    }
    return _xAxisSpacing;
}

// y轴间距
- (CGFloat)yAxisSpacing {
    if (_yAxisSpacing == 0) {
        //        _yAxisSpacing = (self.bounds.size.height - kPadding) / (float)self.yAxisInformationArray.count;
        
        _yAxisSpacing = (self.bounds.size.height - kBottomPadding - 30) / (20.0 - (20.0 - maxSpeedYmiduChange) * 0.5);
        
    }
    return _yAxisSpacing;
}

// X轴信息
- (NSMutableArray<NSString *> *)xAxisInformationArray {
    if (_xAxisInformationArray == nil) {
        // 创建可变数组
        _xAxisInformationArray = [[NSMutableArray alloc] init];
        
        /*
        if ([self.totalTime intValue] < 30) {
            self.totalTime = @"30";
        }
         */
        
        if ([self.totalTime intValue] % 5 == 0) {
            for (int i = 0; i < [self.totalTime intValue] / 5 + 1; i++) {
                NSString *timeStr = [NSString stringWithFormat:@"%d",i*5];
                [_xAxisInformationArray addObject:timeStr];
            }
        }else{
            for (int i = 0; i < [self.totalTime intValue] / 5 + 2; i++) {
                NSString *timeStr = [NSString stringWithFormat:@"%d",i*5];
                [_xAxisInformationArray addObject:timeStr];
            }
        }
        
    }
    return _xAxisInformationArray;
}

// y轴信息
- (NSMutableArray<NSString *> *)yAxisInformationArray {
    if (_yAxisInformationArray == nil) {
        _yAxisInformationArray = [NSMutableArray arrayWithArray:self.speedRangeArray];
        [_yAxisInformationArray insertObject:@"" atIndex:0];
        
    }
    return _yAxisInformationArray;
}

- (void)drawRect:(CGRect)rect {
    // 获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 计算文字尺寸
    UIFont *speedFont = [UIFont systemFontOfSize:12];
    NSMutableDictionary *attributespeed = [NSMutableDictionary dictionary];
    attributespeed[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#666666"];
    attributespeed[NSFontAttributeName] = speedFont;
    NSString *Ytitle = @"速度 (km/h)";
//    CGSize speedSize = [Ytitle sizeWithAttributes:attributespeed];
    // 计算绘制起点
    float spped_drawStartPointX = 15;
    float spped_drawStartPointY = 30;
    CGPoint spped_drawStartPoint = CGPointMake(spped_drawStartPointX, spped_drawStartPointY);
    // 绘制文字信息
    [Ytitle drawAtPoint:spped_drawStartPoint withAttributes:attributespeed];
    
    // x轴信息
    [self.xAxisInformationArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 计算文字尺寸
        UIFont *informationFont = [UIFont systemFontOfSize:10];
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        attributes[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#999999"];
        attributes[NSFontAttributeName] = informationFont;
        // 计算绘制起点
        float drawStartPointX = kleftPadding + idx * self.xAxisSpacing;
        float drawStartPointY = self.bounds.size.height - kBottomPadding + 5;
        CGPoint drawStartPoint = CGPointMake(drawStartPointX, drawStartPointY);
        // 绘制文字信息
        [obj drawAtPoint:drawStartPoint withAttributes:attributes];
    }];
    // y轴
    [self.yAxisInformationArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 计算文字尺寸
        UIFont *informationFont = [UIFont systemFontOfSize:10];
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        attributes[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#999999"];
        attributes[NSFontAttributeName] = informationFont;
        CGSize informationSize = [obj sizeWithAttributes:attributes];
        // 计算绘制起点
        float drawStartPointX = kleftPadding - informationSize.width - 5;
        float drawStartPointY = self.bounds.size.height - kBottomPadding - self.yAxisSpacing * [obj floatValue] - informationSize.height * 0.5;
        CGPoint drawStartPoint = CGPointMake(drawStartPointX, drawStartPointY);
        // 绘制文字信息
        [obj drawAtPoint:drawStartPoint withAttributes:attributes];
        // 横向标线
        CGContextSetRGBStrokeColor(context, 226 / 255.0, 226 / 255.0, 226 / 255.0, 1.0);
        CGContextSetLineWidth(context, kCoordinateLineWith);
        CGContextMoveToPoint(context, kleftPadding, self.bounds.size.height - kBottomPadding - self.yAxisSpacing * [obj floatValue]);
        CGContextAddLineToPoint(context, self.bounds.size.width-15, self.bounds.size.height - kBottomPadding - self.yAxisSpacing * [obj floatValue]);
        CGContextStrokePath(context);
    }];
    
    
    // 计算文字尺寸
    UIFont *informationFont = [UIFont systemFontOfSize:12];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#666666"];
    attributes[NSFontAttributeName] = informationFont;
    NSString *Xtitle = @"时间 (分钟)";
    CGSize informationSize = [Xtitle sizeWithAttributes:attributes];
    // 计算绘制起点
    float drawStartPointX = self.bounds.size.width - informationSize.width - 10;
    float drawStartPointY = self.bounds.size.height - informationSize.height - 15;
    CGPoint drawStartPoint = CGPointMake(drawStartPointX, drawStartPointY);
    // 绘制文字信息
    [Xtitle drawAtPoint:drawStartPoint withAttributes:attributes];
}

- (void)viewforGradientWithBezierPath:(UIBezierPath *)path w_x:(CGFloat)w_x x_two:(CGFloat)x_two right_y:(CGFloat)right_y right_height:(CGFloat)right_height andGradientStartY:(CGFloat)starty andGradientEndY:(CGFloat)endy{
    
    /** 将折线添加到折线图层上，并设置相关的属性 */
    CAShapeLayer *lineChartLayer2 = [CAShapeLayer layer];
    lineChartLayer2.path = path.CGPath;
    lineChartLayer2.strokeColor = [UIColor whiteColor].CGColor;
    lineChartLayer2.fillColor = [[UIColor clearColor] CGColor];
    // 默认设置路径宽度为0，使其在起始状态下不显示
    lineChartLayer2.lineWidth = graphLineWidth;
    lineChartLayer2.lineCap = kCALineCapRound;
    lineChartLayer2.lineJoin = kCALineJoinRound;
    
    
    // 渐变背景视图（不包含坐标轴）
    CGFloat h_y = self.bounds.size.height - kBottomPadding;
    UIView *gradientBackgroundView2 = [[UIView alloc] initWithFrame:CGRectMake(kleftPadding,0,w_x,h_y)];
    [self addSubview:gradientBackgroundView2];
    
    CGFloat right_width = w_x - x_two;
    CGFloat left_width = x_two;
    if (right_width < graphLineWidth) {
        left_width = x_two - (3 - right_width);
        
        right_width = graphLineWidth+(graphLineWidth)+0.5;
    }else{
        right_width = w_x - x_two+(graphLineWidth)+0.5;
    }
    
    NSLog(@"right_width = %lf",right_width);
    
    if (right_height < graphLineWidth * 5) {
        right_y = right_y - (graphLineWidth * 5 - right_height) * 0.5;
        right_height = graphLineWidth * 5;
    }
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0,0,left_width,h_y)];
    leftView.backgroundColor = [UIColor clearColor];
    [gradientBackgroundView2 addSubview:leftView];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(leftView.jy_maxX -(graphLineWidth)*0.5,right_y,right_width+(graphLineWidth)*0.5,right_height)];
    [gradientBackgroundView2 addSubview:rightView];
    
    // 创建并设置渐变背景图层
    //初始化CAGradientlayer对象，使它的大小为渐变背景视图的大小
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.frame = rightView.bounds;
    //设置渐变区域的起始和终止位置（范围为0-1），即渐变路径
    gradientLayer2.startPoint = CGPointMake(0, starty);
    gradientLayer2.endPoint = CGPointMake(0.0, endy);
    //设置颜色的渐变过程
    
    gradientLayer2.colors = self.gradientLayerColors;
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [rightView.layer addSublayer:gradientLayer2];
    
    // 设置折线图层为渐变图层的mask
    gradientBackgroundView2.layer.mask = lineChartLayer2;
    
}


- (void)setupLineChartLayerAppearance{
    
    CGFloat prePointX = 0;
    CGFloat prePointY = self.bounds.size.height - kBottomPadding;
    CGFloat pointX = 0;
    CGFloat pointY = 0;
    CGFloat w_x = 0;
    CGFloat h_y = prePointY;
    CGFloat x_two = 0;
    
    JYRunningGraphModel *preModel;
    
    JYRunningGraphModel *firstmodel;
    JYRunningGraphModel *middlemodel;
    //JYRunningGraphModel *lastmodel;
    
    for (NSInteger i = 0; i < self.pointArray.count; i++) {
        
        UIBezierPath *pathTwo = [UIBezierPath bezierPath];
        //设置线条属性
        pathTwo.lineCapStyle = kCGLineJoinRound;  //线段端点格式
        pathTwo.lineJoinStyle = kCGLineJoinRound; //线段接头格式
        pathTwo.lineWidth = graphLineWidth;
        [pathTwo moveToPoint:CGPointMake(prePointX,prePointY)];
        
        JYRunningGraphModel *model = self.pointArray[i];
        
        if ([model.timeStr integerValue] % 60 > 0 && [model.timeStr integerValue] % 60 <= 20) {
            firstmodel = self.pointArray[i];
            continue;
        }else if ([model.timeStr integerValue] % 60 > 20 && [model.timeStr integerValue] % 60 <= 40){
            middlemodel = self.pointArray[i];
            continue;
        }else{
            
            CGFloat needSpeed = ([firstmodel.speedStr floatValue] + [middlemodel.speedStr floatValue] + [model.speedStr floatValue]) / 3.0;
            model.speedStr = [NSString stringWithFormat:@"%lf",needSpeed];
            model.isIn = ([model.speedStr floatValue] >= [model.minSpeed floatValue] && [model.speedStr floatValue] <= [model.maxSpeed floatValue]);
        }
        

        // 转化最大和最小速度
        if ([model.speedStr floatValue] > 20 ) {
            model.speedStr = @"20";
        }else if ([model.speedStr floatValue] < 0){
            model.speedStr = @"0";
        }
        
        // 大于区间最大速度之后转化 maxSpeedF--20之间的密度变化
        CGFloat maxSpeedF = maxSpeedYmiduChange;
        if ([model.speedStr floatValue]> maxSpeedF) {
            CGFloat needSpeed = ([model.speedStr floatValue] - maxSpeedF) * 0.5 + maxSpeedF;
            model.speedStr = [NSString stringWithFormat:@"%lf",needSpeed];
        }
        
        pointX = self.pointxAxisSpacing * 0.5 + ceil([model.timeStr floatValue] / 20.0) * self.pointxAxisSpacing;
        pointY = self.bounds.size.height - kBottomPadding - [model.speedStr floatValue] * self.yAxisSpacing;
        w_x = pointX;
        
        if (preModel.isIn && model.isIn) {
            //两点都在正确区间内
            self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithHexString:@"#2BE4BB"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#2BE4BB"].CGColor]];
            
        } else if (preModel.isIn) {
            
            if (prePointY == pointY){
                NSLog(@"prePointY == pointY = %lf",pointY);
            }else{
                
                UIBezierPath *path = [UIBezierPath bezierPath];
                //设置线条属性
                path.lineCapStyle = kCGLineJoinRound;  //线段端点格式
                path.lineJoinStyle = kCGLineJoinRound; //线段接头格式
                path.lineWidth = graphLineWidth;
                [path moveToPoint:CGPointMake(prePointX,prePointY)];
                
                //第一个点在正确区间
                float m_pointY ;
                float m_pointX ;
                
                CGFloat right_y = 0;
                CGFloat right_height = h_y;
                
                
                if ([model.speedStr floatValue] > [model.maxSpeed floatValue]){
                    
                    if ([preModel.speedStr floatValue] < [model.speedStr floatValue] && [model.speedStr floatValue] > [preModel.maxSpeed floatValue]) {
                        
                        //第二个点大于最大速度 斜向上
                        m_pointY = self.bounds.size.height - kBottomPadding - [preModel.maxSpeed floatValue] * self.yAxisSpacing;
                        m_pointX = pointX - (pointX - prePointX) * ((m_pointY - pointY) / (prePointY - pointY));
                        
                        right_y = m_pointY;
                        right_height = prePointY - m_pointY;
                        
                        
                    }else{
                        
                        // 无交点
                        
                        CGFloat right_y = 0;
                        CGFloat right_height = h_y;
                        if (pointY >= prePointY) { // 斜向下
                            right_y = prePointY;
                            right_height = pointY - prePointY;
                        }else{
                            right_y = pointY;
                            right_height = prePointY - pointY;
                        }
                        
                        preModel = model;
                        prePointX = pointX;
                        prePointY = pointY;
                        
                        [path addLineToPoint:CGPointMake(pointX, pointY)];
                        
                        self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor]];
                        
                        // 将折线添加到折线图层上，并设置相关的属性
                         
                        [self viewforGradientWithBezierPath:path w_x:w_x x_two:x_two right_y:right_y right_height:right_height andGradientStartY:0.0 andGradientEndY:1.0];
                        
                        x_two = pointX;
                        continue;
                        
                    }
                    
                }else {
                    //第二个点小于最小速度
                    if ([model.speedStr floatValue] >= [preModel.minSpeed floatValue]) {
                        //  无交点
                        CGFloat right_y = 0;
                        CGFloat right_height = h_y;
                        if (pointY >= prePointY) { // 斜向下
                            right_y = prePointY;
                            right_height = pointY - prePointY;
                        }else{
                            right_y = pointY;
                            right_height = prePointY - pointY;
                        }
                        
                        preModel = model;
                        prePointX = pointX;
                        prePointY = pointY;
                        
                        [path addLineToPoint:CGPointMake(pointX, pointY)];
                        
                        self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor]];
                        
                        // 将折线添加到折线图层上，并设置相关的属性
                        [self viewforGradientWithBezierPath:path w_x:w_x x_two:x_two right_y:right_y right_height:right_height andGradientStartY:0.0 andGradientEndY:1.0];
                        
                        x_two = pointX;
                        continue;
                        
                    }else{
                        
                        //斜向下
                        m_pointY = self.bounds.size.height - kBottomPadding - [preModel.minSpeed floatValue] * self.yAxisSpacing;
                        m_pointX = prePointX + (pointX - prePointX) * ((m_pointY - prePointY) / (pointY - prePointY));
                        
                        right_y = prePointY;
                        right_height = m_pointY - prePointY;
                        
                    }

                }
                
                [path addLineToPoint:CGPointMake(m_pointX, m_pointY)];
                
                preModel = model;
                prePointX = m_pointX;
                prePointY = m_pointY;
                
                self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithHexString:@"#2BE4BB"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#2BE4BB"].CGColor]];
                
                [self viewforGradientWithBezierPath:path w_x:w_x x_two:x_two right_y:right_y right_height:right_height andGradientStartY:0.0 andGradientEndY:1.0];
                
                x_two = m_pointX;
                
                
                // 再次连线到目标点
                UIBezierPath *path2 = [UIBezierPath bezierPath];
                //设置线条属性
                path2.lineCapStyle = kCGLineJoinRound;  //线段端点格式
                path2.lineJoinStyle = kCGLineJoinRound; //线段接头格式
                path2.lineWidth = graphLineWidth;
                [path2 moveToPoint:CGPointMake(prePointX,prePointY)];
                
                [path2 addLineToPoint:CGPointMake(pointX, pointY)];
                
                CGFloat startY = 0.0;
                CGFloat endY = 1.0;
                if (m_pointY > pointY) {
                    //第二个点大于最大速度 斜向上
                    
                    right_y = pointY;
                    right_height = m_pointY - pointY;
                    
                    self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#2BE4BB"].CGColor]];
                    startY = 0.8;
                    endY = 1.0;
                    
                }else{
                    //第二个点小于最小速度 斜向下
                    
                    right_y = m_pointY;
                    right_height = pointY - m_pointY;
                    
                    self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithHexString:@"#2BE4BB"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor]];
                    startY = 0.0;
                    endY = 0.2;
                }
                
                preModel = model;
                prePointX = pointX;
                prePointY = pointY;
                
                [self viewforGradientWithBezierPath:path2 w_x:w_x x_two:x_two right_y:right_y right_height:right_height andGradientStartY:startY andGradientEndY:endY];
                
                x_two = pointX;
                
                continue;
                
            }
            
        } else if (model.isIn) {
            
            //第二个点在正确的区间内
            // 斜率为0
            if (prePointY == pointY) {
                NSLog(@"prePointY == pointY = %lf",pointY);
            }else{
                
                UIBezierPath *path = [UIBezierPath bezierPath];
                //设置线条属性
                path.lineCapStyle = kCGLineJoinRound;  //线段端点格式
                path.lineJoinStyle = kCGLineJoinRound; //线段接头格式
                path.lineWidth = graphLineWidth;
                [path moveToPoint:CGPointMake(prePointX,prePointY)];
                
                float m_pointX;
                float m_pointY;
                
                CGFloat right_y = 0;
                CGFloat right_height = h_y;
                
                CGFloat startY = 0.0;
                CGFloat endY = 1.0;
                if ([preModel.speedStr floatValue]>[preModel.maxSpeed floatValue]){
                    
                    if ([preModel.speedStr floatValue] > [model.maxSpeed floatValue]) {
                        
                        //第一个点超速 斜向下
                        m_pointY = self.bounds.size.height-kBottomPadding - [model.maxSpeed floatValue] * self.yAxisSpacing;
                        m_pointX = prePointX + (pointX - prePointX) * ((m_pointY - prePointY) / (pointY - prePointY));
                        
                        right_y = prePointY;
                        right_height = m_pointY - prePointY;
                        
                        self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#2BE4BB"].CGColor]];
                        startY = 0.8;
                        endY = 1.0;
                        
                    }else{
                        // 无交点
                        CGFloat right_y = 0;
                        CGFloat right_height = h_y;
                        if (pointY >= prePointY) { // 斜向下
                            right_y = prePointY;
                            right_height = pointY - prePointY;
                        }else{
                            right_y = pointY;
                            right_height = prePointY - pointY;
                        }
                        
                        preModel = model;
                        prePointX = pointX;
                        prePointY = pointY;
                        
                        [path addLineToPoint:CGPointMake(pointX, pointY)];
                        
                        self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor]];
                        
                        // 将折线添加到折线图层上，并设置相关的属性
                        [self viewforGradientWithBezierPath:path w_x:w_x x_two:x_two right_y:right_y right_height:right_height andGradientStartY:0.0 andGradientEndY:1.0];
                        
                        x_two = pointX;
                        continue;
                    }
                    
                    
                    
                }else {
                    //第一个点未达到速度
                   
                    if ([preModel.minSpeed floatValue] > [model.minSpeed floatValue]) {
                       // 无交点
                        CGFloat right_y = 0;
                        CGFloat right_height = h_y;
                        if (pointY >= prePointY) { // 斜向下
                            right_y = prePointY;
                            right_height = pointY - prePointY;
                        }else{
                            right_y = pointY;
                            right_height = prePointY - pointY;
                        }
                        
                        preModel = model;
                        prePointX = pointX;
                        prePointY = pointY;
                        
                        [path addLineToPoint:CGPointMake(pointX, pointY)];
                        
                        self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor]];
                        
                        // 将折线添加到折线图层上，并设置相关的属性
                        [self viewforGradientWithBezierPath:path w_x:w_x x_two:x_two right_y:right_y right_height:right_height andGradientStartY:0.0 andGradientEndY:1.0];
                        
                        x_two = pointX;
                        continue;
                        
                    }else{
                        
                        //斜向上
                        m_pointY = self.bounds.size.height - kBottomPadding - [model.minSpeed floatValue] * self.yAxisSpacing;
                        m_pointX = pointX - (pointX - prePointX) * ((m_pointY - pointY) / (prePointY - pointY));
                        
                        
                        right_y = m_pointY;
                        right_height = prePointY - m_pointY;
                        
                        self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithHexString:@"#2BE4BB"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor]];
                        startY = 0.0;
                        endY = 0.2;
                    }
                }
                
                [path addLineToPoint:CGPointMake(m_pointX, m_pointY)];
                
                preModel = model;
                prePointX = m_pointX;
                prePointY = m_pointY;
                
                
                [self viewforGradientWithBezierPath:path w_x:w_x x_two:x_two right_y:right_y right_height:right_height andGradientStartY:startY andGradientEndY:endY];
                
                x_two = m_pointX;
                
                // 再次连线到目标点
                UIBezierPath *path2 = [UIBezierPath bezierPath];
                //设置线条属性
                path2.lineCapStyle = kCGLineJoinRound;  //线段端点格式
                path2.lineJoinStyle = kCGLineJoinRound; //线段接头格式
                path2.lineWidth = graphLineWidth;
                [path2 moveToPoint:CGPointMake(prePointX,prePointY)];
                
                [path2 addLineToPoint:CGPointMake(pointX, pointY)];
                
                if (pointY > m_pointY) {
                    //第一个点超速 斜向下
                    right_y = m_pointY;
                    right_height = pointY - m_pointY;
                }else{
                    //第一个点未达到速度 斜向上
                    right_y = pointY;
                    right_height = m_pointY - pointY;
                }
                
                preModel = model;
                prePointX = pointX;
                prePointY = pointY;
                
                self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithHexString:@"#2BE4BB"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#2BE4BB"].CGColor]];
                
                [self viewforGradientWithBezierPath:path2 w_x:w_x x_two:x_two right_y:right_y right_height:right_height andGradientStartY:0.0 andGradientEndY:1.0];
                
                x_two = pointX;
                
                continue;
                
            }
            
        } else {
            //两点都不在正确区间内
            if ([preModel.speedStr floatValue]>[preModel.maxSpeed floatValue] &&[model.speedStr floatValue]<[model.minSpeed floatValue]){
                
                
                UIBezierPath *path = [UIBezierPath bezierPath];
                //设置线条属性
                path.lineCapStyle = kCGLineJoinRound;  //线段端点格式
                path.lineJoinStyle = kCGLineJoinRound; //线段接头格式
                path.lineWidth = graphLineWidth;
                [path moveToPoint:CGPointMake(prePointX,prePointY)];
                
                
                // 第一个点在快速区间 第二个点在慢速区间
                // 第一个在上区间外，第二个在区间内
                //if (([preModel.maxSpeed floatValue] == [model.minSpeed floatValue] && [model.speedStr floatValue] > [preModel.minSpeed floatValue]) || ([preModel.speedStr floatValue] > [self.speedRangeArray[self.speedRangeArray.count-1] floatValue] && [model.speedStr floatValue] > [model.maxSpeed floatValue] && [model.speedStr floatValue] < [self.speedRangeArray[self.speedRangeArray.count-1] floatValue])) {
                if (pointY - prePointY < 0) {
                    
                    CGFloat right_y = 0;
                    CGFloat right_height = h_y;
                    if (pointY >= prePointY) { // 斜向下
                        right_y = prePointY;
                        right_height = pointY - prePointY;
                    }else{
                        right_y = pointY;
                        right_height = prePointY - pointY;
                    }
                    
                    preModel = model;
                    prePointX = pointX;
                    prePointY = pointY;
                    
                    [path addLineToPoint:CGPointMake(pointX, pointY)];
                    
                    self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor]];
                    
                    // 将折线添加到折线图层上，并设置相关的属性
                    [self viewforGradientWithBezierPath:path w_x:w_x x_two:x_two right_y:right_y right_height:right_height andGradientStartY:0.0 andGradientEndY:1.0];
                    
                    x_two = pointX;
                    continue;
                    
                }else{
                    
                    // 斜向下 // 跨区间
                    if ([preModel.maxSpeed floatValue] >= [model.maxSpeed floatValue]) {
                        
                        // 斜向下
                        float pointAY = self.bounds.size.height - kBottomPadding - [preModel.maxSpeed floatValue] * self.yAxisSpacing;
                        float pointAX = prePointX + (pointX - prePointX) * ((pointAY - prePointY) / (pointY - prePointY));
                        
                        float pointBY = self.bounds.size.height - kBottomPadding - [model.minSpeed floatValue] * self.yAxisSpacing;
                        float pointBX = prePointX + (pointX - prePointX) * ((pointBY - prePointY) / (pointY - prePointY));
                        
                        [path addLineToPoint:CGPointMake(pointAX, pointAY)];
                        
                        CGFloat right_y = prePointY;
                        CGFloat right_height = pointAY - prePointY;
                        
                        preModel = model;
                        prePointX = pointAX;
                        prePointY = pointAY;
                        
                        self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#2BE4BB"].CGColor]];
                        
                        [self viewforGradientWithBezierPath:path w_x:w_x x_two:x_two right_y:right_y right_height:right_height andGradientStartY:0.8 andGradientEndY:1.0];
                        
                        x_two = pointAX;
                        
                        // 再次连线到目标点
                        UIBezierPath *path2 = [UIBezierPath bezierPath];
                        //设置线条属性
                        path2.lineCapStyle = kCGLineJoinRound;  //线段端点格式
                        path2.lineJoinStyle = kCGLineJoinRound; //线段接头格式
                        path2.lineWidth = graphLineWidth;
                        [path2 moveToPoint:CGPointMake(prePointX,prePointY)];
                        
                        [path2 addLineToPoint:CGPointMake(pointBX, pointBY)];
                        
                        right_y = pointAY;
                        right_height = pointBY - pointAY;
                        
                        preModel = model;
                        prePointX = pointBX;
                        prePointY = pointBY;
                        
                        self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithHexString:@"#2BE4BB"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#2BE4BB"].CGColor]];
                        
                        [self viewforGradientWithBezierPath:path2 w_x:w_x x_two:x_two right_y:right_y right_height:right_height andGradientStartY:0.0 andGradientEndY:1.0];
                        
                        x_two = pointBX;
                        
                        // 再次连线
                        // 再次连线到目标点
                        UIBezierPath *path3 = [UIBezierPath bezierPath];
                        //设置线条属性
                        path3.lineCapStyle = kCGLineJoinRound;  //线段端点格式
                        path3.lineJoinStyle = kCGLineJoinRound; //线段接头格式
                        path3.lineWidth = graphLineWidth;
                        [path3 moveToPoint:CGPointMake(prePointX,prePointY)];
                        
                        [path3 addLineToPoint:CGPointMake(pointX, pointY)];
                        
                        right_y = pointBY;
                        right_height = pointY - pointBY;
                        
                        preModel = model;
                        prePointX = pointX;
                        prePointY = pointY;
                        
                        self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithHexString:@"#2BE4BB"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor]];
                        
                        [self viewforGradientWithBezierPath:path3 w_x:w_x x_two:x_two right_y:right_y right_height:right_height andGradientStartY:0.0 andGradientEndY:0.2];
                        
                        x_two = pointX;
                        continue;

                        
                    }else{
                        
                        // 未跨区间
                        CGFloat right_y = 0;
                        CGFloat right_height = h_y;
                        if (pointY >= prePointY) { // 斜向下
                            right_y = prePointY;
                            right_height = pointY - prePointY;
                        }else{
                            right_y = pointY;
                            right_height = prePointY - pointY;
                        }
                        
                        preModel = model;
                        prePointX = pointX;
                        prePointY = pointY;
                        
                        [path addLineToPoint:CGPointMake(pointX, pointY)];
                        
                        self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor]];
                        
                        // 将折线添加到折线图层上，并设置相关的属性
                        [self viewforGradientWithBezierPath:path w_x:w_x x_two:x_two right_y:right_y right_height:right_height andGradientStartY:0.0 andGradientEndY:1.0];
                        
                        x_two = pointX;
                        continue;

                        
                    }
                    
                }
                
            }else if ([preModel.speedStr floatValue]<[preModel.minSpeed floatValue]&&[model.speedStr floatValue]>[model.maxSpeed floatValue]){
                
                UIBezierPath *path = [UIBezierPath bezierPath];
                //设置线条属性
                path.lineCapStyle = kCGLineJoinRound;  //线段端点格式
                path.lineJoinStyle = kCGLineJoinRound; //线段接头格式
                path.lineWidth = graphLineWidth;
                [path moveToPoint:CGPointMake(prePointX,prePointY)];
                
                // 第一个点在慢速区间 第二个点在快速区间
                // 第一个在下区间外，第二个在区间内
                //if (([preModel.minSpeed floatValue] == [model.maxSpeed floatValue] && [model.speedStr floatValue] < [preModel.maxSpeed floatValue]) || ([preModel.speedStr floatValue] < [self.speedRangeArray[0] floatValue] && [model.speedStr floatValue] > [model.maxSpeed floatValue] && [model.speedStr floatValue] < [self.speedRangeArray[self.speedRangeArray.count-1] floatValue])) {
                if (pointY - prePointY > 0) {
                    
                    CGFloat right_y = 0;
                    CGFloat right_height = h_y;
                    if (pointY >= prePointY) { // 斜向下
                        right_y = prePointY;
                        right_height = pointY - prePointY;
                    }else{
                        right_y = pointY;
                        right_height = prePointY - pointY;
                    }
                    
                    preModel = model;
                    prePointX = pointX;
                    prePointY = pointY;
                    
                    [path addLineToPoint:CGPointMake(pointX, pointY)];
                    
                    self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor]];
                    
                    // 将折线添加到折线图层上，并设置相关的属性
                    [self viewforGradientWithBezierPath:path w_x:w_x x_two:x_two right_y:right_y right_height:right_height andGradientStartY:0.0 andGradientEndY:1.0];
                    
                    x_two = pointX;
                    continue;
                    
                }else{
                    
                    //斜向上 跨区间
                    if ([model.minSpeed floatValue] >= [preModel.minSpeed floatValue]) {
                        
                        // 斜向上
                        float pointAY = self.bounds.size.height - kBottomPadding - [preModel.minSpeed floatValue] * self.yAxisSpacing;
                        float pointAX = prePointX + (pointX - prePointX) * ((pointAY - prePointY) / (pointY - prePointY));
                        
                        float pointBY = self.bounds.size.height - kBottomPadding - [model.maxSpeed floatValue] * self.yAxisSpacing;
                        float pointBX = prePointX + (pointX - prePointX) * ((pointBY - prePointY) / (pointY - prePointY));
                        
                        [path addLineToPoint:CGPointMake(pointAX, pointAY)];
                        
                        CGFloat right_y = pointAY;
                        CGFloat right_height = prePointY - pointAY;
                        
                        preModel = model;
                        prePointX = pointAX;
                        prePointY = pointAY;
                        
                        self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithHexString:@"#2BE4BB"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor]];
                        
                        [self viewforGradientWithBezierPath:path w_x:w_x x_two:x_two right_y:right_y right_height:right_height andGradientStartY:0.0 andGradientEndY:0.2];
                        
                        x_two = pointAX;
                        
                        
                        // 再次连线到目标点
                        UIBezierPath *path2 = [UIBezierPath bezierPath];
                        //设置线条属性
                        path2.lineCapStyle = kCGLineJoinRound;  //线段端点格式
                        path2.lineJoinStyle = kCGLineJoinRound; //线段接头格式
                        path2.lineWidth = graphLineWidth;
                        [path2 moveToPoint:CGPointMake(prePointX,prePointY)];
                        
                        [path2 addLineToPoint:CGPointMake(pointBX, pointBY)];
                        
                        right_y = pointBY;
                        right_height = pointAY - pointBY;
                        
                        preModel = model;
                        prePointX = pointBX;
                        prePointY = pointBY;
                        
                        self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithHexString:@"#2BE4BB"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#2BE4BB"].CGColor]];
                        
                        [self viewforGradientWithBezierPath:path2 w_x:w_x x_two:x_two right_y:right_y right_height:right_height andGradientStartY:0.0 andGradientEndY:1.0];
                        
                        x_two = pointBX;
                        
                        
                        // 再次连线
                        // 再次连线到目标点
                        UIBezierPath *path3 = [UIBezierPath bezierPath];
                        //设置线条属性
                        path3.lineCapStyle = kCGLineJoinRound;  //线段端点格式
                        path3.lineJoinStyle = kCGLineJoinRound; //线段接头格式
                        path3.lineWidth = graphLineWidth;
                        [path3 moveToPoint:CGPointMake(prePointX,prePointY)];
                        
                        [path3 addLineToPoint:CGPointMake(pointX, pointY)];
                        
                        right_y = pointY;
                        right_height = pointBY - pointY;
                        
                        preModel = model;
                        prePointX = pointX;
                        prePointY = pointY;
                        
                        self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#2BE4BB"].CGColor]];
                        
                        [self viewforGradientWithBezierPath:path3 w_x:w_x x_two:x_two right_y:right_y right_height:right_height andGradientStartY:0.8 andGradientEndY:1.0];
                        
                        x_two = pointX;
                        continue;

                        
                    }else{
                        
                        // 未跨区间
                        CGFloat right_y = 0;
                        CGFloat right_height = h_y;
                        if (pointY >= prePointY) { // 斜向下
                            right_y = prePointY;
                            right_height = pointY - prePointY;
                        }else{
                            right_y = pointY;
                            right_height = prePointY - pointY;
                        }
                        
                        preModel = model;
                        prePointX = pointX;
                        prePointY = pointY;
                        
                        [path addLineToPoint:CGPointMake(pointX, pointY)];
                        
                        self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor]];
                        
                        // 将折线添加到折线图层上，并设置相关的属性
                        [self viewforGradientWithBezierPath:path w_x:w_x x_two:x_two right_y:right_y right_height:right_height andGradientStartY:0.0 andGradientEndY:1.0];
                        
                        x_two = pointX;
                        continue;
                        
                    }
                    
                }
                
            }else {
                // 两点都超速或都未达到速度
                if (i == 0) {
                    
                    // 速度大于当前最大速度
                    if ([model.speedStr floatValue] > [model.maxSpeed floatValue]) {
                        
                        UIBezierPath *path = [UIBezierPath bezierPath];
                        //设置线条属性
                        path.lineCapStyle = kCGLineJoinRound;  //线段端点格式
                        path.lineJoinStyle = kCGLineJoinRound; //线段接头格式
                        path.lineWidth = graphLineWidth;
                        [path moveToPoint:CGPointMake(prePointX,prePointY)];
                        
                        // 斜向上
                        float pointAY = self.bounds.size.height - kBottomPadding - [model.minSpeed floatValue] * self.yAxisSpacing;
                        float pointAX = prePointX + (pointX - prePointX) * ((pointAY - prePointY) / (pointY - prePointY));
                        
                        float pointBY = self.bounds.size.height - kBottomPadding - [model.maxSpeed floatValue] * self.yAxisSpacing;
                        float pointBX = prePointX + (pointX - prePointX) * ((pointBY - prePointY) / (pointY - prePointY));
                        
                        [path addLineToPoint:CGPointMake(pointAX, pointAY)];
                        
                        CGFloat right_y = pointAY;
                        CGFloat right_height = h_y - pointAY;
                        
                        preModel = model;
                        prePointX = pointAX;
                        prePointY = pointAY;
                        
                        self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithHexString:@"#2BE4BB"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor]];
                        
                        [self viewforGradientWithBezierPath:path w_x:w_x x_two:x_two right_y:right_y right_height:right_height andGradientStartY:0.0 andGradientEndY:0.2];
                        
                        x_two = pointAX;
                        
                        
                        // 再次连线到目标点
                        UIBezierPath *path2 = [UIBezierPath bezierPath];
                        //设置线条属性
                        path2.lineCapStyle = kCGLineJoinRound;  //线段端点格式
                        path2.lineJoinStyle = kCGLineJoinRound; //线段接头格式
                        path2.lineWidth = graphLineWidth;
                        [path2 moveToPoint:CGPointMake(prePointX,prePointY)];
                        
                        [path2 addLineToPoint:CGPointMake(pointBX, pointBY)];
                        
                        right_y = pointBY;
                        right_height = pointAY - pointBY;
                        
                        preModel = model;
                        prePointX = pointBX;
                        prePointY = pointBY;
                        
                        self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithHexString:@"#2BE4BB"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#2BE4BB"].CGColor]];
                        
                        [self viewforGradientWithBezierPath:path2 w_x:w_x x_two:x_two right_y:right_y right_height:right_height andGradientStartY:0.0 andGradientEndY:1.0];
                        
                        x_two = pointBX;
                        
                        
                        // 再次连线
                        // 再次连线到目标点
                        UIBezierPath *path3 = [UIBezierPath bezierPath];
                        //设置线条属性
                        path3.lineCapStyle = kCGLineJoinRound;  //线段端点格式
                        path3.lineJoinStyle = kCGLineJoinRound; //线段接头格式
                        path3.lineWidth = graphLineWidth;
                        [path3 moveToPoint:CGPointMake(prePointX,prePointY)];
                        
                        
                        [path3 addLineToPoint:CGPointMake(pointX, pointY)];
                        
                        right_y = pointY;
                        right_height = pointBY - pointY;
                        
                        preModel = model;
                        prePointX = pointX;
                        prePointY = pointY;
                        
                        self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#2BE4BB"].CGColor]];
                        
                        [self viewforGradientWithBezierPath:path3 w_x:w_x x_two:x_two right_y:right_y right_height:right_height andGradientStartY:0.8 andGradientEndY:1.0];
                        
                        x_two = pointX;
                        continue;
                        
                    }else{
                        self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor]];
                    }
                    
                }else{
                    self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor]];
                }
                
            }
        }
        
        CGFloat right_y = 0;
        CGFloat right_height = h_y;
        if (pointY >= prePointY) { // 斜向下
            right_y = prePointY;
            right_height = pointY - prePointY;
        }else{
            right_y = pointY;
            right_height = prePointY - pointY;
        }
        
        preModel = model;
        prePointX = pointX;
        prePointY = pointY;
        
        [pathTwo addLineToPoint:CGPointMake(pointX, pointY)];
        
        //将折线添加到折线图层上，并设置相关的属性
        [self viewforGradientWithBezierPath:pathTwo w_x:w_x x_two:x_two right_y:right_y right_height:right_height andGradientStartY:0.0 andGradientEndY:1.0];
        
        x_two = pointX;
    }
    
}

@end
