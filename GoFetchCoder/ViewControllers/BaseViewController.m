//
//  BaseViewController.m
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 1/23/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "UIColor+GFCAdditions.h"


#import "SectionsViewController.h"
#import "RecentSearchQuestionsVC.h"
#import "RecentSearchAnswersVC.h"
#import "BookmarkVC.h"
#import "MyAccountVC.h"
#import "ChapterViewController.h"
#import "CBCViewController.h"
#import "EditMyAccountVC.h"
#import "RecentSectionViewController.h"
#import "LoginAuthenticationOperation.h"
#import "KeychainItemWrapper.h"
#import "BookmarkSectionViewController.h"
#import "LocationViewController.h"


#import "RNCryptor.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"

#import "EncryptionManager.h"

#import "GlobalNavigationVC.h"

#define SLIDE_TIMING 0.35

@interface BaseViewController ()<GlobalNavigationDelegate>{
}
@property (strong, nonatomic) NGNavigationBarMenu *menu;
@property (strong, nonatomic) GlobalNavigationVC *globalNavigation;
@property (assign, nonatomic) NSInteger currentSelectionIndex;

@end

@implementation BaseViewController

#pragma mark - Global Navigation Delegate -


- (void)didHideGlobalNav
{
    [self hideGlobalNavigationView];

}
- (void)didSelectItem:(NSString *)item AtIndex:(NSInteger)index
{
    
    AppDelegate *appdelegate = kAppDelegate;
    
    UIViewController *vc;
    if ([item isEqualToString:kRecentQuestions]) {
        vc = appdelegate.recentSearchQuestionsVC;
        
    }
    else if ([item isEqualToString:kBookmarks]) {
        vc = appdelegate.bookmarkVC;
        
    }
    else if ([item isEqualToString:kSearch]) {
        vc = appdelegate.landingVC;
        
    }
    else if ([item isEqualToString:kCBC]) {
        vc = appdelegate.browseCodesVC;
    }
    else if ([item isEqualToString:kMessages]) {
        
    }
    else if ([item isEqualToString:kHelp]) {
        vc = appdelegate.helpVC;
        
    }
    else if ([item isEqualToString:kMyAccount]) {
        vc = appdelegate.myAccount;//[[MyAccountVC alloc] initWithNibName:NSStringFromClass([MyAccountVC class]) bundle:nil];
    }
    
    if (vc && ![self isKindOfClass:[vc class]]) {
        
        [[NSUserDefaults standardUserDefaults] setInteger:index forKey:kCurrentSelectedMenuIndex];
        
        
        if (![self isKindOfClass:[appdelegate.landingVC class]]) {
            
            if (![vc isKindOfClass:[appdelegate.landingVC class]]) {
                appdelegate.jumpneed = true;
                appdelegate.jumbVC = vc;
            }
        
            [self.navigationController popToRootViewControllerAnimated:NO];

        } else {
           
            [self.navigationController pushViewController:vc animated:YES];
        }

        
    }
    
    
    [self hideGlobalNavigationView];
}


#pragma mark - View Controller Lifecycle -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self setupNavigationController];
    
}

- (void)viewDidLayoutSubviews {
    [self setupMenu];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *appdelegate = kAppDelegate;
    
    
    if (appdelegate.jumpneed) {
        appdelegate.jumpneed = false;
        [self.navigationController pushViewController:appdelegate.jumbVC animated:YES];
    }

    
    [self hideLoadingIndicator];

    if (_menu.isOpen) {
        [_menu dismissWithAnimation:NO];
    }
            
    self.navigationController.navigationBarHidden = NO;
    
    [self performSelector:@selector(setupGlobalNavigation) withObject:nil afterDelay:0.2];
    

}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideLoadingIndicator];

    if (_menu.isOpen) {
        [_menu dismissWithAnimation:NO];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Autologin

-(void)autoLoginWithCallbackBlock:(void (^)(BOOL isAutoLoginSuccessful,id response))callbackBlock
{
    [self showLoadingIndicator];
    
    AppDelegate *appDelegate = kAppDelegate;
   
    NSData *username         = [appDelegate.keychain objectForKey:(__bridge id)kSecAttrAccount];
    NSString *usernameString = [[EncryptionManager sharedInstance] getDecryptedString:username];
    NSData *pass             = [appDelegate.keychain objectForKey:(__bridge id)(kSecValueData)];
    NSString *passwordString = [[EncryptionManager sharedInstance] getDecryptedString:pass];
    
    
    if (!usernameString.length & !passwordString.length) {
        [self hideLoadingIndicator];
        return;
    }

    LoginAuthenticationOperation *operation= [[LoginAuthenticationOperation alloc] init];

    operation.username = usernameString;
    operation.password = passwordString;
    
    operation.onSuccess = ^(NSString *authToken) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSUserDefaults standardUserDefaults] setObject:authToken forKey:kAuthToken];
                [self hideLoadingIndicator];
            callbackBlock(YES,nil);
        });
    };
    
    operation.onFailure = ^(NSDictionary *failureDict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingIndicator];
            callbackBlock(NO,failureDict);
        });
    };
    [appDelegate.queue addOperation:operation];

}



