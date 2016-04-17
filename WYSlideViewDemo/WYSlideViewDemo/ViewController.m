//
//  ViewController.m
//  WYSlideViewDemo
//
//  Created by sialice on 16/4/17.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "WYSlideView.h"

@interface ViewController ()
- (IBAction)isAutoSizeToFit:(UISwitch *)sender;
- (IBAction)isScrollToCenter:(UISwitch *)sender;
- (IBAction)isShowButtomView:(UISwitch *)sender;

@property (nonatomic, weak) WYSlideView *slideView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
#pragma mark - 根据字符串创建
    
    // 创建view
    NSArray *strArr = @[@"第一页紫色", @"第二页绿色wy", @"第三页橘色wywy", @"这是第四页黑色wywywy", @"这是第五页红色", @"wy", @"wywy", @"sss"];
    
    WYSlideView *slideView = [WYSlideView slideViewWithTitleArray:strArr itemClickBlock:^(NSInteger fromIndex, NSInteger toIndex) {
        /**** 这里传入模型索引 可以在此转场 ***/
        NSLog(@"from:%zd--to:%zd", fromIndex, toIndex);
    }];
    
    // 设置frame
    [slideView setFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 64)];
    [slideView setBackgroundColor:[UIColor greenColor]];
    self.slideView = slideView;
    [self.view addSubview:slideView];
    slideView.sizeToFit = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)isAutoSizeToFit:(UISwitch *)sender {
    self.slideView.sizeToFit = sender.isOn;
}

- (IBAction)isScrollToCenter:(UISwitch *)sender {
     self.slideView.autoScrollToCenter = sender.isOn;
}

- (IBAction)isShowButtomView:(UISwitch *)sender {
    self.slideView.showButtomView = sender.isOn;
}


/*** 颜色 **/
- (IBAction)normalTitleBlack:(UIButton *)sender {
    [self.slideView setTitleNormalColor:[UIColor blackColor]];
}

- (IBAction)normalTitleBlue:(UIButton *)sender {
    [self.slideView setTitleNormalColor:[UIColor blueColor]];
}

- (IBAction)normalTitleYellow:(UIButton *)sender {
    [self.slideView setTitleNormalColor:[UIColor yellowColor]];
}


- (IBAction)selectedYellow:(id)sender {
    [self.slideView setTitleSelectedColor:[UIColor yellowColor]];
}
- (IBAction)selectedBlue:(id)sender {
    [self.slideView setTitleSelectedColor:[UIColor blueColor]];
}
- (IBAction)selectedRed:(id)sender {
    [self.slideView setTitleSelectedColor:[UIColor redColor]];
}


@end
