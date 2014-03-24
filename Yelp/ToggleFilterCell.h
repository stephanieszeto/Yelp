//
//  ToggleFilterCell.h
//  Yelp
//
//  Created by Stephanie Szeto on 3/23/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToggleFilterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *filterName;
@property (weak, nonatomic) IBOutlet UISwitch *toggle;
@property (nonatomic) NSInteger off;

@end
