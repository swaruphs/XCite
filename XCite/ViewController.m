//
//  ViewController.m
//  XCite
//
//  Created by Swarup on 24/9/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "ViewController.h"
#import "XCiteSideBarCell.h"
#import "XCitePlayerView.h"
#import "XCiteSideBarCollectionViewLayout.h"


#define CELL_WIDTH 200
#define CELL_HEIGHT 185

@interface ViewController ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView * sideBarCollectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *playerScrollView;
@property (weak, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _init];
    [self setUpPlayerScrollView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_init
{
    UINib *cellNib = [UINib nibWithNibName:@"XCiteSideBarCell" bundle:nil];
    [self.sideBarCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"sidebarNib"];
    [self.sideBarCollectionView setCollectionViewLayout:[[XCiteSideBarCollectionViewLayout alloc] init]];
    self.sideBarCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    self.dataArray = [[DataManager sharedInstance] getAllModels];
    
}

- (void)setUpPlayerScrollView
{
    CGFloat yOffset = 0.0f;
    
    for(XCiteModel *model in self.dataArray) {

        XCitePlayerView *view = [[XCitePlayerView alloc] initWithNibName:NSStringFromClass([XCitePlayerView class])];
        view.top = yOffset;
        [self.playerScrollView addSubview:view];
        [view setUpVideoPlayerWithURL:model.videoURL];
        yOffset += view.height;
    }
    self.playerScrollView.contentSize = CGSizeMake(self.playerScrollView.width, self.playerScrollView.height * self.dataArray.count);
}



#pragma UIcollectionView 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    XCiteModel *model = self.dataArray[indexPath.row];
    XCiteSideBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sidebarNib" forIndexPath:indexPath];
    cell.imgView.image = [UIImage imageNamed:model.offImage];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.sideBarCollectionView) {
        [self sideBarDidTapAtIndex:indexPath];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.sideBarCollectionView) {
        [self highlightSidebarCell];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.sideBarCollectionView) {
        [self highlightSidebarCell];
    }
}

- (void)highlightSidebarCell
{
    CGPoint centerPoint = CGPointMake(0, self.sideBarCollectionView.contentOffset.y + self.sideBarCollectionView.bounds.size.height/2 + CELL_HEIGHT/2);
    
    for (NSIndexPath * indexPath in self.sideBarCollectionView.indexPathsForVisibleItems){

        XCiteSideBarCell *cell = (XCiteSideBarCell *)[self.sideBarCollectionView cellForItemAtIndexPath:indexPath];
        
        XCiteModel *model = self.dataArray[indexPath.row];
        if (CGRectContainsPoint([cell frame], centerPoint)) {
            cell.imgView.image = [UIImage imageNamed:model.onImage];
            self.selectedIndexPath = indexPath;
        }
        else {
            cell.imgView.image = [UIImage imageNamed:model.offImage];
        }
    }
}


#pragma mark - Sidebar

- (void)sideBarDidTapAtIndex: (NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    [self.sideBarCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
}



@end
