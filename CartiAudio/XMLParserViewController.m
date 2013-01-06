//
//  XMLParserViewController.m
//  XMLParser
//
//  Created by Ravi Dixit on 20/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XMLParserViewController.h"

@implementation XMLParserViewController
@synthesize xmlAuthorsData,xmlBooksData;
@synthesize isAuthor,isBook;
@synthesize authorsDict;
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}



#pragma mark NSXMLParser delegate

//below delegate method is sent by a parser object to provide its delegate when it encounters a start tag 

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	//if element name is equat to item then only i am assingning memory to the NSObject class

	if([elementName isEqualToString:@"author"]){
        self.isAuthor=YES;
        self.isBook=NO;
		authorDataItem =[[AuthorDataModel alloc] init];
	}
    else if ([elementName isEqualToString:@"book"])
    {
        self.isAuthor=NO;
        self.isBook=YES;
        bookDataItem =[[BookItemDataModel alloc] init] ;
    }
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	//whatever data i am getting from node i am appending it to the nodecontent variable
	[nodecontent appendString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    //NSLog(@"node content = %@",nodecontent);
}

//bellow delegate method specify when it encounter end tag of specific that tag

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	//I am saving my nodecontent data inside the property of XMLString File class
	
 
    
    if (self.isAuthor)
    {  //parsing authors

        if([elementName isEqualToString:@"id"]){  
            
            authorDataItem.autorID=nodecontent;
        }

        else if([elementName isEqualToString:@"name"]){
            authorDataItem.authorName=nodecontent;
        }
        else if([elementName isEqualToString:@"surname"]){
            authorDataItem.authorSurname=nodecontent;
        }
        else if([elementName isEqualToString:@"smalllogo"]){
            authorDataItem.smallLogoLink=nodecontent;
        }
        else if([elementName isEqualToString:@"birthdate"]){
            authorDataItem.birthDate=nodecontent;
        }
        else if([elementName isEqualToString:@"enddate"]){
            authorDataItem.endDate=nodecontent;
        }
                 
        //finally when we reaches the end of tag i am adding data inside the NSMutableArray
        if([elementName isEqualToString:@"author"])
        {
            
            [self.xmlAuthorsData addObject:authorDataItem];
            NSLog(@"%@ author %@",authorDataItem.authorName, authorDataItem.autorID);
            if (authorDataItem.autorID) {
            //[self.authorsDict setObject:authorsDict forKey:authorDataItem.autorID];
            }
            [authorDataItem release];
            authorDataItem = nil;
        }
            
    }
    //parsing books
    else if (self.isBook)
    {
        if([elementName isEqualToString:@"idb"]){
            bookDataItem.idb=nodecontent;
        }
        else if([elementName isEqualToString:@"name"]){
            bookDataItem.name=nodecontent;
        }
        else if([elementName isEqualToString:@"length_minutes"]){
            bookDataItem.lenghtMinutes=nodecontent;
        }
        else if([elementName isEqualToString:@"category"]){
            bookDataItem.category=nodecontent;
        }
        else if([elementName isEqualToString:@"year_of_publishing"]){
            bookDataItem.yearOfPublishing=nodecontent;
        }
        else if([elementName isEqualToString:@"year_of_recording"]){
            bookDataItem.yearOfRecording=nodecontent;
        }
        else if([elementName isEqualToString:@"number_of_files"]){
            bookDataItem.numberOfFiles=nodecontent;
        }
        
        //finally when we reaches the end of tag i am adding data inside the NSMutableArray
        if([elementName isEqualToString:@"book"]){
            
            [xmlBooksData addObject:bookDataItem];
            //NSLog(@"data %@",bookDataItem.name);
            [bookDataItem release];
            bookDataItem = nil;
        }
        
    }
	//release the data from mutable string variable
	[nodecontent release];
    
	//reallocate the memory to get new content data from file
	nodecontent=[[NSMutableString alloc]init];
}


-(void) startParsingAuthors
{
    self.xmlAuthorsData = [[NSMutableArray alloc]init];
    self.authorsDict = [[NSMutableDictionary alloc] init];
 
        nodecontent=[[NSMutableString alloc]init];
   
    //declare the object of allocated variable
    NSData *xmlData=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:@"http://www.audiocarti.eu/app/authors.xml"]];
    
    //allocate memory for parser as well as
    xmlParserObject =[[NSXMLParser alloc]initWithData:xmlData];
    [xmlParserObject setDelegate:self];
    
    //asking the xmlparser object to beggin with its parsing
    [xmlParserObject parse];
    
    //releasing the object of NSData as a part of memory management
    [xmlData release];

}
-(void) startParsingBooksWithAuthorId:(NSString*) idAuthor
{
    xmlBooksData = [[NSMutableArray alloc]init];
    
    
    //declare the object of allocated variable
    NSString *link=[NSString stringWithFormat:@"http://www.audiocarti.eu/app/%@books.xml",idAuthor];
    NSData *xmlData=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:link]];
    
    //allocate memory for parser as well as
    xmlParserObject =[[NSXMLParser alloc]initWithData:xmlData];
    [xmlParserObject setDelegate:self];
    
    //asking the xmlparser object to beggin with its parsing
    [xmlParserObject parse];
    
    //releasing the object of NSData as a part of memory management
    [xmlData release];
    
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.xmlBooksData = [[NSMutableArray alloc]init];
    
    //declare the object of allocated variable
    NSData *xmlData=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:@"http://www.audiocarti.eu/app/authors.xml"]];
    
    //allocate memory for parser as well as 
    xmlParserObject =[[NSXMLParser alloc]initWithData:xmlData];
    [xmlParserObject setDelegate:self];
    
    //asking the xmlparser object to beggin with its parsing
    [xmlParserObject parse];
    
    //releasing the object of NSData as a part of memory management
    [xmlData release];
}



/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}



- (void)dealloc {
	[xmlAuthorsData release];
	[xmlParserObject release];
    [super dealloc];
}

@end
