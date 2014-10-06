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
#import "XCiteJoinUsPopup.h"
#import "XCiteSideBarCollectionViewLayout.h"
#import "XCiteVideoPlayerViewController.h"
#import "XCitePDFViewController.h"
#import "BeaconManager.h"
#import "BeaconModel.h"


#define CELL_WIDTH 200
#define CELL_HEIGHT 185

@interface ViewController ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UIScrollViewDelegate,
XCitePlayerViewDelegate,
ESTBeaconManagerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView * sideBarCollectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *playerScrollView;
@property (strong, nonatomic) ESTBeaconManager *beaconManager;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSArray *allBeacons;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _init];
    [self setUpBeacons];
    [self setUpPlayerScrollView];
    self.navigationController.navigationBarHidden = YES;
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
    self.sideBarCollectionView.exclusiveTouch = TRUE;
}

- (void)setUpPlayerScrollView
{
    CGFloat yOffset = 0.0f;
    int tag = 100;
    for(XCiteModel *model in self.dataArray) {

        XCitePlayerView *view = [XCitePlayerView xCitePlayerViewWithModel:model withYOffet:yOffset];
        [self.playerScrollView addSubview:view];
        view.tag = tag;
        view.delegate = self;
        yOffset += view.height;
        tag++;
    }
    self.playerScrollView.contentSize = CGSizeMake(self.playerScrollView.width, self.playerScrollView.height * self.dataArray.count);
    if ((int)self.selectedIndex >= 0) {
        [self sideBarDidTapAtIndex:self.selectedIndex];
    }
}

- (void)setUpBeacons
{
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    [self.beaconManager requestAlwaysAuthorization];
    self.allBeacons = [[BeaconManager sharedInstance] getBeacons];
    for (BeaconModel *model in self.allBeacons) {
        [self startMonitoringItem:model];
    }
}


- (ESTBeaconRegion *)beaconRegionWithItem:(BeaconModel *)item {
    ESTBeaconRegion *beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:item.uuid
                                                                           major:item.majorVersion
                                                                           minor:item.minorVersion
                                                                      identifier:item.name];
    return beaconRegion;
}

- (void)startMonitoringItem:(BeaconModel *)item {
    ESTBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
    [self.beaconManager startMonitoringForRegion:beaconRegion];
    [self.beaconManager startRangingBeaconsInRegion:beaconRegion];
}

#pragma UICollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    XCiteModel *model = self.dataArray[indexPath.row];
    XCiteSideBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sidebarNib" forIndexPath:indexPath];
    if (self.selectedIndex == [indexPath row]) {
        cell.imgView.image = [UIImage imageNamed:model.onImage];
    }
    else {
        cell.imgView.image = [UIImage imageNamed:model.offImage];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.sideBarCollectionView) {
        [self sideBarDidTapAtIndex:indexPath.row];
    }
}

#pragma mark - UIScrollView Delegate

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
    else {
         self.selectedIndex =  scrollView.contentOffset.y / scrollView.height;
    }
    
    [self syncScrollViews:scrollView];
}

- (void)highlightSidebarCell
{
    CGPoint centerPoint = CGPointMake(0, self.sideBarCollectionView.contentOffset.y + self.sideBarCollectionView.bounds.size.height/2);
    
    for (NSIndexPath * indexPath in self.sideBarCollectionView.indexPathsForVisibleItems){

        XCiteSideBarCell *cell = (XCiteSideBarCell *)[self.sideBarCollectionView cellForItemAtIndexPath:indexPath];
        
        XCiteModel *model = self.dataArray[indexPath.row];
        if (CGRectContainsPoint([cell frame], centerPoint)) {
            cell.imgView.image = [UIImage imageNamed:model.onImage];
            self.selectedIndex = [indexPath row];
        }
        else {
            cell.imgView.image = [UIImage imageNamed:model.offImage];
        }
    }
}


#pragma mark - Sidebar

- (void)sideBarDidTapAtIndex: (NSUInteger)index
{
    self.sideBarCollectionView.userInteractionEnabled = NO;
    self.selectedIndex = index;
    [self.sideBarCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    [self syncScrollViews:self.sideBarCollectionView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.sideBarCollectionView.userInteractionEnabled  = YES;
    });
}

