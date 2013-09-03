//
//  ViewController.h
//  iOldPhone
//
//  Created by Ivelin Ivanov on 8/16/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Ring.h"
#import "Constants.h"
#import "PuckView.h"

@interface ViewController : UIViewController <UIAlertViewDelegate, PuckViewDelegate>

@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) NSInteger cellCount;

@property (weak, nonatomic) IBOutlet UITextField *numberField;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;


@property (weak, nonatomic) IBOutlet PuckView *puckView;

- (IBAction)clearButtonClicked:(id)sender;
- (IBAction)callButtonPressed:(id)sender;

@end
