//
//  ActivityCell.h
//  
//
//  Created by Sau Chung Loh on 9/24/15.
//
//

#import <UIKit/UIKit.h>

@interface ActivityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *activityPicture;
@property (weak, nonatomic) IBOutlet UILabel *activityTitle;
@property (weak, nonatomic) IBOutlet UILabel *activityDate;
@property (weak, nonatomic) IBOutlet UILabel *activityInterest;

@end
