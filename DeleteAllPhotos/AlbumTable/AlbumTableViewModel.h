//
// Created by azu on 2014/01/05.
//


#import <Foundation/Foundation.h>


@interface AlbumTableViewModel : NSObject

- (void)reloadGroups:(void (^)()) complete;

- (NSInteger)numberOfData;
- (ALAssetsGroup *)groupAtIndexPath:(NSIndexPath *) path;

- (void)deleteAllPhotoAtIndex:(NSIndexPath *) path callback:(void (^)()) callback;
@end