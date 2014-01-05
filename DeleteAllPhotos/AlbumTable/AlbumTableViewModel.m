//
// Created by azu on 2014/01/05.
//


#import <AssetsLibrary/AssetsLibrary.h>
#import "AlbumTableViewModel.h"


@interface AlbumTableViewModel ()
@property(nonatomic, strong) NSMutableArray *groups;
@end

@implementation AlbumTableViewModel {
    ALAssetsLibrary *library;
}

- (id)init {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    return self;
}

- (void)reloadGroups:(void (^)()) complete {
    self.groups = [NSMutableArray array];
    library = [[ALAssetsLibrary alloc] init];
    // アルバム情報の取得
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
             usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                 if (group) {
                     [self.groups addObject:group];
                 } else {
                     // complete
                     complete();
                 }
             }
             failureBlock:^(NSError *error) {
                 NSLog(@"Error:%@", error);
             }];
}

- (NSInteger)numberOfData {
    return [self.groups count];
}

- (ALAssetsGroup *)groupAtIndexPath:(NSIndexPath *) path {
    return [self.groups objectAtIndex:(NSUInteger)path.row];
}

- (void)deleteAllPhotoAtIndex:(NSIndexPath *) path callback:(void (^)()) callback {
    SEL deleteSelector = NSSelectorFromString(@"deleteAssetForURL:completionBlock:");
    ALAssetsGroup *group = [self groupAtIndexPath:path];
    void (^completeBlock)(NSURL *, NSError *) = ^(NSURL *assetURL, NSError *error) {
        if (error) {
            NSLog(@"error = %@", error);
        }
    };

    //assetsEnumerationBlock
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            id url  = [result valueForProperty:ALAssetPropertyAssetURL];
            [library performSelector:deleteSelector withObject:url withObject:completeBlock];
        }else{
            callback();
        }
    };

    //アルバム(group)からALAssetの取得       
    [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
}
@end