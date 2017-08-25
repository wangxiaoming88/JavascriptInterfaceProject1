//
//  NGNavigationBarMenu.h
//  GoFetchCoder
//
//  Created by Nitin gupta on 11/01/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "UIView+NG.h"

@interface UITouchGestureRecognizer : UIGestureRecognizer
@end

@interface NGNavbarMenuItem : NSObject

@property (copy, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) UIImage *icon;

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon;
+ (NGNavbarMenuItem *)ItemWithTitle:(NSString *)title icon:(UIImage *)icon;

@end

@class NGNavigationBarMenu;
@protocol NGNavbarMenuDelegate <NSObject>

- (void)didShowMenu:(NGNavigationBarMenu *)menu;
- (void)didDismissMenu:(NGNavigationBarMenu *)menu;
- (void)didSelectedMenu:(NGNavigationBarMenu *)menu atIndex:(NSInteger)index;

@end

@interface NGNavigationBarMenu : UIView
@property (copy, nonatomic, readonly) NSArray *items;
@property (assign, nonatomic, readonly) NSInteger maximumNumberInRow;
@property (assign, nonatomic, getter=isOpen) BOOL open;
@property (weak, nonatomic) id <NGNavbarMenuDelegate> delegate;

@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIColor *separatarColor;

- (instancetype)initWithItems:(NSArray *)items
                        width:(CGFloat)width
           maximumNumberInRow:(NSInteger)max;

- (void)showInNavigationController:(UINavigationController *)nvc;
- (void)dismissWithAnimation:(BOOL)animation;

//GLOBAL NAVIGATION
- (void)showGlobalNavigationWithAnimation:(UINavigationController *)nvc;
- (void)dismissGlobalNavigationWithAnimation:(BOOL)animation;

@end
