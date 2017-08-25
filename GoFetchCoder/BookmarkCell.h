//
//  BookmarkCell.h
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 2/27/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookmarkCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel *labelSectionId;
@property(nonatomic,weak)IBOutlet UILabel *labelSectionDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@end
