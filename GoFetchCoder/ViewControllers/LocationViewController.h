//
//  LocationViewController.h
//  GoFetchCoder
//
//  Created by Sandro Albert on 3/19/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LocationViewController : BaseViewController

@property (nonatomic, retain) NSMutableArray *displayArray;
- (void)expandCollapseNode:(NSNotification *)notification;

- (void)fillDisplayArray;
- (void)fillNodeWithChildrenArray:(NSArray *)childrenArray;

- (void)fillNodesArray;
- (NSArray *)fillChildrenForNode;


@end
