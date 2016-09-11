//
//  PHTopTitleView.h
//  顶部滚动菜单
//
//  Created by 123 on 16/9/10.
//  Copyright © 2016年 彭洪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHTopTitleView;

@protocol PHTopTitleViewDelegate <NSObject>

- (void)topTitleView:(PHTopTitleView *)topTitleView didSelectTitleAtIndex:(NSInteger)index;

@end

@interface PHTopTitleView : UIScrollView
/** 禁止标题数组 */
@property (nonatomic,strong) NSArray *staticTitleArr;
/** 滚动标题数组 */
@property (nonatomic,strong) NSArray *scrollTitleArr;
/** 存入所有Label */
@property (nonatomic,strong) NSMutableArray *allTitleLabel;
@property (nonatomic,weak) id<PHTopTitleViewDelegate>delegate;

/** 类方法 */
+ (instancetype)topTitleViewWithFrame:(CGRect)frame;

#pragma mark 给外界ScrollView提供的方法以及自身方法实现
/** 禁止标题选中颜色改变以及指示器位置变化 */
- (void)staticTitleLabelSelected:(UILabel *)label;
/** 滚动标题选中颜色以及指示器位置变化 */
- (void)scrollTitleLabelSelected:(UILabel *)label;
/** 滚动标题选中居中 */
- (void)scrollTitleLabelSelectedCenter:(UILabel *)centerLabel;

#pragma mark 给外界ScrollView提供的方法
/** 滚动ScrollView 让文字呈现渐变效果 */
- (void)scrollTitleLabelSelectedChangeTextColorFadeScrollView:(UIScrollView *)scrollView;
@end











































