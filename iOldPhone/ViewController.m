//
//  ViewController.m
//  iOldPhone
//
//  Created by Ivelin Ivanov on 8/16/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSArray *nums;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    nums = [NSArray arrayWithObjects:@"0",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2",@"1", nil];
    
    _cellCount = kCellCount;
    _center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    _radius = MIN(self.view.frame.size.width, self.view.frame.size.height) / 2.5;
    
    self.puckView.delegate = self;
    
    [self layoutLabels];
}

#pragma mark - Layout Subviews

- (void)layoutLabels
{
    int realCounter = 0;
    
    for (int i = 0; i < self.cellCount; i++)
    {
        if (i > 2)
        {
            UILabel *numberLabel = [[UILabel alloc] init];
            numberLabel.frame = CGRectMake(0, 0, kRingSize, kRingSize);
            numberLabel.center = CGPointMake(_center.x + _radius * cosf(2 * i * M_PI / _cellCount),
                                             _center.y + _radius * sinf(2 * i * M_PI / _cellCount));
            numberLabel.text = nums[realCounter];
            numberLabel.tag = realCounter + 10;
            
            numberLabel.textAlignment = NSTextAlignmentCenter;
            numberLabel.backgroundColor = [UIColor clearColor];
            numberLabel.textColor = [UIColor whiteColor];
            numberLabel.font = [UIFont systemFontOfSize:30];
        
            [self.view addSubview:numberLabel];
            realCounter++;
        }
    }
}


#pragma mark - IBAction Methods

- (IBAction)clearButtonClicked:(id)sender
{
    self.numberField.text = @"";
    self.callButton.hidden = YES;
    self.clearButton.hidden = YES;
}

- (IBAction)callButtonPressed:(id)sender
{
    if (![self.numberField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
                                                        message:[NSString stringWithFormat:@"Do you really want to call this number: %@", self.numberField.text]
                                                       delegate:self
                                              cancelButtonTitle:@"Yes"
                                              otherButtonTitles:@"No", nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                        message:@"Dial number first"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark - Alert View Delegate Methods

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.numberField.text]]];
    }
}

#pragma mark - PuckView Delegate Methods

-(void)didEnterNumber:(int)tag
{
    NSString *currentText = self.numberField.text;
    self.numberField.text = [[NSString alloc] initWithFormat:@"%@%@",currentText,nums[tag]];
    self.callButton.hidden = NO;
    self.clearButton.hidden = NO;
}


@end
