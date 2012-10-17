//
//  SoftRcmList.m
//  Sample
//
//  Created by xiaolin liu on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SoftRcmList.h"
#import "SoftInfo.h"

@implementation SoftRcmList

@synthesize softList;
@synthesize elmName = _elmName;

-(void) dealloc
{
    [softList release];
    [_elmName release];
    [_softInfo release];
    [super dealloc];
}

-(BOOL) loadData:(NSString*) xmlName
{
    //read file to buffer
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:xmlName];
    if (!file) {
        return NO;
    }
    NSData *data = [file readDataToEndOfFile];
    [file closeFile];
    
    //create xml parser
    NSXMLParser *parser;
    parser = [[NSXMLParser alloc] initWithData:data];
    
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    [parser setDelegate:self];
    
    //start parse
    [parser parse];
    [parser release];
    
    return  YES;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //alloc
    NSLog(@"=======start parse=========");
    softList = [[NSMutableArray alloc] init];
    _elmName = [[NSString alloc] init];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"=======end parse=========");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"=======start element:%@=========", elementName);
    if ([elementName isEqualToString:@"soft"])
    {
        if (!_softInfo)
        {
            _softInfo = [[SoftInfo alloc] init]; 
        }
    }
    else if([elementName isEqualToString:@"name"]) 
    {
        
        self.elmName= elementName;
    }
    else if([elementName isEqualToString:@"detail"]) 
    {
        self.elmName = elementName;
    }
    else if([elementName isEqualToString:@"url"]) 
    {
        self.elmName = elementName;
    }
    else if([elementName isEqualToString:@"icon"]) 
    {
        self.elmName = elementName;
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName

{
    NSLog(@"=======end element:%@=========", elementName);
    if ([elementName isEqualToString:@"soft"])
    {
        //not current app
        NSString* currentAppName = NSLocalizedString(@"Title", "");
        if (![_softInfo.name isEqualToString:currentAppName]) {
            [softList addObject:_softInfo];
        }        
        [_softInfo release];
        _softInfo  = nil;
    }
    self.elmName = @"";
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSLog(@"=======element content=%@=====", string);
    
    if([_elmName isEqualToString:@"name"]) 
    {
        _softInfo.name =  string;
    }
    else if([_elmName isEqualToString:@"detail"]) 
    {
        _softInfo.detail = string;
    }
    else if([_elmName isEqualToString:@"url"]) 
    {
        _softInfo.url = string;
    }
    else if([_elmName isEqualToString:@"icon"]) 
    {
        _softInfo.icon = string;
    }
}



@end
