//
//  ToggleFilterCell.m
//  Yelp
//
//  Created by Stephanie Szeto on 3/23/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "ToggleFilterCell.h"

@implementation ToggleFilterCell

- (IBAction)onTap:(id)sender {
    // if off, turn on
    if (self.off == 1) {
        self.off = 0;
        NSLog(@"turning on");
    }
    
    // if on, turn off
    if (self.off == 0) {
        self.off = 1;
        NSLog(@"turning off");
    }
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
