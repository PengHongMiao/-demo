//
//  PHTopTitleView.m
//  顶部滚动菜单
//
//  Created by 123 on 16/9/10.
//  Copyright © 2016年 彭洪. All rights reserved.
//

#import "PHTopTitleView.h"
#import "UIView+PHExtension.h"

#define labelFontOfSize    [UIFont systemFontOfSize:17]
#define SCREEN_Width    [UIScreen mainScreen].bounds.size.width
#define selectedTitleIndicatorViewColor    [UIColor redColor]

@interface PHTopTitleView ()
/** 静止标题 */
@property (nonatomic,strong) UILabel *staticTitleLabel;
/** 滚动标题 */
@property (nonatomic,strong) UILabel *scrollTitleLabel;
/** 选中标题时Label */
@property (nonatomic,strong) UILabel *selectedTitleLabel;
/** 指示器 */
@property (nonatomic,strong) UIView *indicatorView;
@end

@implementation PHTopTitleView
/** label之间的间距 */
static CGFloat const labelMargin = 15;
/** 指示器的高度 */
static CGFloat const indicatorHeight = 3;

- (NSMutableArray *)allTitleLabel {
    if (_allTitleLabel == nil) {
        _allTitleLabel = [[NSMutableArray alloc] init];
    }
    return _allTitleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = NO;//弹性设置
    }
    return self;
}

+ (instancetype)topTitleViewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体大小
 *  @param maxSize 文字的最大尺寸
 *
 *  @return label的大小
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attributes = @{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
}

#pragma mark 重写禁止标题数组的setter方法
- (void)setStaticTitleArr:(NSArray *)staticTitleArr {
    _staticTitleArr = staticTitleArr;
    
    //计算ScrollView的宽度
    CGFloat scrollViewWidth = self.frame.size.width;
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    CGFloat labelW = scrollViewWidth / self.staticTitleArr.count;
    CGFloat labelH = self.frame.size.height - indicatorHeight;
    
    for (NSInteger j=0; j<self.staticTitleArr.count; j++) {
        //创建静止标题时label
        self.staticTitleLabel = [[UILabel alloc] init];
        _staticTitleLabel.userInteractionEnabled = YES;
        _staticTitleLabel.text = self.staticTitleArr[j];
        _staticTitleLabel.textAlignment = NSTextAlignmentCenter;
        _staticTitleLabel.tag = j;
        
        //设置高亮文字颜色
        _staticTitleLabel.highlightedTextColor = selectedTitleIndicatorViewColor;
        //计算staticTitleLabel的x值
        labelX = j*labelW;
        _staticTitleLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
        //添加到titlesLabels数组
        [self.allTitleLabel addObject:_staticTitleLabel];
        //添加点按手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(staticTitleClick:)];
        [_staticTitleLabel addGestureRecognizer:tap];
        //默认选中0个label
        if (j == 0) {
            [self staticTitleClick:tap];
        }
        [self addSubview:_staticTitleLabel];
    }
    //取出第一个子空间
    UILabel *firstLabel = self.subviews.firstObject;
    //添加指示器
    self.indicatorView = [[UIView alloc] init];
    _indicatorView.backgroundColor = selectedTitleIndicatorViewColor;
    _indicatorView.PH_height = indicatorHeight;
    _indicatorView.PH_y = self.frame.size.height - indicatorHeight;
    [self addSubview:_indicatorView];
    //指示器默认在第一个选中位置
    CGSize labelSize = [self sizeWithText:firstLabel.text font:labelFontOfSize maxSize:CGSizeMake(MAXFLOAT, labelH)];
    _indicatorView.PH_width = labelSize.width;
    _indicatorView.PH_centerX = firstLabel.PH_centerX;
}

/** scrollTitleClick的点击事件 */
- (void)scrollTitleClick:(UITapGestureRecognizer *)tap {
    //0.获取选中的label
    UILabel *selLabel = (UILabel *)tap.view;
    //1.标题颜色变成红色 设置高亮状态下的颜色 以及指示器的位置
    [self scrollTitleLabelSelected:selLabel];
    //让选中的标题居中
    [self scrollTitleLabelSelectedCenter:selLabel];
    //代理方法实现
    NSInteger index = selLabel.tag;
    if ([self.delegate respondsToSelector:@selector(topTitleView:didSelectTitleAtIndex:)]) {
        [self.delegate topTitleView:self didSelectTitleAtIndex:index];
    }
}

/** 滚动标题选中颜色改变以及指示器位置变化 */
- (void)scrollTitleLabelSelected:(UILabel *)label {
    //取消高亮
    _selectedTitleLabel.highlighted = NO;
    //颜色回复
    _selectedTitleLabel.textColor = [UIColor blackColor];
    //高亮
    label.highlighted = YES;
    _selectedTitleLabel = label;
    //改变指示器位置
    [UIView animateWithDuration:0.20 animations:^{
        self.indicatorView.PH_width = label.PH_width - 2*labelMargin;
        self.indicatorView.PH_centerX = label.PH_centerX;
    }];
}

/** 滚动标题选中居中 */
- (void)scrollTitleLabelSelectedCenter:(UILabel *)centerLabel {
    //计算偏移量
    CGFloat offsetX = centerLabel.center.x - SCREEN_Width * 0.5;
    if (offsetX < 0) {
        offsetX = 0;
    }
    //获取最大滚动范围
    CGFloat maxOffsetX = self.contentSize.width - SCREEN_Width;
    if (offsetX>maxOffsetX) {
        offsetX = maxOffsetX;
    }
    //滚动标题滚动条
    [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

#pragma mark 给外界ScrollView提供的方法
- (void)scrollTitleLabelSelectedChangeTextColorFadeScrollView:(UIScrollView *)scrollView {
    //当前label的位置
    CGFloat currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    NSInteger leftIndex = currentPage;
    NSInteger rightIndex = leftIndex + 1;
    //获取左边label
    UILabel *leftLabel = self.allTitleLabel[leftIndex];
    //获取右边label
    UILabel *rightLabel;
    if (rightIndex < self.allTitleLabel.count - 1) {
        rightLabel = self.allTitleLabel[rightIndex];
    }
    //计算下右边缩放比例
    CGFloat rightScale = currentPage - leftIndex;
    //计算下左边缩放比例
    CGFloat leftScale = 1 - rightScale;
    //设置文字颜色渐变
    leftLabel.textColor = [UIColor colorWithRed:leftScale green:0 blue:0 alpha:1];
    rightLabel.textColor = [UIColor colorWithRed:rightScale green:0 blue:0 alpha:1];
}

- (void)staticTitleClick:(UITapGestureRecognizer *)tap {
    
}
@end



































