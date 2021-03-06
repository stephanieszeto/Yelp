//
//  YelpClient.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpClient.h"

@implementation YelpClient

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken accessSecret:(NSString *)accessSecret {
    NSURL *baseURL = [NSURL URLWithString:@"http://api.yelp.com/v2/"];
    self = [super initWithBaseURL:baseURL consumerKey:consumerKey consumerSecret:consumerSecret];
    if (self) {
        BDBOAuthToken *token = [BDBOAuthToken tokenWithToken:accessToken secret:accessSecret expiration:nil];
        [self.requestSerializer saveAccessToken:token];
    }
    return self;
}

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    NSDictionary *parameters = @{@"term": term, @"location" : @"San Francisco"};
    
    return [self GET:@"search" parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *)searchWithInputs:(NSArray *)inputs success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    // extract term
    NSString *term = inputs[0];
    
    // extract deal value
    NSNumber *deals = inputs[1];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:@{@"term": term, @"location" : @"San Francisco", @"deals_filter" : deals}];
    
    // extract distance value
    NSArray *distances = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:100], [NSNumber numberWithInt:200], [NSNumber numberWithInt:300], nil];
    NSNumber *distance = inputs[2];
    if ([distance integerValue] != -1) {
        [parameters setValue:distances[[distance integerValue]] forKey:@"radius_filter"];
    }
    
    // extract sort value
    NSNumber *sort = inputs[3];
    if ([sort integerValue] != -1) {
        [parameters setValue:sort forKey:@"sort"];
    }
    
    // extract category value
    NSArray *categories = [[NSArray alloc] initWithObjects:@"breakfast_brunch", @"comfortfood", @"dimsum", @"fondue", @"raw_food", @"tapas", nil];
    NSInteger categoryIndex = [inputs[4] integerValue];
    if (categoryIndex != -1) {
        NSString *category = categories[categoryIndex];
        [parameters setValue:category forKey:@"category_filter"];
    }

    NSLog(@"API call with parameters: %@", parameters);
    id response = [self GET:@"search" parameters:parameters success:success failure:failure];
    return response;
}

@end
