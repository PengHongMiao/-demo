//
//  UIView+PHExtension.m
//  顶部滚动菜单
//
//  Created by 123 on 16/9/10.
//  Copyright © 2016年 彭洪. All rights reserved.
//

#import "UIView+PHExtension.h"

@implementation UIView (PHExtension)

#pragma mark 设置器方法
- (void)setPH_x:(CGFloat)PH_x {
    CGRect frame = self.frame;
    frame.origin.x +=PH_x;
    self.frame = frame;
}

- (void)setPH_y:(CGFloat)PH_y {
    CGRect frame = self.frame;
    frame.origin.y += PH_y;
    self.frame = frame;
}

- (void)setPH_width:(CGFloat)PH_width {
    CGRect frame = self.frame;
    frame.size.width += PH_width;
    self.frame = frame;
}

- (void)setPH_height:(CGFloat)PH_height {
    CGRect frame = self.frame;
    frame.size.height += PH_height;
    self.frame = frame;
}

- (void)setPH_centerX:(CGFloat)PH_centerX {
    CGPoint center = self.center;
    center.x += PH_centerX;
    self.center = center;
}

- (void)setPH_centerY:(CGFloat)PH_centerY {
    CGPoint center = self.center;
    center.y += PH_centerY;
    self.center = center;
}

- (void)setPH_size:(CGSize)PH_size {
    CGRect frame = self.frame;
    frame.size = PH_size;
    self.frame = frame;
}

#pragma mark 获取器方法
- (CGFloat)PH_x {
    return self.frame.origin.x;
}

- (CGFloat)PH_y {
    return self.frame.origin.y;
}

- (CGFloat)PH_width {
    return self.frame.size.width;
}

- (CGFloat)PH_height {
    return self.frame.size.height;
}

- (CGFloat)PH_centerX {
    return self.center.x;
}

- (CGFloat)PH_centerY {
    return self.center.y;
}

- (CGSize)PH_size {
    return self.frame.size;
}

+ (instancetype)PH_ViewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}



@end























