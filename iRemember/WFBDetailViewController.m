//
//  WFBDetailViewController.m
//  iRemember
//
//  Created by Derick Beckwith on 7/16/14.
//  Copyright (c) 2014 Auburn University. All rights reserved.
//

#import "WFBDetailViewController.h"

@interface WFBDetailViewController ()
- (void)configureView;
@end

@implementation WFBDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.titleText.text = [self.detailItem valueForKey:kTitleKey];
        self.bodyText.text = [self.detailItem valueForKey:kBodyKey];
        self.tagsText.text = [self.detailItem valueForKey:kTagsKey];
        self.storyDatePicker.date = [self.detailItem valueForKey:kDateKey];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)titleTextChanged:(UITextField *)sender
{
    
}

- (IBAction)bodyTextChanged:(UITextField *)sender
{
    
}

- (IBAction)tagsTextChanged:(UITextField *)sender
{
    
}

- (IBAction)storyDateChanged:(UIDatePicker *)sender
{
    
}

- (IBAction)textFieldDoneEditing:(UITextField *)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [self.titleText resignFirstResponder];
    [self.bodyText resignFirstResponder];
    [self.tagsText resignFirstResponder];
}

@end
