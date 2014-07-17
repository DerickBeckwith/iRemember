//
//  WFBDetailViewController.h
//  iRemember
//
//  Created by Derick Beckwith on 7/16/14.
//  Copyright (c) 2014 Auburn University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WFBDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextField *bodyText;
@property (weak, nonatomic) IBOutlet UITextField *tagsText;
@property (weak, nonatomic) IBOutlet UIDatePicker *publishDatePicker;

@property (strong, nonatomic) id detailItem;

- (IBAction)titleTextChanged:(UITextField *)sender;
- (IBAction)bodyTextChanged:(UITextField *)sender;
- (IBAction)tagsTextChanged:(UITextField *)sender;
- (IBAction)storyDateChanged:(UIDatePicker *)sender;

@end
