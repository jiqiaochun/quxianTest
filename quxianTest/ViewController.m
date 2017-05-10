//
//  ViewController.m
//  quxianTest
//
//  Created by 姬巧春 on 2017/3/23.
//  Copyright © 2017年 姬巧春. All rights reserved.
//

#import "ViewController.h"

#import "JYRunningGraphModel.h"
#import "JYRunningGraphView.h"
#import "NSObject+YYModel.h"

#import "JYRunningChartView.h"

@interface ViewController ()

@property (nonatomic,strong) JYRunningGraphView *lineGraphView;

@property (nonatomic,strong) JYRunningChartView *lineCharView;

@end

@implementation ViewController

#define dianData 30
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

- (void)quxian{
    NSMutableArray *needArray = [NSMutableArray array];
    
    NSMutableArray *timeArray = [NSMutableArray array];
    int time = 0;
    for (int i = 0; i < dianData * 3; i++) {
        time = time + 20;
        [timeArray addObject:[NSString stringWithFormat:@"%d",time]];
    }
    
    
    NSMutableArray *speedArray = [NSMutableArray array];
    for (int i = 0; i < dianData * 3; i++) {
        CGFloat speed = 3 + random() % 9 + (float)(rand() % 100) /100;
        [speedArray addObject:[NSString stringWithFormat:@"%lf",speed]];
        
    }
    NSLog(@"speedArray = %@",speedArray);
    
    NSMutableArray *minArray = [NSMutableArray array];
    for (int i = 0; i < dianData * 3; i++) {
        
        if (i < 10) {
            [minArray addObject:@"4.0"];
        }else if (i >= 10 && i < 20){
            [minArray addObject:@"5.5"];
        }else if (i >= 30 && i < 40){
            [minArray addObject:@"7.0"];
        }else if (i >= 40 && i < 50){
            [minArray addObject:@"4.0"];
        }else if (i >= 50 && i < 60){
            [minArray addObject:@"5.5"];
        }else if (i >= 60 && i < 70){
            [minArray addObject:@"7.0"];
        }else if (i >= 70 && i < 80){
            [minArray addObject:@"4.0"];
        }else{
            [minArray addObject:@"5.5"];
        }
        
        
    }
    
    NSMutableArray *maxArray = [NSMutableArray array];
    for (int i = 0; i < dianData * 3; i++) {
        
        if (i < 10) {
            [maxArray addObject:@"5.5"];
        }else if (i >= 10 && i < 20){
            [maxArray addObject:@"7.0"];
        }else if (i >= 30 && i < 40){
            [maxArray addObject:@"9.5"];
        }else if (i >= 40 && i < 50){
            [maxArray addObject:@"5.5"];
        }else if (i >= 50 && i < 60){
            [maxArray addObject:@"7.0"];
        }else if (i >= 60 && i < 70){
            [maxArray addObject:@"9.5"];
        }else if (i >= 70 && i < 80){
            [maxArray addObject:@"5.5"];
        }else{
            [maxArray addObject:@"7.0"];
        }
        
    }
    
    for (int i = 0; i < dianData * 3; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:timeArray[i] forKey:@"timeStr"];
        [dic setObject:speedArray[i] forKey:@"speedStr"];
        [dic setObject:minArray[i] forKey:@"minSpeed"];
        [dic setObject:maxArray[i] forKey:@"maxSpeed"];
        
        JYRunningGraphModel *model = [JYRunningGraphModel modelWithDictionary:dic];
        [needArray addObject:model];
    }
    
    NSArray *pointArray = [NSArray arrayWithArray:needArray];
    
    
    JYRunningGraphView *lineGraphView = [[JYRunningGraphView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 270) andPointArray:pointArray andSpeedRangeArray:@[@"4.0",@"5.5",@"7.0",@"9.5",@"20"] andTotalTime:[NSString stringWithFormat:@"%d",dianData]];
    [self.view addSubview:lineGraphView];
    self.lineGraphView = lineGraphView;
     
    /*
    JYRunningChartView *lineCharView = [[JYRunningChartView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 270) andPointArray:pointArray andSpeedRangeArray:@[@"4.0",@"5.5",@"7.0",@"9.5"] andTotalTime:@"30"];
    [self.view addSubview:lineCharView];
    self.lineCharView = lineCharView;
    */
    
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(80, 330, 100, 50)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"曲线" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(230, 330, 100, 50)];
    btn2.backgroundColor = [UIColor redColor];
    [btn2 setTitle:@"曲线移除" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btnClick2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];

}

- (void)btnClick:(UIButton *)btn{
    [self quxian];
}

- (void)btnClick2:(UIButton *)btn{
    [self.lineGraphView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
