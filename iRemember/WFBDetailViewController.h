//
//  WFBDetailViewController.h
//  iRemember
//
//  Created by Derick Beckwith on 7/16/14.
//  Copyright (c) 2014 Auburn University. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kStoryEntityName = @"Story";
static NSString * const kTitleKey = @"storyTitle";
static NSString * const kBodyKey = @"storyBody";
static NSString * const kTagsKey = @"storyTags";
static NSString * const kDateKey = @"storyDate";

@interface WFBDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextField *bodyText;
@property (weak, nonatomic) IBOutlet UITextField *tagsText;
@property (weak, nonatomic) IBOutlet UIDatePicker *storyDatePicker;

@property (strong, nonatomic) id detailItem;

- (IBAction)titleTextChanged:(UITextField *)sender;
- (IBAction)bodyTextChanged:(UITextField *)sender;
- (IBAction)tagsTextChanged:(UITextField *)sender;
- (IBAction)storyDateChanged:(UIDatePicker *)sender;

@end
