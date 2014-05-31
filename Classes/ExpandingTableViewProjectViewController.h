//
//  ExpandingTableViewProjectViewController.h
//  ExpandingTableViewProject
//
//  Created by Ryan Newsome on 4/12/11.
//

#import <UIKit/UIKit.h>

@interface ExpandingTableViewProjectViewController : UITableViewController {
   
    //This array will store our coments
    NSMutableArray *textArray;
    NSMutableArray *statusArray;
    
    //This is the index of the cell which will be expanded
    NSInteger selectedIndex;
}

@end

