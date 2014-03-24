//
//  Place.h
//  Yelp
//
//  Created by Stephanie Szeto on 3/20/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Place : NSObject

@property (nonatomic, strong) NSDictionary *business;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSInteger rating;
@property (nonatomic) NSInteger numReviews;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *ratingURL;

- (id)initWithDictionary:(NSDictionary *)business;
- (NSString *)category;
- (NSString *)address;

@end
