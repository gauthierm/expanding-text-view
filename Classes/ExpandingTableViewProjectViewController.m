//
//  ExpandingTableViewProjectViewController.m
//  ExpandingTableViewProject
//
//  Created by Ryan Newsome on 4/12/11.
//  Hopefully this is helpful
//

#define COMMENT_LABEL_WIDTH 230
#define COMMENT_LABEL_MIN_HEIGHT 65
#define COMMENT_LABEL_PADDING 10

#import "ExpandingTableViewProjectViewController.h"
#import "CommentTableCell.h"

@implementation ExpandingTableViewProjectViewController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set set our selected Index to -1 to indicate no cell will be expanded
    selectedIndex = -1;
    

    //SetUpTestData with some meaningless strings
    textArray = [[NSMutableArray alloc] init];
    statusArray = [[NSMutableArray alloc] init];

    NSString *testString;
    
    for (int ii = 0; ii < 6; ii++) {
        testString = @"Test comment. Test comment.";
        for (int jj = 0; jj < ii; jj++) {
            testString = [NSString stringWithFormat:@"%@ %@", testString, testString];
        }
        [testString retain];
        [textArray addObject:testString];
        [statusArray addObject:@(NO)];
    }
}


//This just a convenience function to get the height of the label based on the comment text
-(CGFloat)getLabelHeightForIndex:(NSInteger)index
{
    CGSize maximumSize = CGSizeMake(COMMENT_LABEL_WIDTH, 10000);
    
    CGSize labelHeighSize = [[textArray objectAtIndex:index] sizeWithFont: [UIFont fontWithName:@"Helvetica" size:14.0f]
                                                                constrainedToSize:maximumSize
                                                                lineBreakMode:UILineBreakModeWordWrap];
    return labelHeighSize.height;
    
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [textArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    static NSString *CellIdentifier = @"customCell";
    
    CommentTableCell *cell = (CommentTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[[exerciseListUITableCell alloc] init] autorelease];
        
        NSArray * topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CommentTableCell" owner:self options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (CommentTableCell *)currentObject;
                break;
            }
        }        
    }

    cell.commentTextLabel.text = textArray[indexPath.row];
    cell.commentTextLabel.textContainerInset = UIEdgeInsetsZero;
    cell.commentTextLabel.textContainer.lineFragmentPadding = 0;
    cell.commentTextLabel.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    cell.commentTextLabel.textContainer.maximumNumberOfLines = 0;

    CGFloat labelHeight = [self getLabelHeightForIndex:indexPath.row];

    if (labelHeight <= [self tableView:tableView heightForRowAtIndexPath:indexPath]) {
        cell.moreButton.hidden = YES;
    } else {
        CGRect textFrame = cell.commentTextLabel.frame;
        CGRect buttonFrame = cell.moreButton.frame;
        CGRect exclusion = CGRectMake(textFrame.size.width - buttonFrame.size.width,
                                      textFrame.size.height - buttonFrame.size.height,
                                      buttonFrame.size.width,
                                      buttonFrame.size.height);

        cell.commentTextLabel.textContainer.exclusionPaths = @[[UIBezierPath bezierPathWithRect:exclusion]];
    }

    if (((NSNumber *)statusArray[indexPath.row]).boolValue) {
        cell.commentTextLabel.frame = CGRectMake(cell.commentTextLabel.frame.origin.x, 
                                                cell.commentTextLabel.frame.origin.y, 
                                                cell.commentTextLabel.frame.size.width, 
                                                labelHeight);

        cell.commentTextLabel.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
    } else {
        // Otherwise just return the minimum height for the label.
        cell.commentTextLabel.frame = CGRectMake(cell.commentTextLabel.frame.origin.x, 
                                                cell.commentTextLabel.frame.origin.y, 
                                                cell.commentTextLabel.frame.size.width, 
                                                COMMENT_LABEL_MIN_HEIGHT);
    }

    cell.commentTextLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = COMMENT_LABEL_MIN_HEIGHT + COMMENT_LABEL_PADDING * 2.0;

    if (((NSNumber *)statusArray[indexPath.row]).boolValue) {
        height = [self getLabelHeightForIndex:indexPath.row] + COMMENT_LABEL_PADDING * 2.0;
    }

    height = ceil(height);
    height = MAX(height, 85);

    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (IBAction)moreText:(id)sender {
    CommentTableCell *cell = (CommentTableCell *)[[[sender superview] superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    CGFloat labelHeight = [self getLabelHeightForIndex:indexPath.row];

    [UIView animateWithDuration:0.25
                     animations:^{
                         cell.commentTextLabel.frame = CGRectMake(cell.commentTextLabel.frame.origin.x,
                                                                  cell.commentTextLabel.frame.origin.y,
                                                                  cell.commentTextLabel.frame.size.width,
                                                                  labelHeight);
                                }
                     completion:^(BOOL finished) {
                                }];

    cell.commentTextLabel.textContainer.exclusionPaths = nil;
    cell.moreButton.hidden = YES;

    statusArray[indexPath.row] = @(YES);

    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}

- (void)dealloc {
    [super dealloc];
}

@end
