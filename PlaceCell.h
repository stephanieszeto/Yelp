//
//  PlaceCell.h
//  Yelp
//
//  Created by Stephanie Szeto on 3/20/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

@interface PlaceCell : UITableViewCell

@property (nonatomic, strong) Place *business;

- (void)setPlace:(Place *)business;

@end

