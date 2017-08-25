//
//  SectionsViewController.h
//  GoFetchCoder
//
//  Created by Guest on 1/19/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface SectionsViewController : BaseViewController

@property (nonatomic, strong)NSDictionary *responseDict;
@property (nonatomic, copy)NSArray *answersArray;
@property (nonatomic, strong)NSString *searchQuestion;


@end
