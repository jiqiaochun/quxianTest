//
//  JYRunningGraphView.h
//  减约
//
//  Created by 姬巧春 on 2017/3/20.
//  Copyright © 2017年 北京减脂时代科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYRunningGraphModel.h"

@interface JYRunningGraphView : UIView

// pointArray -- 存放 JYRunningGraphModel 数据
// speedRangeArray -- 存放区间速度 速度从小到大存放 比如 4.5 5.5 7.0 9.5 用于画y轴横线
// totalTime -- 总时长（分钟）

// 初始化
- (instancetype)initWithFrame:(CGRect)frame andPointArray:(NSArray<JYRunningGraphModel *> *)pointArray andSpeedRangeArray:(NSArray<NSString *> *)speedRangeArray andTotalTime:(NSString *)totalTime;

@end
