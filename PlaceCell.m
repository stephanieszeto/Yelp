//
//  PlaceCell.m
//  Yelp
//
//  Created by Stephanie Szeto on 3/20/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "PlaceCell.h"
#import "Place.h"
#import "UIImageView+AFNetworking.h"

@interface PlaceCell ()

@property (weak, nonatomic) IBOutlet UIImageView *businessImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *stars;
@property (weak, nonatomic) IBOutlet UILabel *reviews;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *categories;

@end

@implementation PlaceCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

# pragma mark - Public methods

- (void)setPlace:(Place *)business {
    _business = business;
    
    self.name.text = business.name;
    self.name.numberOfLines = 0;
    self.name.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.address.text = business.address;
    self.address.lineBreakMode = NSLineBreakByWordWrapping;
    self.reviews.text = [NSString stringWithFormat:@"%d Reviews", business.numReviews];
    self.categories.text = business.category;
    self.categories.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self.businessImage setImageWithURL:[NSURL URLWithString:business.imageURL]];
    [self.stars setImageWithURL:[NSURL URLWithString:business.ratingURL]];
}

@end
