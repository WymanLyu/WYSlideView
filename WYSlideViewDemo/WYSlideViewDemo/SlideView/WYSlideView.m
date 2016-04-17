//
//  WYSlideView.m
//  03-25WYSlideView
//
//  Created by sialice on 16/3/25.
//  Copyright © 2016年 sialice. All rights reserved.
//

#import "WYSlideView.h"

#define DEFAUL_TITLENORMALCOLOR [UIColor blackColor]
#define DEFAUL_TITLESELECTEDCOLOR [UIColor redColor]
#define DEFAUL_ITEMPADDING 18
#define DEFAUL_TRANSFORMSCALE 1.4
#define DEFAUL_BUTTOMVIEWHEIGHT 3.5
#define DEFAUL_TITLEFONT [UIFont systemFontOfSize:17.0f]

// 函数声明
static CGRect getStringSize(NSString *str);
static CGFloat getArrayMaxObject(NSArray<NSNumber *> *array);

@interface WYSlideView ()
{
    /** 模型数组 */
    NSArray *_itemArrM;
    /** 子控件的数组 */
    NSMutableArray *_btnArrM;
    
}
/** 自适应内容宽度 */
@property (nonatomic, assign) CGFloat sumWidth;

/** 自适应内容最大宽度 */
@property (nonatomic, assign) CGFloat maxWidth;

/** 是否计算完毕 */
@property (nonatomic, assign, readonly, getter=isCaculated) BOOL caculated;

/** 选中的按钮 */
@property (nonatomic, weak) UIButton *selectedBtn;

/** 选中回调block */
@property (nonatomic, copy) void (^block)(NSInteger, NSInteger);

/** 底部滑动条 */
@property (nonatomic, weak) UIView *buttomView;

@end

@implementation WYSlideView

/** 懒加载 */
- (NSMutableArray *)btnArrM {
    if (_btnArrM == nil) {
        _btnArrM = [NSMutableArray array];
    }
    return _btnArrM;
}

#pragma mark - 初始化方法
/** 类方法 */
+ (instancetype)slideViewWithTitleArray:(NSArray<NSString *> *)titleArray itemClickBlock:(void (^)(NSInteger fromIndex, NSInteger toIndex))block {
    // 创建模型
    NSMutableArray *itemTempArrM = [NSMutableArray array];
    for (NSString *title in titleArray) {
        WYSlideViewItem *item = [[WYSlideViewItem alloc] init];
        item.title = title;
        [itemTempArrM addObject:item];
    }
    
    // 创建view
    return [self slideViewWithItemArray:itemTempArrM itemClickBlock:block];
}

+ (instancetype)slideViewWithItemArray:(NSArray<WYSlideViewItem *> *)itemArray itemClickBlock:(void (^)(NSInteger fromIndex, NSInteger toIndex))block {
    // 创建view
    WYSlideView *slideView = [[self alloc] init];
    slideView.block = block;
    [slideView setItemArrM:[NSArray arrayWithArray:itemArray]];
    return slideView;
}

/** 初始化 设置初始状态 */
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置初始化状态
        self.autoScrollToCenter = YES;
        self.sizeToFit = NO;
        self.itemPadding = DEFAUL_ITEMPADDING;
        self.showsHorizontalScrollIndicator = NO;
        self.canZoom = YES;
        self.showButtomView = YES;
        self.buttomViewHeight = DEFAUL_BUTTOMVIEWHEIGHT;
        
        // 设置底部条的view
        UIView *buttomView = [[UIView alloc] init];
        [self addSubview:buttomView];
        self.buttomView = buttomView;
    }
    return self;
}

/** 初始化子控件 */
- (void)initSubBtns {
    NSInteger count = _itemArrM.count;
    for (NSInteger i = 0; i < count; i++) {
        // 1.1.创建按钮
        UIButton *btn = [[UIButton alloc] init];
        [self addSubview:btn];
        [self.btnArrM addObject:btn];
    }
}

#pragma mark - 子控件布局

/** 获取模型 进入布局 */
- (void)setItemArrM:(NSArray *)itemArrM {
    _itemArrM = itemArrM;
    // 1.根据模型创建Button
    [self initSubBtns];
    
    // 2.布局子控件
    [self setupSubBtns];
}

