//
//  GlobalNavigationVC.h
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 3/5/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GlobalNavigationDelegate <NSObject>

//- (void)didShowGlobalNav;

- (void)didHideGlobalNav;
- (void)didSelectItem:(NSString *)item AtIndex:(NSInteger)index;


@end
@interface GlobalNavigationVC : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (nonatomic,assign) BOOL isOpen;

@property (strong, nonatomic) IBOutlet UIView *leftView;

@property (assign, nonatomic) NSInteger currentSelectionIndex;

@property(nonatomic,weak)id <GlobalNavigationDelegate> delegate;
@end
