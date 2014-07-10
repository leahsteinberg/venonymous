//
//  VenonMakePayment.h
//  venon
//
//  Created by Leah Steinberg on 7/1/14.
//  Copyright (c) 2014 LeahSteinberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VenonMakePayment : NSObject
@property (strong, nonatomic) NSString *targetID;
@property (strong, nonatomic) NSString *targetDisplayName;
@property (strong, nonatomic) NSNumber *amount;
@property (strong, nonatomic) NSString *onlyTheNote;
@property (strong, nonatomic) NSString *noteWithInfo;
- (void)beginPayment:(NSString *)targetID withAmount:(NSNumber *)amount;

@end