/** 第一次布局 */
- (void)setupSubBtns {
    // 0.需要记录的变量并标记重新布局
    NSInteger count = _itemArrM.count;
    CGFloat sumWidth = 0;
    NSMutableArray *widthArr = [NSMutableArray array];
    _caculated = NO;
    self.selectedBtn.transform = CGAffineTransformIdentity; // 开始布局还原选中按钮的尺寸
    
    // 1.设置子控件frame
    for (NSInteger i = 0; i < count; i++) {
        WYSlideViewItem *item = _itemArrM[i];
        // 0.补齐item的属性
        if (!item.titleNormalColor) item.titleNormalColor = DEFAUL_TITLENORMALCOLOR;
        if (!item.titleSelectedColor) item.titleSelectedColor = DEFAUL_TITLESELECTEDCOLOR;
        if (!item.scale) item.scale = DEFAUL_TRANSFORMSCALE;
        
        // 1.1.获取按钮
        UIButton *btn = _btnArrM[i];

        // 1.2.设置按钮属性
        [btn.titleLabel setFont:DEFAUL_TITLEFONT];
        [btn setTag:i];
        [btn setTitle:item.title forState:UIControlStateNormal];
        [btn setTitleColor:item.titleNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:item.titleSelectedColor forState:UIControlStateSelected];
        
        // 1.3.设置按钮frame
        CGRect titleSize = getStringSize(item.title);
        CGFloat btnX = sumWidth;
        CGFloat btnY = 0;
        CGFloat btnW = titleSize.size.width + self.itemPadding;
        CGFloat btnH = 0; // 未知，需要依据自身高度
        sumWidth = btnW + sumWidth;
        [btn setFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        
        // 记录自适应尺寸
        [widthArr addObject:@(btnW)];
        
        // 1.4.监听点击
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    // 2.排序获取自适应宽度的最大值和最小值
    self.maxWidth = getArrayMaxObject(widthArr);
    
    // 3.根据子控件设置自身内容滚动大小
    CGFloat contentW = sumWidth;
    self.contentSize = CGSizeMake(contentW, 0);
    self.sumWidth = sumWidth;
    
    // 4.强制重新布局（查看是否采用此布局还是等比例布局）
    [self setNeedsLayout];
}

/** 自动布局 */
- (void)layoutSubviews {
    [super layoutSubviews];

    // 1.已经计算则不再计算
    if (self.isCaculated) return;
    
    // 2.设置高度
    [_btnArrM enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton *)obj;
        CGRect frame = btn.frame;
        frame.size.height = self.frame.size.height;
        btn.frame = frame;
    }];
    
    // 3.逻辑判断
    /*
     1.如果自适应的内容宽度 < 自身宽度，则强制性等分布局
     2.如果自适应的内容宽度 > 自身宽度，则询问是否采用自动布局
        * 自动布局 则不处理
        * 等分布局
            + 如果自适应内容的最大宽度 < 自身宽度， 则按自身宽度等比分布局
            + 如果自适应内容的最小宽度 > 自身宽度， 则按内容最大宽度等分布局
     
     */
    if (self.contentSize.width < self.frame.size.width) { // 内容自适应宽度比设置frame小,只能等分布局
        NSLog(@"内容自适应最大宽度比设置可视宽度小,只能等比分布局");
        [self setupSubBtnsScale];
    } else { // 内容自适应宽度比设置frame大,根据是否自适应来布局
        // 自适应则不重新布局
        if (self.isSizeToFit) {
            NSLog(@"内容自适应最大宽度比设置可视宽度大,选择了自适应布局");
        } else {
            NSLog(@"内容自适应最大宽度比设置可视宽度大,选择了等比分布局");
            // 不自适应则等比分布局
            [self setupSubBtnsScale];
        }
    }
    
    // 4.标记已计算完毕
    [self btnClick:self.selectedBtn]; // 布局完毕选中原始按钮
    _caculated = YES;
    
}

/** 第二次布局子控件 */
- (void)setupSubBtnsScale {
    NSInteger count = _itemArrM.count;
    
    // 1..设置按钮frame
    // 内容自适应宽度比设置frame宽度大,则按最大宽度计算，否则则按frame计算
    CGFloat btnW = self.contentSize.width > self.frame.size.width ? self.maxWidth : self.frame.size.width / count;
    CGFloat btnH = self.frame.size.height;
    for (NSInteger i = 0; i < count; i++) {
        UIButton *btn = _btnArrM[i];
        CGFloat btnX = btnW * i;
        CGFloat btnY = 0;
        [btn setFrame:CGRectMake(btnX, btnY, btnW, btnH)];
    }
    
    // 2.根据子控件设置自身内容滚动区大小
    CGFloat contentW = btnW * count;
    self.contentSize = CGSizeMake(contentW, 0);

}

#pragma mark - 设置显示相关属性