#pragma mark - Navigation
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    _menu = nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)hidePopupMenu{
    _menu = nil;
    _globalNavigation = nil;
}


-(void)setViewControllerTitle:(NSString *)title {
    
    if (!title.length) {
        self.navigationItem.titleView = nil;
        return;
    }
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,40,375,40)];
    headerLabel.text = title;
    headerLabel.numberOfLines = 0;
    headerLabel.textAlignment = NSTextAlignmentLeft;
    headerLabel.textColor = [UIColor defaultColor];
    headerLabel.font = [UIFont fontWithName:@"Lato-Regular" size:17.0];
    headerLabel.adjustsFontSizeToFitWidth = YES;
//    [headerLabel sizeToFit];
    
    self.navigationItem.titleView = headerLabel;
}

-(void)backButtonPressed:(id)sender
{
    NSLog(@"%@",self.navigationController.viewControllers);
    
//    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        NSLog(@"Before%@",obj);
//        
//    }];

    
//__block UIViewController *vc = [self.navigationController popViewControllerAnimated:YES];
    
    
    NSLog(@"%@",self.navigationController.viewControllers);
    __block NSUInteger index = 0;
    
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (self == obj) {
            index = idx - 1;
            *stop = YES;
        }
        
    }];
    


    __block UIViewController *vc = self.navigationController.viewControllers[index];
    
    if ([vc isKindOfClass:[SectionsViewController class]]) {
        index = 0;
    }
    else if ([vc isKindOfClass:[RecentSearchQuestionsVC class]]) {
        index = 1;
    }
    else if ([vc isKindOfClass:[BookmarkVC class]]) {
        index = 2;
    }

    else if ([vc isKindOfClass:[BrowseCodesVC class]]) {
        index = 3;
    }
    else if ([vc isKindOfClass:[MyAccountVC class]]) {
        index = 5;
    }
    else if ([vc isKindOfClass:[HelpVC class]]) {
        index = 6;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:kCurrentSelectedMenuIndex];
}

- (void)setupNavigationController {
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"i_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"i_hamburger_active"] style:UIBarButtonItemStylePlain target:self action:@selector(openMenu:)];

    
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:46/255.0 green:204/255.0 blue:121/255.0 alpha:1.0];
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:46/255.0 green:204/255.0 blue:121/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:46/255.0 green:204/255.0 blue:121/255.0 alpha:1.0];

    NSString *title = @"";
    
    if ([self isKindOfClass:[SectionsViewController class]]) {
        title = kSearch;
    }
    else if ([self isKindOfClass:[RecentSearchQuestionsVC class]]) {
        title = kRecentQuestions;
    }
    else if ([self isKindOfClass:[LandingViewController class]]) {
        title = kSearch;
    }
    else if ([self isKindOfClass:[RecentSearchAnswersVC class]]) {
        title = kRecentAnswers;
    }
    else if ([self isKindOfClass:[BookmarkVC class]]) {
        title = kBookmarks;
    }
    else if ([self isKindOfClass:[ChapterViewController class]]) {
        title = @"CHAPTER";
    }
    else if ([self isKindOfClass:[BrowseCodesVC class]]) {
        title = kCBC;
    }
    else if ([self isKindOfClass:[MyAccountVC class]]) {
        title = kMyAccount;
    }
    
    else if ([self isKindOfClass:[EditMyAccountVC class]]) {
        title = kEditMyAccount;
    }
    
    else if ([self isKindOfClass:[HelpVC class]]) {
        title = kHelp;
    }
    
    else if ([self isKindOfClass:[RecentSectionViewController class]]) {
        title = KRecentSection;
    }
    else if ([self isKindOfClass:[BookmarkSectionViewController class]]) {
        title = kBookmarks;
    }
    else if ([self isKindOfClass:[LocationViewController class]]) {
        title = kLocation;
    }
    
    [self setViewControllerTitle:title];
  
    
}