#pragma mark - XCitePlayerView Delegate

- (void)XCitePlayerView:(XCitePlayerView *)playerView openPDFAtIndex:(NSUInteger)index
{
    XCitePDFViewController *controller = [[XCitePDFViewController alloc] initWithNibName:@"XCitePDFViewController" bundle:nil];
    controller.model = self.dataArray[index - 100];
    [self.navigationController pushViewController:controller animated:TRUE];
}

- (void)XCitePlayerView:(XCitePlayerView *)playerView playVideoAtIndex:(NSUInteger)index
{
    XCiteVideoPlayerViewController *controller = [[XCiteVideoPlayerViewController alloc] initWithNibName:@"XCiteVideoPlayerViewController" bundle:nil];
    XCiteModel *model  = self.dataArray[playerView.tag - 100];
    controller.model = model;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)XCitePlayerViewDidTapOnJoinUs:(XCitePlayerView *)playerView
{
    [self showJoinUsPopup];
}

#pragma mark - Private APIs

- (void)syncScrollViews:(UIScrollView *)scrollView
{
    NSLog(@"%ld",(long)self.selectedIndex);
    if (scrollView == self.sideBarCollectionView) {
        
        [self.playerScrollView setContentOffset:CGPointMake(0,self.selectedIndex*self.playerScrollView.height) animated:true];
    }
    else {
        [self.sideBarCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:TRUE];
    }
}

- (void)showJoinUsPopup
{
    NSString *email = [[XCiteCacheManager sharedInstance] savedEmail];
    [XCiteJoinUsPopup showPopupWithEmail:email completionBlock:^(NSInteger index, XCiteJoinUsPopup *popupView) {
        
        if (index == 0) {
            [popupView dismiss];
        }
        else {
            BOOL isValid = [self validateJoinUsPopUp:popupView];
            if (isValid) {
                [self constructAndSendJoinUsRequest:popupView];
            }
        }
        
    }];
}

- (BOOL)validateJoinUsPopUp:(XCiteJoinUsPopup *)popUp
{
    if ([popUp.txtEmail.text isEmail] == NO) {
        [popUp.txtEmail shakeAnimation];
        return NO;
    }
    
    if (popUp.txtFirstName.text.length <= 0) {
        [popUp.txtFirstName shakeAnimation];
        return NO;
    }
    
    if (popUp.txtLastName.text.length <= 0) {
        [popUp.txtLastName shakeAnimation];
        return NO;
    }
    
    if (![popUp.selectedBtn isValidObject]) {
        [popUp.titleViewHolder shakeAnimation];
        return NO;
    }
    return YES;
}

- (void)constructAndSendJoinUsRequest:(XCiteJoinUsPopup *)popup
{
    NSString * firstName = popup.txtFirstName.text;
    NSString * lastName = popup.txtLastName.text;
    NSString * title = popup.selectedBtn.titleLabel.text;
    
    NSString *fullName = [NSString stringWithFormat:@"%@.%@ %@",title, lastName, firstName];
    NSString * email = popup.txtEmail.text;
    
    [[XCiteNetworkManager sharedInstance] subscribeUserWithEmail:email name:fullName];
    
}
#pragma mark - Beacon Helper Methods

-(void)checkForBeaconPermission
{
    if ([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        [self.beaconManager requestAlwaysAuthorization];
    }
    else if([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)
    {
        [self startRangingAllBeacons];
    }
    else if([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Access Denied"
                                                        message:@"You have denied access to location services. Change this in app settings."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        
        [alert show];
    }
    else if([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusRestricted)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Not Available"
                                                        message:@"You have no access to location services."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        
        [alert show];
    }
}

- (void)startRangingAllBeacons
{
    
}

#pragma mark - ESTBeaconManagerDelegate methods

- (void)beaconManager:(ESTBeaconManager *)manager didDiscoverBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    
}

- (void)beaconManager:(ESTBeaconManager *)manager didStartMonitoringForRegion:(ESTBeaconRegion *)region
{
    
}
@end
