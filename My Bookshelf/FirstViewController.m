//
//  FirstViewController.m
//  My Bookshelf
//
//  Created by Milind on 11/3/19.
//  Copyright © 2019 Milind Mahajan. All rights reserved.
//

#import "FirstViewController.h"
#import "ConnectionHelper.h"
#import "Book.h"
#import "BookDetailViewController.h"
#import "BooksTableViewCell.h"
#import "AppSetting.h"

@interface FirstViewController () <UITableViewDelegate, UITableViewDataSource, BookDetailViewControllerProtocol, UISearchBarDelegate, UITextFieldDelegate, UIScrollViewDelegate>

@property NSMutableArray *booklist;
@property NSIndexPath *selectedIndexPath;
@property NSString *searchQuery;

@end

@implementation FirstViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	_activityIndicator.center = self.view.center;

	if ([[AppSetting sharedSetting] selectedMode] == kNewMode) {
		[self addRefreshControl];
		[self getBookList];
	} else {
		UISearchBar *searchBar = [[UISearchBar alloc] init];
		searchBar.searchBarStyle = UISearchBarStyleProminent;
		searchBar.delegate = self;
		searchBar.searchTextField.delegate = self;
		searchBar.placeholder = @"Search";
		[searchBar sizeToFit];
		searchBar.translucent = true;
		searchBar.showsCancelButton = true;

		self.navigationItem.titleView = searchBar;
		[searchBar becomeFirstResponder];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	__weak __typeof__(self) weakSelf = self;
	[[NSNotificationCenter defaultCenter] addObserverForName:@"InterfaceOrientationChanged" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
		[weakSelf orientationChanged];
	}];

	[self orientationChanged];
	if (self.selectedIndexPath) {
			[self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:animated];
	}
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)orientationChanged {
	[self.tableView reloadData];
	_activityIndicator.center = self.view.center;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

	if ([segue.identifier isEqualToString:@"ShowBookDetailSegue"]) {
		BookDetailViewController *bookDetailVC = segue.destinationViewController;
		bookDetailVC.delegate = self;
		bookDetailVC.book = [self.booklist objectAtIndex:self.selectedIndexPath.row];
	}
}

- (void)addRefreshControl {
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
	[refreshControl addTarget:self action:@selector(refreshBookList:) forControlEvents:UIControlEventValueChanged];
	[self.tableView addSubview:refreshControl];
}

- (void)refreshBookList:(UIRefreshControl *)refreshControl {
    [self getBookList];
    [refreshControl endRefreshing];
}

- (void)getBookList {
	[_activityIndicator startAnimating];

	__weak __typeof__(self) weakSelf = self;
	[ConnectionHelper getBookList:^(NSArray * _Nullable booklist) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if (weakSelf.booklist) {
				[weakSelf.booklist removeAllObjects];
				[weakSelf.booklist addObjectsFromArray:booklist];
			} else {
				weakSelf.booklist = booklist.mutableCopy;
			}
			[weakSelf.tableView reloadData];
			[weakSelf.activityIndicator stopAnimating];
		});
	}];
}

- (void)searchBooklistWithPageNumber:(int)page {
	if (!self.searchQuery) {
		return;
	}

	__weak __typeof__(self) weakSelf = self;
	[_activityIndicator startAnimating];
	[ConnectionHelper searchBookList:self.searchQuery pageNumber:page onCompletion:^(NSArray * _Nullable booklist) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if (weakSelf.booklist) {
				[weakSelf.booklist addObjectsFromArray:booklist];
			} else {
				weakSelf.booklist = booklist.mutableCopy;
			}
			[weakSelf.activityIndicator stopAnimating];
			[weakSelf.tableView reloadData];
		});
	}];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.booklist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	BooksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BooksTableViewCell"];

	Book *book = [self.booklist objectAtIndex:indexPath.row];
	cell.book = book;

	return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	if ([[AppSetting sharedSetting] selectedMode] == kSearchMode) {
		NSIndexPath *indexPath = [[self.tableView indexPathsForVisibleRows] lastObject];
		if (self.booklist.count >= 10 && indexPath.row == self.booklist.count-1) {
			int pageNumber = (int)self.booklist.count/10;
			[self searchBooklistWithPageNumber:pageNumber+1];
			NSLog(@"fetch more");
		}
	}
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	self.selectedIndexPath = indexPath;
	[self performSegueWithIdentifier:@"ShowBookDetailSegue" sender:nil];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	if (![searchBar.text isEqualToString:self.searchQuery]) {
		[self.booklist removeAllObjects];
		[self.tableView reloadData];
	}

	[searchBar resignFirstResponder];

	if (self.searchQuery) {
		self.searchQuery = nil;
	}
	self.searchQuery = searchBar.text;
	[self searchBooklistWithPageNumber:1];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
	if (self.searchQuery) {
		self.searchQuery = nil;
	}
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
	if (self.searchQuery) {
		self.searchQuery = nil;
	}

	if ([[AppSetting sharedSetting] selectedMode] == kSearchMode) {
		[self.booklist removeAllObjects];
		[self.tableView reloadData];
	}

	return true;
}

#pragma mark - BookDetailViewControllerProtocol

- (Book *)getNext {
	if (self.selectedIndexPath.row < self.booklist.count-1) {
		self.selectedIndexPath = [NSIndexPath indexPathForRow:self.selectedIndexPath.row+1 inSection:self.selectedIndexPath.section];
		[self.tableView selectRowAtIndexPath:self.selectedIndexPath animated:false scrollPosition:UITableViewScrollPositionMiddle];
		return [self.booklist objectAtIndex:self.selectedIndexPath.row];
	}

	return nil;
}

- (Book *)getPrevious {
	if (self.selectedIndexPath.row > 0) {
		self.selectedIndexPath = [NSIndexPath indexPathForRow:self.selectedIndexPath.row-1 inSection:self.selectedIndexPath.section];
		[self.tableView selectRowAtIndexPath:self.selectedIndexPath animated:false scrollPosition:UITableViewScrollPositionMiddle];
		return [self.booklist objectAtIndex:self.selectedIndexPath.row];
	}

	return nil;
}

@end
