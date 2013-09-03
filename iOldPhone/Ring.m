//
//  Ring.m
//  iOldPhone
//
//  Created by Ivelin Ivanov on 8/16/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "Ring.h"

@implementation Ring

- (id)init
{
    self = [super init];
    if (self)
    {
        self.layer.cornerRadius = 27;
        self.layer.borderWidth = 2.0;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end
