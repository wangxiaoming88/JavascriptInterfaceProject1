//
//  AppDelegate.h
//  GoFetchCoder
//
//  Created by Nitin gupta on 11/01/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "LandingViewController.h"
#import "LoginViewController.h"
#import "RecentSearchQuestionsVC.h"
#import "BookmarkVC.h"
#import "CBCViewController.h"
#import "BrowseCodesVC.h"
#import "HelpVC.h"
#import "SectionsViewController.h"
#import "MyAccountVC.h"
#import "RegistrationVC.h"
#import "ChapterViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navController;

@property (nonatomic,strong) NSOperationQueue *queue;

@property (nonatomic,strong) LandingViewController   *landingVC;

@property (nonatomic,strong) LoginViewController     *loginVC;

@property (nonatomic,strong) RegistrationVC     *registrationVC;

@property (nonatomic,strong) SectionsViewController     *sectionsVC;

@property (nonatomic,strong) ChapterViewController    *chapterVC;

@property (nonatomic,strong) RecentSearchQuestionsVC *recentSearchQuestionsVC;

@property (nonatomic,strong) BookmarkVC              *bookmarkVC;

@property (nonatomic,strong) CBCViewController       *cbcVC;

@property (nonatomic,strong) BrowseCodesVC           *browseCodesVC;

@property (nonatomic,strong) HelpVC                  *helpVC;

@property (nonatomic,strong) MyAccountVC                  *myAccount;


@property (nonatomic,readwrite) KeychainItemWrapper *keychain;

@property (nonatomic,readwrite) Boolean jumpneed;
@property (nonatomic,strong) UIViewController       *jumbVC;





@end

