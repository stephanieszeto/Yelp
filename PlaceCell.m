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

@property (nonatomic, strong) NSDictionary *nameProperties;
@property (nonatomic, strong) NSDictionary *addressProperties;
@property (nonatomic, strong) NSDictionary *categoryProperties;

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
    CGRect frame = self.name.frame;
    frame.size.width = 200.0;
    self.name.frame = frame;
    [self.name sizeToFit];
   
    self.address.text = business.address;
    self.address.numberOfLines = 0;
    self.address.lineBreakMode = NSLineBreakByWordWrapping;
    frame = self.address.frame;
    frame.size.width = 200.0; 
    self.address.frame = frame;
    [self.address sizeToFit];
    
    self.reviews.text = [NSString stringWithFormat:@"%d Reviews", business.numReviews];
    self.categories.text = business.category;
    self.categories.numberOfLines = 0;
    self.categories.lineBreakMode = NSLineBreakByWordWrapping;
    frame = self.categories.frame;
    frame.size.width = 200.0;
    self.categories.frame = frame;
    [self.categories sizeToFit];
    
    [self.businessImage setImageWithURL:[NSURL URLWithString:business.imageURL]];
    [self.stars setImageWithURL:[NSURL URLWithString:business.ratingURL]];
}

- (CGFloat)heightOfCell {
	// set up attributes of UILabel
	if (self.nameProperties == nil) {
		self.nameProperties = @{ NSFontAttributeName: self.name.font };
		self.addressProperties = @{ NSFontAttributeName: self.address.font };
		self.categoryProperties = @{ NSFontAttributeName: self.categories.font };
	}

	// calculate height
	double height = 32.0;
    
	CGSize minSize = CGSizeMake(211, 90);
	CGSize maxSize = CGSizeMake(211, 0);

	height += [self.name.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:self.nameProperties context:nil].size.height;
	height += [self.address.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:self.addressProperties context:nil].size.height;
	height += [self.categories.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:self.categoryProperties context:nil].size.height;
    
	height = MAX(minSize.height, height);
	return height;
}

@end
