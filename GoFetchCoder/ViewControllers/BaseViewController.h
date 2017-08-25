//
//  BaseViewController.h
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 1/23/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGNavigationBarMenu.h"
#import "KeychainItemWrapper.h"

@interface BaseViewController : UIViewController <NGNavbarMenuDelegate>

@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *actView;

-(void)showLoadingIndicator;
-(void)hideLoadingIndicator;
-(void)showErrorAlertWithTitle:(NSString *)title andDesription:(NSString *)description;

-(void)pushViewControllerFromMenu:(UIViewController *)controller animated:(BOOL)animated;


-(void)hidePopupMenu;
-(void)setViewControllerTitle:(NSString *)title;


// Autologin:
-(void)autoLoginWithCallbackBlock:(void (^)(BOOL isAutoLoginSuccessful, id response))callbackBlock;
-(void)backButtonPressed:(id)sender;

@end
