//
//  WFBDetailViewController.h
//  iRemember
//
//  Created by Derick Beckwith on 7/16/14.
//  Copyright (c) 2014 Auburn University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/UTCoreTypes.h>

static NSString * const kStoryEntityName = @"Story";
static NSString * const kTitleKey = @"storyTitle";
static NSString * const kBodyKey = @"storyBody";
static NSString * const kTagsKey = @"storyTags";
static NSString * const kDateKey = @"storyDate";
static NSString * const kLocationLatitude = @"storyLocationLatitude";
static NSString * const kLocationLongitude = @"storyLocationLongitude";
static NSString * const kImageFilepath = @"storyImageFilepath";

@interface WFBDetailViewController : UIViewController <
CLLocationManagerDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextField *bodyText;
@property (weak, nonatomic) IBOutlet UITextField *tagsText;
@property (weak, nonatomic) IBOutlet UIDatePicker *storyDatePicker;

// Used with Core Location
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;

// Used for the photo taking feature
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *takePictureButton;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *lastChosenMediaType;

- (IBAction)titleTextChanged:(UITextField *)sender;
- (IBAction)bodyTextChanged:(UITextField *)sender;
- (IBAction)tagsTextChanged:(UITextField *)sender;
- (IBAction)storyDateChanged:(UIDatePicker *)sender;
- (IBAction)getCurrentLocation:(UIButton *)sender;

@end