/** 设置item边距 更新布局 */
-(void)setItemPadding:(CGFloat)itemPadding {
    _itemPadding = itemPadding;
    [self setupSubBtns];
}

/** 是否自适应 */
- (void)setSizeToFit:(BOOL)sizeToFit {
    _sizeToFit = sizeToFit;
    [self setupSubBtns];
}

/** 设置底部隐藏 */
- (void)setShowButtomView:(BOOL)showButtomView {
    _showButtomView = showButtomView;
    self.buttomView.hidden = !showButtomView;
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor {
    [_itemArrM makeObjectsPerformSelector:@selector(setTitleNormalColor:) withObject:titleNormalColor];
    [self setupSubBtns];
}

- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor {
     [_itemArrM makeObjectsPerformSelector:@selector(setTitleSelectedColor:) withObject:titleSelectedColor];
    [self setupSubBtns];
}

#pragma mark - 点击事件

/** 点击事件 */
- (void)btnClick:(UIButton *)button {
    // 1.回复选中
    NSInteger from = self.selectedBtn.tag;
    self.selectedBtn.transform = CGAffineTransformIdentity;
    self.selectedBtn.selected = NO;
    self.selectedBtn.userInteractionEnabled = YES;
    
    // 2.设置选中
    self.selectedBtn = button;
    self.selectedBtn.selected = YES;
    self.selectedBtn.userInteractionEnabled = NO; // 用此方式过滤重复点击，因为此方法布局时要调用
    WYSlideViewItem *item = _itemArrM[button.tag];
    
    // 3.设置字体形变
    if (self.canZoom) { // 允许选中放大
        [UIView animateWithDuration:0.25f animations:^{
            self.selectedBtn.transform = CGAffineTransformMakeScale(1, item.scale); // 此方式在再次重新布局时候会出错
        }];
    }
   
    // 4.设置滚动
    if (self.isAutoScrollToCenter) { // 允许滚动
        // 目标偏移量
        CGFloat offset  = button.center.x - self.center.x;
        // 最小偏移量
        CGFloat minOffset = 0;
        // 最大偏移量
        CGFloat maxOffset = self.contentSize.width - self.bounds.size.width;
        if (offset < minOffset) offset = minOffset; // 偏移量小于最小允许值，则移至最小处
        if (offset > maxOffset) offset = maxOffset; // 偏移量大于最大允许值，则移至最大处
        [self setContentOffset:CGPointMake(offset, 0) animated:YES];
    }
    
    // 5.设置底部条滚动
    if (self.showButtomView) { // 显示底部滑动条
        CGFloat buttomViewX = self.selectedBtn.frame.origin.x;
        CGFloat buttomViewY = self.frame.size.height - self.buttomViewHeight;
        CGFloat buttomViewW = self.selectedBtn.frame.size.width;
        CGFloat buttomViewH = self.buttomViewHeight;
        if (CGRectEqualToRect(self.buttomView.frame, CGRectZero)) { // 第一次无动画,因为跟新布局时候默认点击了选中按钮
            self.buttomView.frame = CGRectMake(buttomViewX, buttomViewY, buttomViewW, buttomViewH);
            if (!buttomViewW) self.buttomView.frame = CGRectZero; // 防止跟新布局时候默认点击了选中按钮
        }else {
            [UIView animateWithDuration:0.25 animations:^{
                self.buttomView.frame = CGRectMake(buttomViewX, buttomViewY, buttomViewW, buttomViewH);
            }];
        }
        [self.buttomView setBackgroundColor:item.titleSelectedColor];
        [self bringSubviewToFront:self.buttomView];
    }
    
    // 5.调用block
    if (from == button.tag) return; // 避免多次调用block，因为布局时默认要调用此方法
    self.block(from, button.tag);
    
}
@end

#pragma mark - WYSlideViewItem

@implementation WYSlideViewItem

@end

#pragma mark - ToolFunction

// 获取字符尺寸
static CGRect getStringSize(NSString *str)
{
    CGSize textMaxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT);
    NSDictionary *textFontDict = @{NSFontAttributeName:DEFAUL_TITLEFONT};
    CGRect textContentRect = [str boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textFontDict context:nil];
    return textContentRect;
}

// 获取数组最大值
static CGFloat getArrayMaxObject(NSArray<NSNumber *> *array)
{
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 doubleValue] > [obj2 doubleValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 doubleValue] < [obj2 doubleValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    NSArray *sortedArray = [array sortedArrayUsingComparator:cmptr];
    NSNumber *number = [sortedArray lastObject];
    return number.floatValue;

}



