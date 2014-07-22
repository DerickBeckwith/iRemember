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
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)titleTextChanged:(UITextField *)sender
{
    [self.detailItem setValue:sender.text forKey:kTitleKey];
}

- (IBAction)bodyTextChanged:(UITextField *)sender
{
    [self.detailItem setValue:sender.text forKey:kBodyKey];
}

- (IBAction)tagsTextChanged:(UITextField *)sender
{
    [self.detailItem setValue:sender.text forKey:kTagsKey];
}

- (IBAction)storyDateChanged:(UIDatePicker *)sender
{
    [self.detailItem setValue:sender.date forKey:kDateKey];
}

- (IBAction)textFieldDoneEditing:(UITextField *)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [self.titleText resignFirstResponder];
    [self.bodyText resignFirstResponder];
    [self.tagsText resignFirstResponder];
}

- (IBAction)getCurrentLocation:(UIButton *)sender
{
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    NSLog(@"didUpdateToLocation: %@", currentLocation);
    
    NSString *latitude = [NSString stringWithFormat:@"%.2f\u00B0",
                          currentLocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%.2f\u00B0",
                           currentLocation.coordinate.longitude];
    self.latitudeLabel.text = latitude;
    self.longitudeLabel.text = longitude;
    
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString *errorType = (error.code == kCLErrorDenied) ? @"Access Denied" : @"Unknown Error";
    NSLog(@"didFailWithError: %@", errorType);
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error getting Location"
                          message:errorType delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
}

@end
