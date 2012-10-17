//
//  XmlReader.m
//  HappyLife
//
//  Created by ramonqlee on 10/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XmlIndexer.h"
#import "XPathQuery.h"//another xml parser wrapper
const NSUInteger KSegCount = 6;//default segcount

@implementation XmlIndexer

//TODO::moved to data dir for http update
- (id)initWithResource:(NSString *)fileName
//:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath
{
    if(self == [super init])
    {
        xmlPerSegElementNumber = KSegCount;
        // /Users/ramonqlee/Desktop/Projects/IUReader/Classes/XmlIndexer.mLoad the data.
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"xml"];
        NSData* responseData = [[NSData alloc] initWithContentsOfFile:dataPath];
        NSString *xpathQueryString = @"//books/book/*";
        self.data = (NSArray*)PerformXMLXPathQuery(responseData, xpathQueryString);
        [responseData release];
        xmlPerSegElementNumber = [XmlModelBase getPerSegElementNumber:self.data];
        
        NSLog(@"retainCount of XmlIndex data:%d",[self.data retainCount]);
        
        //claim ownership for subojects in the array
        [self retainAllSubObjects];
    }
    return self;
}
@end
