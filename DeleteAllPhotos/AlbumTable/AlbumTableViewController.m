//
// Created by azu on 2014/01/05.
//


#import <AssetsLibrary/AssetsLibrary.h>
#import "AlbumTableViewController.h"
#import "AlbumTableViewModel.h"


@interface AlbumTableViewController ()
@property(nonatomic, strong) AlbumTableViewModel *model;
@end

@implementation AlbumTableViewController
- (AlbumTableViewModel *)model {
    if (_model == nil) {
        _model = [[AlbumTableViewModel alloc] init];
    }
    return _model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadTableView];
}

- (void)reloadTableView {
    [self.model reloadGroups:^{
        [self.tableView reloadData];
    }];
}


- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return [self.model numberOfData];
}

- (void)configureCell:(UITableViewCell *) cell atIndex:(NSIndexPath *) indexPath {
    ALAssetsGroup *group = [self.model groupAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageWithCGImage:group.posterImage];
    cell.textLabel.text = [group valueForProperty:ALAssetsGroupPropertyName];
}

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    [self configureCell:cell atIndex:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *) tableView canEditRowAtIndexPath:(NSIndexPath *) indexPath {
    return YES;
}

- (void)tableView:(UITableView *) tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *) indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.model deleteAllPhotoAtIndex:indexPath callback:^{
            [self reloadTableView];
        }];
    }
}


@end