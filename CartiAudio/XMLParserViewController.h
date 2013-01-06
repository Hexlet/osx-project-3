//
//  XMLParserViewController.h
//  XMLParser
//
//  Created by Ravi Dixit on 20/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthorDataModel.h"
#import "BookItemDataModel.h"
@interface XMLParserViewController : UIViewController <NSXMLParserDelegate>
{
	
	//mutable array to store data from rss feed and display in table view
	
	NSMutableArray *xmlAuthorsData;
	NSMutableArray *xmlBooksData;
	
	//to store data from xml node 
	
	NSMutableString *nodecontent;
	
	//declare the object of nsxml parse which will we use later for parsing
	
	NSXMLParser *xmlParserObject;
	
	
	//declare the object of nsobject class
	
	AuthorDataModel *authorDataItem;
    BookItemDataModel *bookDataItem;
    
    
	
}
@property(nonatomic,retain)IBOutlet NSMutableArray *xmlAuthorsData;
@property(nonatomic,retain)         NSMutableArray *xmlBooksData;
@property(nonatomic,retain)IBOutlet UITableView *tableview;

@property (nonatomic,assign) BOOL isAuthor;

@property (nonatomic,assign) BOOL isBook;

-(void) startParsingAuthors;
-(void) startParsingBooksWithAuthorId:(NSString*) idAuthor;

@property (nonatomic,retain) NSMutableDictionary *authorsDict;
@end

