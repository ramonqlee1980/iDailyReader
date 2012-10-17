//
//  XmlReader.m
//  HappyLife
//
//  Created by ramonqlee on 10/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XmlSpec.h"
#import "XPathQuery.h"//another xml parser wrapper
const NSUInteger KSegCountData = 2;

@implementation XmlSpec

//TODO::moved to data dir for http update
- (id)initWithResource:(NSString *)fileName
//:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath
{
    xmlPerSegElementNumber = KSegCountData;
    if(self == [super init])
    {
        // Load the data.
        NSString* file = fileName;
        NSRange range=[fileName rangeOfString:@"."];
        if (1 == range.length) {
            file = [fileName substringToIndex:range.location];
        }        
        
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:file ofType:@"xml"];
        NSData* responseData = [[NSData alloc] initWithContentsOfFile:dataPath];
        NSString *xpathQueryString = @"//channel/item/*";
        self.data = (NSArray*)PerformXMLXPathQuery(responseData, xpathQueryString);
        [responseData release];
        xmlPerSegElementNumber = [XmlModelBase getPerSegElementNumber:self.data];
        NSLog(@"retainCount of XmlSpec data:%d",[self.data retainCount]);
        [self retainAllSubObjects];
    }
    return self;
}
@end
