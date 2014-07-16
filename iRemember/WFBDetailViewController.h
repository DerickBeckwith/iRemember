//
//  WFBDetailViewController.h
//  iRemember
//
//  Created by Derick Beckwith on 7/16/14.
//  Copyright (c) 2014 Auburn University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WFBDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
