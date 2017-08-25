//
//  UIView+NG.m
//  GoFetchCoder
//
//  Created by Nitin gupta on 11/01/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "UIView+NG.h"

@implementation UIView (NG)

- (void)setNG_x:(CGFloat)NG_x {
    CGRect frame = self.frame;
    frame.origin.x = NG_x;
    self.frame = frame;
}

- (CGFloat)NG_x {
    return self.frame.origin.x;
}

- (void)setNG_y:(CGFloat)NG_y {
    CGRect frame = self.frame;
    frame.origin.y = NG_y;
    self.frame = frame;
}

- (CGFloat)NG_y {
    return self.frame.origin.y;
}

- (void)setNG_width:(CGFloat)NG_width {
    CGRect frame = self.frame;
    frame.size.width = NG_width;
    self.frame = frame;
}

- (CGFloat)NG_width {
    return self.frame.size.width;
}

- (void)setNG_height:(CGFloat)NG_height {
    CGRect frame = self.frame;
    frame.size.height = NG_height;
    self.frame = frame;
}

- (CGFloat)NG_height {
    return self.frame.size.height;
}

- (void)setNG_size:(CGSize)NG_size {
    CGRect frame = self.frame;
    frame.size = NG_size;
    self.frame = frame;
}

- (CGSize)NG_size {
    return self.frame.size;
}

- (void)setNG_origin:(CGPoint)NG_origin {
    CGRect frame = self.frame;
    frame.origin = NG_origin;
    self.frame = frame;
}

- (CGPoint)NG_origin {
    return self.frame.origin;
}

@end
