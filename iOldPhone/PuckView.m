//
//  PuckView.m
//  iOldPhone
//
//  Created by Ivelin Ivanov on 8/26/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "PuckView.h"

@interface PuckView ()
{
    NSArray *nums;
    
    CGPoint oldLocation;
    CGPoint newLocation;
    
    CGPoint startLocation;
    
    CGFloat anglesTravelled;
    
    Ring *selectedRing;
}
@end

@implementation PuckView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        nums = [NSArray arrayWithObjects:@"0",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2",@"1", nil];
        
        self.cellCount = kCellCount;
        self.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        self.radius = MIN(self.frame.size.width, self.frame.size.height) / 2.5;
        
//        oldLocation = self.center;
//        newLocation = self.center;
        
        anglesTravelled = 0;
        
        [self layoutRings];

    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [self.layer setNeedsDisplay];
}

-(void)layoutRings
{
    int realCounter = 0;
    
    for (int i = 0; i < self.cellCount; i++)
    {
        if (i > 2)
        {
            Ring *ring = [[Ring alloc] init];
            ring.frame = CGRectMake(0, 0, kRingSize, kRingSize);
            ring.center = CGPointMake(self.center.x + self.radius * cosf(2 * i * M_PI / self.cellCount),
                                      self.center.y + self.radius * sinf(2 * i * M_PI / self.cellCount));
            ring.tag = realCounter;
            
            UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
            
            [ring addGestureRecognizer:panRecognizer];
            [ring addGestureRecognizer:tapRecognizer];
            
            
            [self addSubview:ring];
            realCounter++;
        }
    }
}

#pragma mark - Gesture recognizer handlers

-(void)handleTapGesture:(UITapGestureRecognizer *) sender
{
    oldLocation = [sender locationInView:self.superview];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender
{
    newLocation = [sender  locationInView:self.superview];
    
    CGFloat angleInRadians = atan2f(newLocation.y - self.center.y, newLocation.x - self.center.x) - atan2f(oldLocation.y - self.center.y, oldLocation.x - self.center.x);
    
    if (angleInRadians < kMaximumAngleInRadians && angleInRadians > -kMaximumAngleInRadians)
    {
        selectedRing = (Ring *)sender.view;
        
        if(anglesTravelled + angleInRadians >= kBackMoveBlock && anglesTravelled + angleInRadians < kFrontMoveBlock - sender.view.tag * (2 * M_PI / _cellCount))
        {
            self.transform = CGAffineTransformRotate(self.transform, angleInRadians);
            NSLog(@"%f", angleInRadians);

            anglesTravelled += angleInRadians;
            
            if (![self checkForValidNumberEntry:sender.view.tag])
            {
                [self setRingAndLabelToColor:[UIColor whiteColor]];
            }
            else
            {
                [self setRingAndLabelToColor:[UIColor greenColor]];
            }
        }
        else if(anglesTravelled + angleInRadians < kBackMoveBlock)
        {
            [self setRingAndLabelToColor:[UIColor redColor]];
        }
    }
    
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        [self panGestureEnded:sender];
    }
    
    
    NSLog(@"old: %f %f new: %f %f center: %f %f", oldLocation.x, oldLocation.y, newLocation.x, newLocation.y, self.center.x, self.center.y);
    
    oldLocation = newLocation;
    
}

-(void)panGestureEnded:(UIPanGestureRecognizer *)sender
{
    if([self checkForValidNumberEntry:sender.view.tag])
    {
        [self numberEntered:sender.view.tag];
    }
    
    if ([self radiansToDegrees:anglesTravelled] < 180)
    {
        [UIView animateWithDuration:kAnimationTime animations:^{
            self.transform = CGAffineTransformRotate(self.transform, -(anglesTravelled));
        } completion:^(BOOL finished)
         {
             [self setRingAndLabelToColor:[UIColor whiteColor]];
         }];
        anglesTravelled = 0;
    }
    else
    {
        [self reverseAnimationWithStep:anglesTravelled / kSubanimationNumber andTimeStep:kAnimationTime / kSubanimationNumber];
    }
    
    NSLog(@"END PAN - old: %f %f new: %f %f", oldLocation.x, oldLocation.y, newLocation.x, newLocation.y);
    
    oldLocation = self.center;
    newLocation = self.center;
}

#pragma mark - Recursive Animation Method

-(void)reverseAnimationWithStep:(CGFloat)step andTimeStep:(CGFloat)timeStep
{
    if(anglesTravelled > kAnimationBoundary)
    {
        [UIView animateWithDuration:timeStep animations:^{
            
            self.transform = CGAffineTransformRotate(self.transform, -step);
            
        } completion:^(BOOL finished)
         {
             anglesTravelled = anglesTravelled - step <= 0 ? 0 : anglesTravelled - step;
             [self reverseAnimationWithStep:step andTimeStep:timeStep];
         }];
    }
    else
    {
        [self setRingAndLabelToColor:[UIColor whiteColor]];
        
        anglesTravelled = 0;
    }
}

#pragma mark - Correct Entry check method

-(BOOL)checkForValidNumberEntry:(int)tag
{
    if(anglesTravelled >= kFrontMoveBlock - kSuccessZoneOffset - tag * (2 * M_PI / (_cellCount)))
    {
        return YES;
    }
    return NO;
}

-(void)numberEntered:(int)tag
{
    [self.delegate didEnterNumber:tag];
}

#pragma mark - Color managing methods

-(void)setRingAndLabelToColor:(UIColor *)color
{
    selectedRing.layer.borderColor = color.CGColor;
}

#pragma mark - Degrees to radians and radians to degrees

-(CGFloat)radiansToDegrees:(CGFloat)radians
{
    return ((radians) * (180.0 / M_PI));
}

-(CGFloat)degreesToRadians:(CGFloat)degrees
{
    return ((degrees) / 180.0 * M_PI);
}


@end
