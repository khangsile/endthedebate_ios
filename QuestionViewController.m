//
//  QuestionPage.m
//  endthedebate
//
//  Created by Cody Hughes on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import "QuestionViewController.h"

@interface QuestionViewController()

@property (nonatomic, strong) IBOutlet UITableView *tableview;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UITextView *textview;

@end

@implementation QuestionViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UITableViewCell new];
}

@end
