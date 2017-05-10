//
//  JYRunningGraphModel.h
//  减约
//
//  Created by 姬巧春 on 2017/3/20.
//  Copyright © 2017年 北京减脂时代科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYRunningGraphModel : NSObject

@property (nonatomic,copy) NSString *timeStr; // 时间 秒
@property (nonatomic,copy) NSString *speedStr; // 速度

@property (nonatomic,copy) NSString *maxSpeed; // 当前区间最大速度
@property (nonatomic,copy) NSString *minSpeed; // 当前区间最小速度

// 辅助属性
@property (nonatomic,assign) BOOL isIn;// 在不在速度区间

@end