#pragma mark - GlobalNavigation Related

- (void)setupGlobalNavigation
{
    if (_menu) {
    
        if (!self.globalNavigation) {
            
            self.globalNavigation = [[GlobalNavigationVC alloc] initWithNibName:NSStringFromClass([GlobalNavigationVC class]) bundle:nil];
            self.globalNavigation.delegate = self;
            self.globalNavigation.isOpen = NO;
//            self.globalNavigation.currentSelectionIndex = [[NSUserDefaults standardUserDefaults] integerForKey:kCurrentSelectedMenuIndex];
            self.globalNavigation.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            
        }
    }
}


#pragma mark - Menu Related
- (void)setupMenu {
    if (_menu == nil) {
     
        NGNavbarMenuItem *item1 = [NGNavbarMenuItem ItemWithTitle:kRecentQuestions icon:nil];
        NGNavbarMenuItem *item2 = [NGNavbarMenuItem ItemWithTitle:kBookmarks icon:nil];
        NGNavbarMenuItem *item3 = [NGNavbarMenuItem ItemWithTitle:kCBC icon:nil];
//        NGNavbarMenuItem *item4 = [NGNavbarMenuItem ItemWithTitle:kMessages icon:[UIImage imageNamed:@""]];
        NGNavbarMenuItem *item5 = [NGNavbarMenuItem ItemWithTitle:kMyAccount icon:[UIImage imageNamed:@""]];
        NGNavbarMenuItem *item6 = [NGNavbarMenuItem ItemWithTitle:kHelp icon:[UIImage imageNamed:@""]];
        
        
        _menu = [[NGNavigationBarMenu alloc] initWithItems:@[item1,item2,item3,item5,item6] width:self.view.NG_width maximumNumberInRow:1];
        _menu.backgroundColor = [UIColor colorWithRed:46/255.0 green:204/255.0 blue:121/255.0 alpha:1.0];
        _menu.separatarColor = [UIColor whiteColor];
        _menu.delegate = self;
    }
}
- (void)openMenu:(id)sender {
    
    if (_menu == nil) {
        return;
    }
    
    
    if (_globalNavigation.isOpen) {
        [self hideGlobalNavigationView];
    } else {
        [self showGlobalNavigationView];
    }
    
    
//    if (_menu.isOpen) {
//        [_menu dismissWithAnimation:YES];
//    } else {
//        [_menu showInNavigationController:self.navigationController];
//    }
}

