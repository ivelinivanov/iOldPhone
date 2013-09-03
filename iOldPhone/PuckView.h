//
//  PuckView.h
//  iOldPhone
//
//  Created by Ivelin Ivanov on 8/26/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ring.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>

@protocol PuckViewDelegate <NSObject>

-(void)didEnterNumber:(int)tag;

@end

@interface PuckView : UIView

@property (weak, nonatomic) id <PuckViewDelegate> delegate;

@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) NSInteger cellCount;


@end
