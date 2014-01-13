//
//  ViewController.m
//  DoIt
//
//  Created by Andrew Webb on 1/13/14.
//  Copyright (c) 2014 Andrew Webb and Poulose Matthen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    
    __weak IBOutlet UITableView *myTableView;
    NSMutableArray* items;
    __weak IBOutlet UITextField *myTextField;
    BOOL isDoneEditing;
    __weak IBOutlet UIButton *editButton;
    NSIndexPath *deletePath;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    items = @[@"One",@"Two",@"Three"].mutableCopy;
    isDoneEditing = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"myReuseIdentifier"];
    cell.textLabel.text =[items objectAtIndex:indexPath.row];
    
    return cell;
}

- (IBAction)onEditButtonPressed:(id)sender
{
    if(isDoneEditing)
    {
        isDoneEditing = NO;
        [myTableView setEditing:YES animated:NO];
        [editButton setTitle:@"Done" forState:UIControlStateNormal];
        
    }
    else{
        isDoneEditing = YES;
        [myTableView setEditing:NO animated:NO];
        [editButton setTitle:@"Edit" forState:UIControlStateNormal];
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (isDoneEditing)
    {
        if (![cell.textLabel.text hasPrefix:@"\u2713"]) {
            cell.textLabel.text = [NSString stringWithFormat:@"\u2713 %@", cell.textLabel.text];
        } else {
            cell.textLabel.text = [cell.textLabel.text substringFromIndex:[@"\u2713 " length]];
        }
    }else
    {
        [self deleteItem:indexPath];
    }
}

-(void)deleteItem:(NSIndexPath *)indexPath {
    deletePath = indexPath;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Item?" message:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [items removeObjectAtIndex:deletePath.row];
        [myTableView reloadData];
    }
}

- (IBAction)onAddButtonPressed:(id)sender
{
    [items addObject:myTextField.text];
    [myTableView reloadData];
    [myTextField resignFirstResponder];
    myTextField.text = @"";
}

-(IBAction)onSwipeRight:(UISwipeGestureRecognizer *)swipeGestureRecognizer {
    NSLog(@"test");
    CGPoint location = [swipeGestureRecognizer locationInView:myTableView];
    NSIndexPath *indexPath = [myTableView indexPathForRowAtPoint:location];
    
    if(indexPath){
        UITableViewCell * cell = (UITableViewCell *)[myTableView cellForRowAtIndexPath:indexPath];
        [self increasePriority:cell];
    }
}

-(void)increasePriority:(UITableViewCell *)cell {
    int currentPriority;
    NSArray *priorityColors = @[[UIColor blackColor], [UIColor greenColor], [UIColor yellowColor], [UIColor redColor]];
  
    for (int i = 0; i < priorityColors.count; i++) {
        if (cell.textLabel.textColor == [priorityColors objectAtIndex:i]) {
            currentPriority = i;
        }
    }

    cell.textLabel.textColor = priorityColors[(currentPriority+1) % 4];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteItem:indexPath];
    }
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSString *stringToMove = [items objectAtIndex:sourceIndexPath.row];
    [items removeObjectAtIndex:sourceIndexPath.row];
    [items insertObject:stringToMove atIndex:destinationIndexPath.row];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
