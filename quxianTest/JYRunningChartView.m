//
//  JYRunningChartView.m
//  quxianTest
//
//  Created by 姬巧春 on 2017/3/23.
//  Copyright © 2017年 姬巧春. All rights reserved.
//

#import "JYRunningChartView.h"

#import "JYRunningGraphModel.h"
#import "UIColor+JYColor.h"
#import "UIView+JYFrame.h"


/** 坐标轴信息区域高度 */
static const CGFloat kBottomPadding = 65.0;

/** 坐标轴信息区域宽度 */
static const CGFloat kleftPadding = 39.0;

/** 坐标系中横线的宽度 */
static const CGFloat kCoordinateLineWith = 0.5;

@interface JYRunningChartView ()

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

@implementation JYRunningChartView

// 初始化
- (instancetype)initWithFrame:(CGRect)frame andPointArray:(NSArray<JYRunningGraphModel *> *)pointArray andSpeedRangeArray:(NSArray<NSString *> *)speedRangeArray andTotalTime:(NSString *)totalTime{
    
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
        
        _yAxisSpacing = (self.bounds.size.height - kBottomPadding) / 20.0;
        
    }
    return _yAxisSpacing;
}

// X轴信息
- (NSMutableArray<NSString *> *)xAxisInformationArray {
    if (_xAxisInformationArray == nil) {
        // 创建可变数组
        _xAxisInformationArray = [[NSMutableArray alloc] init];
        
        if ([self.totalTime intValue] < 30) {
            self.totalTime = @"30";
        }
        
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

- (void)viewforGradientWithBezierPath:(UIBezierPath *)path {
    
    /** 将折线添加到折线图层上，并设置相关的属性 */
    CAShapeLayer *lineChartLayer = [CAShapeLayer layer];
    lineChartLayer.path = path.CGPath;
    lineChartLayer.strokeColor = [UIColor whiteColor].CGColor;
    lineChartLayer.fillColor = [[UIColor clearColor] CGColor];
    // 默认设置路径宽度为0，使其在起始状态下不显示
    lineChartLayer.lineWidth = graphLineWidth;
    lineChartLayer.lineCap = kCALineCapRound;
    lineChartLayer.lineJoin = kCALineJoinRound;
    
    
    // 渐变背景视图（不包含坐标轴）
    UIView *gradientBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(kleftPadding,0,self.bounds.size.width-15,self.bounds.size.height-kBottomPadding)];
    [self addSubview:gradientBackgroundView];
    
    // 创建并设置渐变背景图层
    //初始化CAGradientlayer对象，使它的大小为渐变背景视图的大小
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = gradientBackgroundView.bounds;
    //设置渐变区域的起始和终止位置（范围为0-1），即渐变路径
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(0.0, 1.0);
    //设置颜色的渐变过程
    gradientLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.8],[NSNumber numberWithFloat:1.0],nil];
    self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#2BE4BB"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#FFB66F"].CGColor]];
    gradientLayer.colors = self.gradientLayerColors;
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [gradientBackgroundView.layer addSublayer:gradientLayer];
    
    // 设置折线图层为渐变图层的mask
    //gradientBackgroundView.layer.mask = lineChartLayer;
    
}


- (void)setupLineChartLayerAppearance{
    
    CGFloat prePointX = 0;
    CGFloat prePointY = self.bounds.size.height - kBottomPadding;
    CGFloat pointX = 0;
    CGFloat pointY = 0;
    
    UIBezierPath *pathTwo = [UIBezierPath bezierPath];
    //设置线条属性
    pathTwo.lineCapStyle = kCGLineJoinRound;  //线段端点格式
    pathTwo.lineJoinStyle = kCGLineJoinRound; //线段接头格式
    pathTwo.lineWidth = graphLineWidth;
    [pathTwo moveToPoint:CGPointMake(prePointX,prePointY)];
    
    for (NSInteger i = 0; i < self.pointArray.count; i++) {
        
        JYRunningGraphModel *model = self.pointArray[i];
        model.isIn = ([model.speedStr floatValue] >= [model.minSpeed floatValue] && [model.speedStr floatValue] <= [model.maxSpeed floatValue]);
        
        // 转化最大和最小速度
        if ([model.speedStr floatValue] > 20 ) {
            model.speedStr = @"20";
        }else if ([model.speedStr floatValue] < 0){
            model.speedStr = @"0";
        }
        
        // 大于区间最大速度之后转化 maxSpeedF--20之间的密度变化
        CGFloat maxSpeedF = 12;
        if ([model.speedStr floatValue]> maxSpeedF) {
            CGFloat needSpeed = ([model.speedStr floatValue] - maxSpeedF) * 0.5 + maxSpeedF;
            model.speedStr = [NSString stringWithFormat:@"%lf",needSpeed];
        }
        
        pointX = self.pointxAxisSpacing * 0.5 + ceil([model.timeStr floatValue] / 20.0) * self.pointxAxisSpacing;
        pointY = self.bounds.size.height - kBottomPadding - [model.speedStr floatValue] * self.yAxisSpacing;
       
        
        [pathTwo addLineToPoint:CGPointMake(pointX, pointY)];
    
    }
    
    //将折线添加到折线图层上，并设置相关的属性
    [self viewforGradientWithBezierPath:pathTwo];
    
}


@end
