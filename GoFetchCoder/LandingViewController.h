//
//  LandingViewController.h
//  GoFetchCoder
//
//  Created by Guest on 1/18/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface LandingViewController : BaseViewController

@property(nonatomic,weak)IBOutlet UITextView *txtView;
@property(nonatomic,weak)IBOutlet UIButton *btnSearch;

- (IBAction)searchAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnClear;

@property (weak, nonatomic) IBOutlet UIButton *btnMyAccount;
@property (weak, nonatomic) IBOutlet UIButton *btnLocation;


- (IBAction)btnLocationAction:(id)sender;

@end
