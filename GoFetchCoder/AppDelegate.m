//
//  AppDelegate.m
//  GoFetchCoder
//
//  Created by Nitin gupta on 11/01/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import <Mixpanel/Mixpanel.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    //register token of mixpanel
    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    
    // Keychain ...
    self.keychain = [[KeychainItemWrapper alloc] initWithIdentifier:kGFCKeychainIdentifier accessGroup:nil];

    
    
    //_window = [[UIWindow alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    [NSThread sleepForTimeInterval:4];
    
    _queue = [[NSOperationQueue alloc] init];

    _sectionsVC = [[SectionsViewController alloc] initWithNibName:NSStringFromClass([SectionsViewController class]) bundle:nil];
    
    _landingVC               = [[LandingViewController alloc] initWithNibName:NSStringFromClass([LandingViewController class]) bundle:nil];

    _recentSearchQuestionsVC = [[RecentSearchQuestionsVC alloc] initWithNibName:NSStringFromClass([RecentSearchQuestionsVC class]) bundle:nil];

    _bookmarkVC              = [[BookmarkVC alloc] initWithNibName:NSStringFromClass([BookmarkVC class]) bundle:nil];

    _loginVC                 = [[LoginViewController alloc] initWithNibName:NSStringFromClass([LoginViewController class]) bundle:nil];
    
    _registrationVC          = [[RegistrationVC alloc] initWithNibName:NSStringFromClass([RegistrationVC class]) bundle:nil];

    _cbcVC                   = [[CBCViewController alloc] initWithNibName:NSStringFromClass([CBCViewController class]) bundle:nil];

    _browseCodesVC           = [[BrowseCodesVC alloc] initWithNibName:NSStringFromClass([BrowseCodesVC class]) bundle:nil];
    
    _helpVC                  = [[HelpVC alloc] initWithNibName:NSStringFromClass([HelpVC class]) bundle:nil];

    _myAccount                  = [[MyAccountVC alloc] initWithNibName:NSStringFromClass([MyAccountVC class]) bundle:nil];


    
    self.navController = [[UINavigationController alloc] initWithRootViewController:_loginVC];
    
    self.navController.navigationBarHidden = YES;
    

//    self.jumbVC = [[UIViewController alloc] initWithNibName:NSStringFromClass([UIViewController class]) bundle:nil];

    

    [_window setRootViewController:_navController];

//    [self.window makeKeyAndVisible];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kCurrentSelectedMenuIndex];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kAuthToken];
    
}

@end
