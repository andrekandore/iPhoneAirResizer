#import "Application+Convenience.h"

@interface NSObject (Additions)
@end

@implementation NSObject (Additions)

void dispatch_after_c(NSTimeInterval delay,dispatch_block_t block) {
	dispatch_after_q(delay, dispatch_get_current_queue(), block);
}

void dispatch_after_g(NSTimeInterval delay,dispatch_block_t block) {
	dispatch_after_q(delay, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

void dispatch_after_m(NSTimeInterval delay,dispatch_block_t block) {
	dispatch_after_q(delay, dispatch_get_main_queue(), block);
}

void dispatch_after_q(NSTimeInterval delay,dispatch_queue_t queue,dispatch_block_t block) {
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), queue, block);
}


void dispatch_sync_m(dispatch_block_t block) {
	dispatch_queue_t queueToSyncWith = dispatch_get_main_queue();
	if (!NSThread.isMainThread) {
		dispatch_sync(queueToSyncWith, block);
	} else {
		block();
	}
}

void dispatch_sync_g(dispatch_block_t block) {
	dispatch_queue_t queueToSyncWith = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
		dispatch_sync(queueToSyncWith, block);
}

void dispatch_async_g(dispatch_block_t block) {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

void dispatch_async_m(dispatch_block_t block) {
	dispatch_async(dispatch_get_main_queue(), block);
}

void msleep(int ms) {
	struct timespec time;
	time.tv_sec = 1000 / ms;
	time.tv_nsec = (1000 % ms) * (1000 * 1000);
	nanosleep(&time,NULL);
}

@end

@implementation NSUserDefaults (subscripts)
- (id)objectForKeyedSubscript:(id)key {
	return [self objectForKey:key];
}

- (void)setObject:(id)object forKeyedSubscript:(NSString *)key {
	[self setObject:object forKey:key];
}
@end