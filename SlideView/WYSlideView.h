//
//  WYSlideView.h
//  03-25WYSlideView
//
//  Created by sialice on 16/3/25.
//  Copyright © 2016年 sialice. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WYSlideViewItem;

#pragma mark - WYSlideView
@interface WYSlideView : UIScrollView

/** 类方法 */
+ (instancetype)slideViewWithTitleArray:(NSArray<NSString *> *)titleArray itemClickBlock:(void (^)(NSInteger fromIndex, NSInteger toIndex))block;

/** 类方法 */
+ (instancetype)slideViewWithItemArray:(NSArray<WYSlideViewItem *> *)titleArray itemClickBlock:(void (^)(NSInteger fromIndex, NSInteger toIndex))block;

/** 文字普通状态的颜色 */
@property (nonatomic, strong) UIColor *titleNormalColor;

/** 文字选中状态的颜色 */
@property (nonatomic, strong) UIColor *titleSelectedColor;

/** 是否自适应 默认为NO*/
@property (nonatomic, assign, getter=isSizeToFit) BOOL sizeToFit;

/** 设置是否允许自动滚动至中心 默认为YES*/
@property (nonatomic, assign, getter=isAutoScrollToCenter) BOOL autoScrollToCenter;

/** 选中时是否放大 */
@property (nonatomic, assign) BOOL canZoom;

/** 是否显示底部的滑动条 */
@property (nonatomic, assign) BOOL showButtomView;

/** 底部滑动条的粗度 仅当可显示时有效 */
@property (nonatomic, assign) CGFloat buttomViewHeight;

/** 设置按钮间距  默认值是18 */
@property (nonatomic, assign) CGFloat itemPadding;


/** 模型数组 */
- (void)setItemArrM:(NSArray<WYSlideViewItem *> *)itemArrM;

@end

#pragma mark - WYSlideViewItem
@interface WYSlideViewItem : NSObject

/** 文字 */
@property (nonatomic, copy) NSString *title;

/** 文字普通状态的颜色 */
@property (nonatomic, strong) UIColor *titleNormalColor;

/** 文字选中状态的颜色 */
@property (nonatomic, strong) UIColor *titleSelectedColor;

/** 设置按钮选中的缩放比例 默认值为1.4 */
@property (nonatomic, assign) CGFloat scale;

@end





