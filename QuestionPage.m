//
//  QuestionPage.m
//  endthedebate
//
//  Created by Cody Hughes on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import "QuestionPage.h"

@interface NavigationContentsViewController :
UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *myTableView;
    IBOutlet UITableView * newsTable;
    UIActivityIndicatorView * activityIndicator;
    CGSize cellSize;
    NSXMLParser * rssParser;
    NSMutableArray * stories;
    NSMutableDictionary * item;
    
    NSString * currentElement;
    NSMutableString * currentTitle, * currentDate, * currentSummary, * currentLink;
    
}
@end