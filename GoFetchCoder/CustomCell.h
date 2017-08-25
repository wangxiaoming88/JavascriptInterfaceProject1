//
//  CustomCell.h
//  GoFetchCoder
//
//  Created by Guest on 1/17/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UILabel *labelSectionNumber;
@property(nonatomic,weak)IBOutlet UILabel *labelBestMatch;
@property(nonatomic,weak)IBOutlet UILabel *labelAnswer;

@end
