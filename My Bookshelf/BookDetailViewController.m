//
//  BookDetailViewController.m
//  My Bookshelf
//
//  Created by Milind on 11/5/19.
//  Copyright © 2019 Milind Mahajan. All rights reserved.
//

#import "BookDetailViewController.h"
#import "ConnectionHelper.h"
#import "BookDetails.h"
#import "BookViewerViewController.h"

@interface BookDetailViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLeadingContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopContraint;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property BookDetails *bookDetails;
@property NSMutableArray *datasource;

@end

@implementation BookDetailViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self addSwipeGestures];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	self.title = self.book.title;
	[[NSNotificationCenter defaultCenter] addObserverForName:@"InterfaceOrientationChanged" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
		[self setConstraints];
	}];
	[self getBookDetails];
	[self setConstraints];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)addSwipeGestures {
	UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(loadPrevious)];
	right.numberOfTouchesRequired = 1;
	right.direction = UISwipeGestureRecognizerDirectionRight;
	[self.view addGestureRecognizer:right];

	UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(loadNext)];
	left.numberOfTouchesRequired = 1;
	left.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.view addGestureRecognizer:left];
}

- (void)setConstraints {
	NSArray *scenes = [[[UIApplication sharedApplication] connectedScenes] allObjects];

	UIInterfaceOrientation orientation = [[scenes firstObject] interfaceOrientation];
	
	switch (orientation) {
		case UIInterfaceOrientationPortrait:
		case UIInterfaceOrientationPortraitUpsideDown: {
			if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
				self.imageViewLeadingConstraint.constant = self.view.frame.size.width/2-self.imageView.frame.size.width/2;
				self.tableViewLeadingContraint.constant = 8.0f;
				self.tableViewTopContraint.constant = 8.0f;
			} else {
				self.imageViewLeadingConstraint.constant = self.view.frame.size.width/2-self.imageView.frame.size.width/2;
			}
		}
		break;

		case UIInterfaceOrientationLandscapeLeft:
		case UIInterfaceOrientationLandscapeRight: {
			if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
				self.imageViewLeadingConstraint.constant = 0.0f;
				self.tableViewLeadingContraint.constant = self.imageView.frame.size.width;
				self.tableViewTopContraint.constant = self.tableViewTopContraint.constant- self.imageView.frame.size.height;
			} else {
				self.imageViewLeadingConstraint.constant = self.view.frame.size.width/2-self.imageView.frame.size.width/2;
			}
		}
		default:
			break;
	}
}

- (void)clean {
	self.imageView.image = nil;
}

- (void)refreshUI {
	[self clean];
	[ConnectionHelper getBookIconFromUrl:self.book.image onCompletion:^(NSData * _Nullable imageData) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.imageView setImage:[UIImage imageWithData:imageData]];
		});
	}];

	if (!self.datasource) {
		self.datasource = [NSMutableArray array];
	}
	[self.datasource removeAllObjects];

	if (self.bookDetails.title) {
		[self.datasource addObject:self.bookDetails.title];
	}
	if (self.bookDetails.subtitle) {
		[self.datasource addObject:self.bookDetails.subtitle];
	}
	if (self.bookDetails.price) {
		[self.datasource addObject:[NSString stringWithFormat:@"Price: %@", self.bookDetails.price]];
	}
	if (self.bookDetails.authors) {
		[self.datasource addObject:[NSString stringWithFormat:@"Written by: %@", self.bookDetails.authors]];
	}
	if (self.bookDetails.publisher) {
		[self.datasource addObject:[NSString stringWithFormat:@"Publisher: %@", self.bookDetails.publisher]];
	}
	if (self.bookDetails.rating) {
		[self.datasource addObject:[NSString stringWithFormat:@"Rating: %d", self.bookDetails.rating]];
	}
	if (self.bookDetails.language) {
		[self.datasource addObject:[NSString stringWithFormat:@"Language: %@", self.bookDetails.language]];
	}
	if (self.bookDetails.pages > 0) {
		[self.datasource addObject:[NSString stringWithFormat:@"Total Pages: %d", self.bookDetails.pages]];
	}
	if (self.bookDetails.year > 0) {
		[self.datasource addObject:[NSString stringWithFormat:@"Published in %d", self.bookDetails.year]];
	}
	if (self.bookDetails.desc) {
		[self.datasource addObject:[NSString stringWithFormat:@"%@ %@", self.bookDetails.desc, self.bookDetails.desc]];
	}
	[self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"ShowBookDetail"]) {
		BookViewerViewController *bookViewerVC = segue.destinationViewController;
		bookViewerVC.urlString = self.book.url;
	}
}

- (void)handleHyperlinkTap:(UITapGestureRecognizer *)tapGesture {
	[self performSegueWithIdentifier:@"ShowBookDetail" sender:nil];
}

#pragma mark - Swipe gesture handler

- (void)loadNext {
	if ([_delegate respondsToSelector:@selector(getNext)]) {
		Book *temp = [_delegate getNext];
		if (temp) {
			self.book = temp;
			[self getBookDetails];
		}
	}
}

- (void)loadPrevious {
	if ([_delegate respondsToSelector:@selector(getPrevious)]) {
		Book *temp = [_delegate getPrevious];
		if (temp) {
			self.book = temp;
			[self getBookDetails];
		}
	}
}

# pragma mark - get book
- (void)getBookDetails {

	__weak __typeof__(self) weakSelf = self;
	[ConnectionHelper getBookDetailsForBookId:self.book.isbn13 onCompletion:^(id _Nullable bookDetails) {
		dispatch_async(dispatch_get_main_queue(), ^{
			weakSelf.bookDetails = (BookDetails *)bookDetails;
			weakSelf.title = weakSelf.bookDetails.title;
			[weakSelf refreshUI];
		});
	}];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
	}

	cell.textLabel.numberOfLines = 0;
	cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
	
	if (indexPath.row == 0) {
		NSString *title = _datasource[indexPath.row];
		NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title attributes:nil];
		NSRange linkRange = NSMakeRange(0, title.length);

		NSDictionary *attributes = @{
			NSForegroundColorAttributeName: [UIColor colorWithRed:0.05 green:0.4 blue:0.65 alpha:1.0],
			NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
		};
		[attributedString setAttributes:attributes range:linkRange];

		cell.textLabel.attributedText = attributedString;
		cell.textLabel.userInteractionEnabled = true;
		[cell.textLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleHyperlinkTap:)]];
	} else {
		cell.textLabel.text = _datasource[indexPath.row];
	}
	
	return cell;
}

@end
