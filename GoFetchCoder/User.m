//
//  User.m
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 3/4/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "User.h"

@implementation User

static NSString *kFirstName      = @"firstName";
static NSString *kLastName       = @"lastName";
static NSString *kIdentifier     = @"identifier";
static NSString *kEmail          = @"email";
static NSString *kEnrollmentType = @"enrollmentType";
static NSString *kStatus         = @"status";


- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy) {
        // Copy NSObject subclasses
        [copy setFirstName:[self.firstName copyWithZone:zone]];
        [copy setLastName:[self.lastName copyWithZone:zone]];
        [copy setEmail:[self.email copyWithZone:zone]];
        [copy setStatus:[self.status copyWithZone:zone]];
        [copy setIdentifier:self.identifier];
        [copy setEnrollmentType:self.enrollmentType];
        
    }
    
    return copy;
}
 
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.firstName      = [aDecoder decodeObjectForKey:kFirstName];
        self.lastName       = [aDecoder decodeObjectForKey:kLastName];
        self.email          = [aDecoder decodeObjectForKey:kEmail];
        self.status          = [aDecoder decodeObjectForKey:kStatus];
        self.identifier     = [aDecoder decodeIntForKey:kIdentifier];
        self.enrollmentType = [aDecoder decodeIntForKey:kEnrollmentType];
    }
    
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.firstName                 forKey:kFirstName];
    [aCoder encodeObject:self.lastName                  forKey:kLastName];
    [aCoder encodeObject:self.email                     forKey:kEmail];
    [aCoder encodeObject:self.status                     forKey:kStatus];
    [aCoder encodeInteger:self.identifier               forKey:kIdentifier];
    [aCoder encodeInteger:self.enrollmentType           forKey:kEnrollmentType];
    
}


-(void)setUserModel:(NSDictionary *)dictionary{

    if (dictionary[@"status"]) {
        if (dictionary[@"people"]) {
            dictionary = dictionary[@"people"];
            _firstName = dictionary[@"firstName"];
            _lastName  = dictionary[@"lastName"];
            _email     = dictionary[@"email"];
            _status     = dictionary[@"status"];
            _identifier     =[dictionary[@"id"] integerValue];
            
            NSString *type = dictionary[@"type"];
            
            if ([type caseInsensitiveCompare:@"Individual"] == NSOrderedSame) {
                _enrollmentType = Individual;
            }
            else if ([type caseInsensitiveCompare:@"Team"] == NSOrderedSame) {
                _enrollmentType = Team;
            }
            else if ([type caseInsensitiveCompare:@"Organisation"] == NSOrderedSame) {
                _enrollmentType = Organisation;
            }
            else {
                _enrollmentType = None;
            }            
        }
    }
    
    
    
}

@end
