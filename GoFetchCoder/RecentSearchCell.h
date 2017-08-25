//
//  RecentSearchCell.h
//  GoFetchCoder
//
//  Created by Sandro Albert on 3/20/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentSearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblQuestion;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;

@end
