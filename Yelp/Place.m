//
//  Place.m
//  Yelp
//
//  Created by Stephanie Szeto on 3/20/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "Place.h"

@interface Place ()

@property (nonatomic, strong) NSString *streetAddress;
@property (nonatomic, strong) NSString *neighborhood;
@property (nonatomic, strong) NSMutableArray *categories;

@end

@implementation Place

- (id)initWithDictionary:(NSDictionary *)business {
    self = [super init];
    if (self) {
        self.business = business;
        self.name = [business objectForKey:@"name"];
        self.rating = [[business objectForKey:@"rating"] integerValue];
        self.numReviews = [[business objectForKey:@"review_count"] integerValue];
        self.imageURL = [business objectForKey:@"image_url"];
        self.ratingURL = [business objectForKey:@"rating_img_url"];
        
        NSDictionary *location = [business objectForKey:@"location"];
        NSArray *addrArray = [location objectForKey:@"address"];
        if (addrArray.count > 0) {
            self.streetAddress = addrArray[0];
        }
        NSArray *neighborhoods = [location objectForKey:@"neighborhoods"];
        if (neighborhoods.count > 0) {
            self.neighborhood = neighborhoods[0];
        }
        
        self.categories = [[NSMutableArray alloc] init];
        NSArray *categoryArray = [business objectForKey:@"categories"];
        for (NSArray *category in categoryArray) {
            if (category.count > 0) {
                [self.categories addObject:category[0]];
            }
        }
    }
    return self;
}

- (NSString *)category {
    return [self.categories componentsJoinedByString:@", "];
}

- (NSString *)address {
    NSArray *addr = [[NSArray alloc] initWithObjects:self.streetAddress, self.neighborhood, nil];
    return [addr componentsJoinedByString:@", "];
}

@end

