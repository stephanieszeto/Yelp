//
//  FilterViewController.h
//  Yelp
//
//  Created by Stephanie Szeto on 3/20/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterViewController;

@protocol FilterViewControllerDelegate <NSObject>

- (void)addItemViewController:(FilterViewController *)controller didFinishEnteringItems:(NSArray *)inputs;

@end

@interface FilterViewController : UIViewController < UITableViewDelegate, UITableViewDataSource >

@property (nonatomic, weak) id <FilterViewControllerDelegate> delegate;

@end
