//
//  MessageInterceptor.h
//  TableViewPull
//
//  From http://stackoverflow.com/questions/3498158/intercept-obj-c-delegate-messages-within-a-subclass

#import <Foundation/Foundation.h>

@interface MessageInterceptor : NSObject {
    id receiver;
    id middleMan;
}
@property (nonatomic, assign) id receiver;
@property (nonatomic, assign) id middleMan;
@end
