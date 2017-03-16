//
//  GGSelectionMenuViewController.m
//  GGSimpleTest
//
//  Created by VietHQ on 12/27/16.
//  Copyright © 2016 viethq. All rights reserved.
//

#import "GGSelectionMenuViewController.h"
#import "GGSelectionViewCell.h"

static const CGFloat kPadding = 10.0f;
static NSString* const kTextColor       = @"kSelectionColor";
static NSString* const kFont    = @"kFont";
static NSString* const kBgCellColor     = @"kBgCellColor";

@interface GGSelectionMenuViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray<NSString*> *titles;
@property (strong, nonatomic) NSMutableDictionary<NSString*,id> *infoDict;
@property (strong, nonatomic) UIView *lineView;
@property (assign, nonatomic) NSInteger currentIdx;

@end

@implementation GGSelectionMenuViewController

#pragma mark - Init
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self)
    {
        self.infoDict = [[NSMutableDictionary alloc] initWithCapacity:20];
        
        self.currentIdx = 0;
        
        [self setDefaultInfoDict];
    }
    
    return self;
}


#pragma mark - View life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self settingCollectionView];
    
    [self settingLineView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark - Layout
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (self.lineView)
    {
        CGRect f = self.lineView.frame;
        f.origin.y = CGRectGetMaxY(self.collectionView.frame) - CGRectGetHeight(self.lineView.frame);
        
        self.lineView.frame = f;
    }
}

#pragma mark - Public method
- (void)setSelectionTitle:(NSArray<NSString*>*)titles
{
    self.titles = [titles copy];
    
    [self.collectionView reloadData];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    [self updateLineViewPosition];
}

- (void)setTextColor:(UIColor*)color
{
    self.infoDict[kTextColor] = color;
    
    [self.collectionView reloadData];
}

- (void)setBgColor:(UIColor* _Nonnull)color
{
    self.collectionView.backgroundColor = color;
}

- (void)setBgCellColor:(UIColor* _Nonnull)color
{
    self.infoDict[kBgCellColor] = color;
    
    [self.collectionView reloadData];
}

- (void)selectedItemAtIdx:(NSUInteger)idx
{
    if (idx >= self.titles.count)
    {
        return;
    }
    
    [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:idx
                                                                                         inSection:0]];
}

#pragma mark - Private method
- (void)settingCollectionView
{
    UICollectionViewFlowLayout *pLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    pLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    pLayout.minimumLineSpacing = 0.0f;
    pLayout.minimumInteritemSpacing = 0.5f;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GGSelectionViewCell class])
                                                    bundle:nil]
          forCellWithReuseIdentifier:NSStringFromClass([GGSelectionViewCell class])];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView setAlwaysBounceHorizontal:YES];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor grayColor];
}

- (void)settingLineView
{
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.view.frame) - 4.0f, 100.0f, 4.0f)];
    
    self.lineView.backgroundColor = [UIColor blueColor];
    
    [self.collectionView addSubview:self.lineView];
}

- (void)setDefaultInfoDict
{
    self.infoDict[kFont] = [UIFont systemFontOfSize:14.0f];
    self.infoDict[kTextColor] = [UIColor blackColor];
    self.infoDict[kBgCellColor] = [UIColor whiteColor];
}

- (CGSize)sizeForCellAtIdx:(NSInteger)idx
{
    NSString *pTitle = self.titles[idx];
    
    CGSize s = [pTitle sizeWithAttributes:@{ NSFontAttributeName : self.infoDict[kFont]}];
    
    return CGSizeMake(s.width + kPadding, self.collectionView.frame.size.height);
}

- (CGRect)updateLineViewPosition
{
    GGSelectionViewCell *pCell = [self collectionView:self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIdx inSection:0]];
    
    CGRect f = self.lineView.frame;
    f.size.width = [self sizeForCellAtIdx:self.currentIdx].width;
    f.origin.x = CGRectGetMinX(pCell.frame);
    self.lineView.frame = f;
    
    return f;
}

- (NSTimeInterval)getLineViewDuration
{
    return 0.2f;
}

#pragma mark - CollectionView delegate & datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self sizeForCellAtIdx:indexPath.row];
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    GGSelectionViewCell *pCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GGSelectionViewCell class]) forIndexPath:indexPath];
    
    // attribute
    pCell.backgroundColor = self.infoDict[kBgCellColor];
    pCell.titleLabel.font = self.infoDict[kFont];
    
    // text
    pCell.titleLabel.text = self.titles[indexPath.row];
   
    return pCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    self.currentIdx = indexPath.row;
    
    [UIView animateWithDuration:[self getLineViewDuration] animations:^{
        [self updateLineViewPosition];
    } completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(selectionMenuViewController:didSelectedItemAtIdx:)])
    {
        [self.delegate selectionMenuViewController:self
                              didSelectedItemAtIdx:self.currentIdx];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"did end decelerating offset");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"did end drag");
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //NSLog(@"did end anim offset");
}

@end
