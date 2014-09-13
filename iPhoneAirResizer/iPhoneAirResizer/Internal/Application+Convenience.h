#import <Foundation/Foundation.h>

void dispatch_after_m(NSTimeInterval delay,dispatch_block_t block);
void dispatch_after_c(NSTimeInterval delay,dispatch_block_t block);
void dispatch_after_g(NSTimeInterval delay,dispatch_block_t block);
void dispatch_after_q(NSTimeInterval delay,dispatch_queue_t queue,dispatch_block_t block);

void dispatch_sync_m(dispatch_block_t block);
void dispatch_sync_g(dispatch_block_t block);
void dispatch_async_m(dispatch_block_t block);
void dispatch_async_g(dispatch_block_t block);

@interface NSUserDefaults (NSUserDefaultsSubscripts)
- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)object forKeyedSubscript:(NSString *)key;
@end

void msleep(int ms);

typedef void(^voidBlock)(void);
typedef void(^boolBlock)(BOOL);
