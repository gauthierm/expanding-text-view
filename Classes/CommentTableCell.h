//
//  CommentTableCell.h
//  ExpandingTableViewProject
//
//  Created by Ryan Newsome on 4/13/11.
//

#import <UIKit/UIKit.h>

@interface CommentTableCell : UITableViewCell {
    
    IBOutlet UITextView *commentTextLabel;
    IBOutlet UIButton *moreButton;

}

@property(nonatomic,retain)IBOutlet UITextView *commentTextLabel;
@property(nonatomic,retain)IBOutlet UIButton *moreButton;

@end