-(void)hideGlobalNavigationView
{
    
    if(!_globalNavigation.isOpen){
        return;
    }

    self.view.userInteractionEnabled = NO;
    [self.view setAlpha:0.5];

    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        /*CGRect frame = _globalNavigation.table.frame;
         frame = CGRectMake(frame.origin.x - frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
         _globalNavigation.table.frame = frame;*/
        
        CGRect frame = _globalNavigation.leftView.frame;
         frame = CGRectMake(frame.origin.x - frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
         _globalNavigation.leftView.frame = frame;
        
        
        [self.view setAlpha:1.0];

        
        
    }completion:^(BOOL finished) {
        if (finished) {
            _globalNavigation.isOpen = NO;

            [_globalNavigation.view removeFromSuperview];
            self.view.userInteractionEnabled = YES;
            if ([self.globalNavigation.table indexPathForSelectedRow]) {
                [self.globalNavigation.table deselectRowAtIndexPath:[self.globalNavigation.table indexPathForSelectedRow] animated:YES];
            }
        }
        
    }];
    
    
    
}
-(void)showGlobalNavigationView
{
    if(_globalNavigation.isOpen){
        return;
    }
    
    [self.view setAlpha:1.0];
    self.view.userInteractionEnabled = NO;
    
    AppDelegate *appDelegate = kAppDelegate;
    _globalNavigation.view.alpha = 0.0;
    
    [appDelegate.window addSubview:_globalNavigation.view];
    
    //calculate table frame
//    CGRect frame = _globalNavigation.table.frame;
//    frame = CGRectMake(frame.origin.x - frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
//    _globalNavigation.table.frame = frame;
    
    //calculate leftview frame
    CGRect frame = _globalNavigation.leftView.frame;
    frame = CGRectMake(frame.origin.x - frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
    _globalNavigation.leftView.frame = frame;
    
    _globalNavigation.view.alpha = 1.0;
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            
//        CGRect frame = _globalNavigation.table.frame;
//        frame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height);
//        _globalNavigation.table.frame = frame;
        
        CGRect frame = _globalNavigation.leftView.frame;
        frame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height);
        _globalNavigation.leftView.frame = frame;
        
        [self.view setAlpha:0.5];
            
        }completion:^(BOOL finished) {
            if (finished) {
                _globalNavigation.isOpen = YES;
                self.view.userInteractionEnabled = YES;

            }
        }];
}

-(void)pushViewControllerFromMenu:(UIViewController *)controller animated:(BOOL)animated {
    
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // code to be executed on main thread.If you want to run in another thread, create other queue

        NSLog(@"%@",self.navigationController.viewControllers);
        
        if ([self.navigationController.viewControllers containsObject:controller]) {
            [self.navigationController popToViewController:controller animated:animated];
        }
        else{
            [self.navigationController pushViewController:controller animated:animated];

        }
        
    });
}


-(void)showLoadingIndicator
{
    self.view.userInteractionEnabled = NO;
    self.actView.hidden = NO;
    [self.actView startAnimating];
}

-(void)hideLoadingIndicator
{
    self.view.userInteractionEnabled = YES;
    self.actView.hidden = YES;
    [self.actView stopAnimating];
}


-(void)showErrorAlertWithTitle:(NSString *)title andDesription:(NSString *)description
{
    [self hideLoadingIndicator];
    
    if (![NSThread isMainThread]) {
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:description
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction:action];
    
    if (self) {
    [self presentViewController:alert animated:YES completion:NULL];
    }
}


#pragma mark - NGNavigationBar menu delegates

#pragma mark - NGNavbarMenu Delegate
- (void)didShowMenu:(NGNavigationBarMenu *)menu {
    
}

- (void)didDismissMenu:(NGNavigationBarMenu *)menu {
    
}


- (void)didSelectedMenu:(NGNavigationBarMenu *)menu atIndex:(NSInteger)index {
    
   
    
    NGNavbarMenuItem *item = menu.items[index];
    AppDelegate *appdelegate = kAppDelegate;
    
    UIViewController *vc;
    if ([item.title isEqualToString:kRecentQuestions]) {
        vc = appdelegate.recentSearchQuestionsVC;
        
    }
    else if ([item.title isEqualToString:kBookmarks]) {
        vc = appdelegate.bookmarkVC;
        
    }
    
    else if ([item.title isEqualToString:kSearch]) {
        vc = appdelegate.landingVC;
        
    }
    
    else if ([item.title isEqualToString:kCBC]) {
        vc = appdelegate.browseCodesVC;
    }
    else if ([item.title isEqualToString:kMessages]) {
        
    }
    else if ([item.title isEqualToString:kHelp]) {
        vc = appdelegate.helpVC;

    }
    else if ([item.title isEqualToString:kMyAccount]) {
        vc = appdelegate.myAccount;//[[MyAccountVC alloc] initWithNibName:NSStringFromClass([MyAccountVC class]) bundle:nil];
    }
    
    if (vc && ![self isKindOfClass:[vc class]]) {
        
       
        [self pushViewControllerFromMenu:vc animated:YES];
    }

    
}


@end
