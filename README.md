# WYSlideView
一个轻量级的滑动选项条

### 使用
*注意：如果添加在navigationViewController的view上请设置automaticallyAdjustsScrollViewInsets = NO 因为控制器会对scrollView添加内边距*
* 根据字符串数组

        // 初始化slideView，记得需要设置frame
        // @param fromIndex 上次点击的索引
        // @param toIndex   即将点击的索引
        // @return slideView对象
        WYSlideView *slideView = [WYSlideView slideViewWithTitleArray:@[@"标题1", @"标题2"] itemClickBlock:^(NSInteger fromIndex, NSInteger toIndex) {
            // 获取点击的索引，完成转场
        }];
* 根据模型

        // 创建模型
        WYSlideViewItem *item1 = [[WYSlideViewItem alloc] init];
        item1.title = @"标题1";
        WYSlideViewItem *item2 = [[WYSlideViewItem alloc] init];
        item2.title = @"标题2";
        // 根据模型创建slideView
        WYSlideView *slideView2 = [WYSlideView slideViewWithItemArray:@[item1, item2] itemClickBlock:^(NSInteger fromIndex, NSInteger toIndex) {
            // 获取点击的索引，完成转场
        }];

### 其他属性
设置就是了，都在头文件里...

