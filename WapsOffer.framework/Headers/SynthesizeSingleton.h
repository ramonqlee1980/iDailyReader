#define WAPS_SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
 \
static classname *shared##classname = nil; \
 \
+ (classname *)shared##classname \
{ \
    @synchronized(self) \
    { \
        if (shared##classname == nil) \
        { \
            shared##classname = [[self alloc] init]; \
        } \
    } \
     \
    return shared##classname; \
} \
 \
+ (id)allocWithZone:(NSZone *)zone \
{ \
    @synchronized(self) \
    { \
        if (shared##classname == nil) \
        { \
            shared##classname = [super allocWithZone:zone]; \
            return shared##classname; \
        } \
    } \
     \
    return nil; \
} \
 \
- (id)copyWithZone:(NSZone *)zone \
{ \
    return self; \
} \
 \
- (id)retain \
{ \
    return self; \
} \
 \
- (NSUInteger)retainCount \
{ \
    return NSUIntegerMax; \
} \
 \
- (id)autorelease \
{ \
    return self; \
} \
\
- (oneway void)release \
{ \
\
}