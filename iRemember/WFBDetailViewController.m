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
        self.latitudeLabel.text = [self.detailItem valueForKey:kLocationLatitude];
        self.longitudeLabel.text = [self.detailItem valueForKey:kLocationLongitude];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateDisplay];
}

- (void)updateDisplay
{
    if ([self.lastChosenMediaType isEqual:(NSString *)kUTTypeImage]) {
        self.imageView.image = self.image;
    }
}

- (void)pickMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    NSArray *mediaTypes = [UIImagePickerController
                           availableMediaTypesForSourceType:sourceType];
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]
        && [mediaTypes count] > 0) {
        NSArray *mediaTypes = [UIImagePickerController
                               availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:NULL];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error accessing media"
                              message:@"Unsupported media source."delegate:nil
                              cancelButtonTitle:@"Drats!" otherButtonTitles:nil];
        [alert show];
    }
}

- (UIImage *)shrinkImage:(UIImage *)original toSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    
    CGFloat originalAspect = original.size.width / original.size.height;
    CGFloat targetAspect = size.width / size.height;
    CGRect targetRect;
    
    if (originalAspect > targetAspect) {
        // original is wider than target
        targetRect.size.width = size.width;
        targetRect.size.height = size.height * targetAspect / originalAspect;
        targetRect.origin.x = 0;
        targetRect.origin.y = (size.height - targetRect.size.height) * 0.5;
    } else if (originalAspect < targetAspect) {
        // original is narrower than target
        targetRect.size.width = size.width * originalAspect / targetAspect;
        targetRect.size.height = size.height;
        targetRect.origin.x = (size.width - targetRect.size.width) * 0.5;
        targetRect.origin.y = 0;
    } else {
        // original and target have same aspect ratio
        targetRect = CGRectMake(0, 0, size.width, size.height);
    }
    
    [original drawInRect:targetRect];
    UIImage *final = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return final;
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

- (IBAction)shootPictureOrVideo:(id)sender
{
    [self pickMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction)selectExistingPictureOrVideo:(id)sender
{
    [self pickMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    
    if (currentLocation != nil) {
        NSLog(@"didUpdateToLocation: %@", currentLocation);
        
        NSString *latitude = [NSString stringWithFormat:@"%.2f\u00B0",
                              currentLocation.coordinate.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%.2f\u00B0",
                               currentLocation.coordinate.longitude];
        
        self.latitudeLabel.text = latitude;
        self.longitudeLabel.text = longitude;
        
        [self.detailItem setValue:latitude forKey:kLocationLatitude];
        [self.detailItem setValue:longitude forKey:kLocationLongitude];
    }
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

#pragma mark - Image Picker Controller Delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.lastChosenMediaType = info[UIImagePickerControllerMediaType];
    
    if ([self.lastChosenMediaType isEqual:(NSString *)kUTTypeImage]) {
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        self.image = [self shrinkImage:chosenImage toSize:self.imageView.bounds.size];
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
