//
//  ViewController.m
//  DoIt
//
//  Created by Andrew Webb on 1/13/14.
//  Copyright (c) 2014 Andrew Webb and Poulose Matthen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
{
    
    __weak IBOutlet UITableView *myTableView;
    NSMutableArray* items;
    __weak IBOutlet UITextField *myTextField;
    BOOL isDoneEditing;
    __weak IBOutlet UIButton *editButton;
    
    
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
        [editButton setTitle:@"Done" forState:UIControlStateNormal];
        NSLog(@"%@",editButton.titleLabel.text);
        
    }
    else{
        isDoneEditing = YES;
        [editButton setTitle:@"Edit" forState:UIControlStateNormal];
        NSLog(@"%@",editButton.titleLabel.text);
        
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (isDoneEditing)
    {
        cell.textLabel.textColor = [UIColor greenColor];
        [cell setBackgroundColor:[UIColor darkGrayColor]];
    }else
    {
        [items removeObjectAtIndex:indexPath.row];
        [myTableView reloadData];
    }
    
    NSLog(@"Click");
}

- (IBAction)onAddButtonPressed:(id)sender
{
    [items addObject:myTextField.text];
    [myTableView reloadData];
    [myTextField resignFirstResponder];
    myTextField.text = @"";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
