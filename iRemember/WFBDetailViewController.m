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
    // Update the user interface for the Story detail item.
    if (self.detailItem) {
        self.titleText.text = [self.detailItem valueForKey:kTitleKey];
        self.bodyText.text = [self.detailItem valueForKey:kBodyKey];
        self.tagsText.text = [self.detailItem valueForKey:kTagsKey];
        self.storyDatePicker.date = [self.detailItem valueForKey:kDateKey];
        self.latitudeLabel.text = [self.detailItem valueForKey:kLocationLatitude];
        self.longitudeLabel.text = [self.detailItem valueForKey:kLocationLongitude];
        NSString *path = [self.detailItem valueForKey:kImageFilepath];
        [self loadImageFromPath:path];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup the UI.
    [self configureView];
    
    // Setup the location manager.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateDisplay];
}

- (void)updateDisplay
{
    // Update the image view if the user selected one from the image picker.
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
    // Start receiving location updates from core location.
    [self.locationManager startUpdatingLocation];
}

- (IBAction)shootPictureOrVideo:(id)sender
{
    // When the user wants to take a new photo to use in the story.
    [self pickMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction)selectExistingPictureOrVideo:(id)sender
{
    // When the user wants to use a photo already stored in their photo library.
    [self pickMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (NSString *)getUniqueFileName
{
    NSString *prefix = @"iRemember";
    NSString *guid = [[NSUUID new] UUIDString];
    NSString *uniqueFileName = [NSString stringWithFormat:@"%@_%@.png", prefix, guid];
    return uniqueFileName;
}

- (void)saveImage: (UIImage*)image
{
    if (image != nil)
    {
        // Compose a valid file path to save the image to.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          [self getUniqueFileName]];
        
        // Create the .png data from the image property's UIImage instance.
        NSData* data = UIImagePNGRepresentation(image);
        
        // Save the data to the .png file.
        [data writeToFile:path atomically:YES];
        NSLog(@"Saved photo to: %@", path);
        
        // Update the core data model with the path to the .png file.
        [self.detailItem setValue:path forKey:kImageFilepath];
    }
}

- (void)loadImageFromPath:(NSString *)path
{
    // Read the contents of the file into the image property.
    self.image = [UIImage imageWithContentsOfFile:path];
    
    // Set the image view to display the loaded image.
    self.imageView.image = self.image;
    NSLog(@"Loaded photo from: %@", path);
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    
    if (currentLocation != nil) {
        NSLog(@"didUpdateToLocation: %@", currentLocation);
        
        // Get the coordinates as strings.
        NSString *latitude = [NSString stringWithFormat:@"%.2f\u00B0",
                              currentLocation.coordinate.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%.2f\u00B0",
                               currentLocation.coordinate.longitude];
        
        // Update the UI.
        self.latitudeLabel.text = latitude;
        self.longitudeLabel.text = longitude;
        
        // Update the data model.
        [self.detailItem setValue:latitude forKey:kLocationLatitude];
        [self.detailItem setValue:longitude forKey:kLocationLongitude];
    }
    
    // Stop receiving location updates until the next time the user taps the 'Get Location' button.
    // Doing this can save battery life.
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // Access denied will happen if the user refused to allow the app to track their location.
    NSString *errorType = (error.code == kCLErrorDenied) ? @"Access Denied" : @"Unknown Error";
    
    NSLog(@"didFailWithError: %@", errorType);
    
    // Let the user know the location could not be obtained.
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
    
    // The app only cares about still photos, so we need to filter out anything else, like videos.
    if ([self.lastChosenMediaType isEqual:(NSString *)kUTTypeImage]) {
        
        // Get the cropped image.
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        
        // Resize the image to fit into the image view and assign to the image property.
        self.image = [self shrinkImage:chosenImage toSize:self.imageView.bounds.size];
        
        // Save the image to a .png file so it can be retrieved later.
        [self saveImage:self.image];
    }
    
    // Dismiss the image picker to return control flow back to the detail view controller.
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // Simply dismiss the image picker if the user taps the cancel button.
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
