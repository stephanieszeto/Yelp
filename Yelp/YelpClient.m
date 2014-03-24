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
    /*NSString *deals;
    NSInteger dealInput = [inputs[1] integerValue];
    if (dealInput == 0) {
        deals = @"true";
    } else if (dealInput == 1) {
        deals = @"false";
    }*/
    NSNumber *deals = inputs[1];
    
    // extract distance value
    NSNumber *distance = inputs[2];
    
    // extract sort value
    NSNumber *sort = inputs[3];
    
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    NSDictionary *parameters = @{@"term": term, @"location" : @"San Francisco", @"sort" : sort, @"deals_filter" : deals, @"radius_filter" : distance};
    NSLog(@"API call with parameters: %@", parameters);
    
    id response = [self GET:@"search" parameters:parameters success:success failure:failure];
    return response;
}

@end
