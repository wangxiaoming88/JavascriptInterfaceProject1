//
//  User.h
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 3/4/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface User : NSObject <NSCoding,NSCopying>

@property (nonatomic,assign  ) NSString       *firstName;
@property (nonatomic,assign  ) NSString       *lastName;
@property (nonatomic,assign  ) NSString       *email;
@property (nonatomic,assign  ) NSString       *status;
@property (nonatomic,assign) NSInteger      identifier;
@property (nonatomic,assign) EnrollmentType enrollmentType;

-(void)setUserModel:(NSDictionary *)dictionary;
@end
