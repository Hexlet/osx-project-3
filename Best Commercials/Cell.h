//
//  Cell.h
//  Best Commercials
//
//  Created by herku on 12/3/12.
//  Copyright (c) 2012 Advert.Ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *brandLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbImageView;
@property (assign, nonatomic) IBOutlet cCell *customCell;


@end
