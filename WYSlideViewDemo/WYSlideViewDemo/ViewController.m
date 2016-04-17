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

@property (nonatomic, strong) NSMutableArray *arrM;
@property (nonatomic, weak) UIView *contentView;

@property (nonatomic, weak) WYSlideView *slideView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 创建contentView
    UIView *contentView = [[UIView alloc] init];
    contentView.frame = CGRectMake(0, 84, [UIScreen mainScreen].bounds.size.width, 330);
    [contentView setBackgroundColor:[UIColor purpleColor]];
    self.contentView = contentView;
    [self.view addSubview:contentView];
    NSMutableArray *arrM = [NSMutableArray array];
    self.arrM = arrM;
    for (int i = 0; i < 10; i++) {
        UIView *view = [[UIView alloc] init];
        [view setFrame:self.contentView.bounds];
//        view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
        [view setBackgroundColor:[UIColor colorWithRed:(arc4random()%255 * 1.0f)/255.0 green:(arc4random()%255 * 1.0f)/255.0 blue:(arc4random()%255 * 1.0f)/255.0 alpha:1.0]];
        [self.arrM addObject:view];
    }
    [self.contentView addSubview:self.arrM[0]];
    
#pragma mark - 根据字符串创建
    
    // 创建view
    NSArray *strArr = @[@"第一页紫色", @"第二页绿色wy", @"第三页橘色wywy", @"这是第四页黑色wywywy", @"这是第五页红色", @"wy", @"wywy", @"sss", @"123", @"最后一个"];
    
    WYSlideView *slideView = [WYSlideView slideViewWithTitleArray:strArr itemClickBlock:^(NSInteger fromIndex, NSInteger toIndex) {
        /**** 这里传入模型索引 可以在此转场 ***/
        NSLog(@"from:%zd--to:%zd", fromIndex, toIndex);
        
        // 例如：
        UIView *toView = self.arrM[toIndex];
        // 右滑出现则先挪至右边，左滑出现则挪至左边
        CGRect frame =  toView.frame;
        frame.origin.x = toIndex > fromIndex ? frame.size.width : - frame.size.width;
//        frame.size.height += 64;
        toView.frame = frame;
        [self.contentView addSubview:toView];
         NSLog(@"-==%@", self.contentView.subviews);
        [UIView animateWithDuration:0.5f animations:^{
            UIView *fromView = [self.contentView.subviews lastObject];
            UIView *toView = self.arrM[toIndex];
            
            CGRect fromFrame =  fromView.frame;
            CGRect toFrame =  toView.frame;
            // 与上对应消失
            fromFrame.origin.x = toIndex > fromIndex ? - frame.size.width : frame.size.width;
            toFrame.origin.x = 0;
            fromView.frame = fromFrame;
            toView.frame = toFrame;
        } completion:^(BOOL finished) {
            [[self.contentView.subviews firstObject] removeFromSuperview];
            NSLog(@"-==%@", self.contentView.subviews);
        }];

        
    }];
    
    // 设置frame
    [slideView setFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 64)];
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
