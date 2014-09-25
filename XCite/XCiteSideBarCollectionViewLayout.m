//
//  XCiteSideBarCollectionViewLayout.m
//  XCite
//
//  Created by Swarup on 24/9/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "XCiteSideBarCollectionViewLayout.h"


#define CELL_WIDTH 200
#define CELL_HEIGHT 185
#define  DRAG_INTERVAL 250
@interface XCiteSideBarCollectionViewLayout()

@property (strong, nonatomic) NSMutableDictionary *layoutDic;

@end

@implementation XCiteSideBarCollectionViewLayout


- (void)prepareLayout
{
    [super prepareLayout];
    NSUInteger numOfItems = [self.collectionView numberOfItemsInSection:0];
    self.layoutDic = [NSMutableDictionary dictionary];
    int yOffset = self.collectionView.frame.size.height /2  - CELL_HEIGHT /2;
    for (int counter  = 0;  counter < numOfItems; counter++) {
    
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:counter inSection:0];
        UICollectionViewLayoutAttributes *attributes  = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectMake(0, yOffset, CELL_WIDTH, CELL_HEIGHT);
        yOffset += CELL_HEIGHT;
        [self.layoutDic setObject:attributes forKey:indexPath];
    }
}

- (CGFloat)currentCellIndex {
    return (self.collectionView.contentOffset.y / CELL_HEIGHT);
}


- (CGSize)collectionViewContentSize {
    
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    
    CGFloat height = numberOfItems * CELL_HEIGHT ;
    height += 2* (self.collectionView.frame.size.height /2  - CELL_HEIGHT /2);
    return CGSizeMake(self.collectionView.frame.size.width, height);
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    // create layouts for the rectangles in the view
    NSMutableArray *attributesInRect =  [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attributes in [self.layoutDic allValues]) {
        if(CGRectIntersectsRect(rect, attributes.frame)){
            [attributesInRect addObject:attributes];
        }
    }
    
    return attributesInRect;
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offSetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = (CGFloat) (proposedContentOffset.y + (self.collectionView.bounds.size.height / 2.0));
    
    CGRect targetRect = CGRectMake(0.0f, proposedContentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    NSArray *array = [self layoutAttributesForElementsInRect:targetRect];
    
    UICollectionViewLayoutAttributes *currentAttributes;
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in array)
    {
        if(layoutAttributes.representedElementCategory == UICollectionElementCategoryCell)
        {
            CGFloat itemHorizontalCenter = layoutAttributes.center.y;
            if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offSetAdjustment))
            {
                currentAttributes   = layoutAttributes;
                offSetAdjustment    = itemHorizontalCenter - horizontalCenter;
            }
        }
    }
    
    CGFloat nextOffset          = proposedContentOffset.y + offSetAdjustment;
    
    proposedContentOffset.y     = nextOffset;
    CGFloat deltaX              = proposedContentOffset.y - self.collectionView.contentOffset.y;
    CGFloat velX                = velocity.y;
    
    // detection form  gist.github.com/rkeniger/7687301
    // based on http://stackoverflow.com/a/14291208/740949
    if(deltaX == 0.0 || velX == 0 || (velX > 0.0 && deltaX > 0.0) || (velX < 0.0 && deltaX < 0.0)) {
        
    } else if(velocity.y > 0.0) {
        for (UICollectionViewLayoutAttributes *layoutAttributes in array)
        {
            if(layoutAttributes.representedElementCategory == UICollectionElementCategoryCell)
            {
                CGFloat itemHorizontalCenter = layoutAttributes.center.y;
                if (itemHorizontalCenter > proposedContentOffset.y) {
                    proposedContentOffset.y = nextOffset + (currentAttributes.frame.size.width / 2) + (layoutAttributes.frame.size.width / 2);
                    break;
                }
            }
        }
    } else if(velocity.y < 0.0) {
        for (UICollectionViewLayoutAttributes *layoutAttributes in array)
        {
            if(layoutAttributes.representedElementCategory == UICollectionElementCategoryCell)
            {
                CGFloat itemHorizontalCenter = layoutAttributes.center.y;
                if (itemHorizontalCenter > proposedContentOffset.x) {
                    proposedContentOffset.y = nextOffset - ((currentAttributes.frame.size.height / 2) + (layoutAttributes.frame.size.height / 2));
                    break;
                }
            }
        }
    }
    
    proposedContentOffset.x = 0.0;
    
    return proposedContentOffset;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.layoutDic[indexPath];
}

// bounds change causes prepareLayout if YES
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGFloat)flickVelocity {
    return 0.1;
}

@end
