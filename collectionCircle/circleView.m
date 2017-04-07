//
//  circleView.m
//  collectionCircle
//
//  Created by smc on 2017/4/7.
//  Copyright © 2017年 SMC. All rights reserved.
//

#import "circleView.h"
#import "collectionCell.h"

#define Width self.frame.size.width
#define height self.frame.size.height
@interface circleView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *datas;
@property(nonatomic, strong) UIPageControl *pagecontrol;
@property(nonatomic, weak) NSTimer *scrollTimer;
@property(nonatomic, assign) NSInteger currentIndex;
@end
@implementation circleView

static NSString *cellIden = @"cell";

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        [self setUi];
    }
    return self;
}

-(void)setAutoCircle:(BOOL)autoCircle{
   
    _autoCircle = autoCircle;
    if (_autoCircle) {
        [self startTimer];
    }

}

-(void)setUi{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake( [UIScreen mainScreen].bounds.size.width, 190);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"collectionCell" bundle:nil] forCellWithReuseIdentifier:cellIden];
    self.backgroundColor = [UIColor whiteColor];
    self.collectionView.pagingEnabled = YES;
    self.datas =@[].mutableCopy;
    for (int i=1; i<7; i++) {
        [self.datas addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    [self.datas insertObject:@"6" atIndex:0];
    [self.datas addObject:@"1"];
    [self.collectionView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width, 0)];
    [self addSubview:self.collectionView];
    
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width ,30)];
    pageControl.numberOfPages = self.datas.count-2;
    pageControl.pageIndicatorTintColor = [UIColor blueColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self addSubview:pageControl];
    self.pagecontrol = pageControl;
    
    self.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark - collectionViewdataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.datas.count;
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    collectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIden forIndexPath:indexPath];
    cell.contentImage.image = [UIImage imageNamed:self.datas[indexPath.item]];
    
    return cell;
    
}
#pragma mark - collectionViewdelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    
    [[self viewController] presentViewController:vc animated:YES completion:nil];

}

#pragma mark - scrollviewDelegate
//人为拖动 滚动视图减速完成，滚动将停止时，调用该方法。一次有效滑动，只执行一次。
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
      [self startTimer];
    NSLog(@"scrollViewDidEndDecelerating");
    [self adjustPageWithScrollView:scrollView];
}
// 当滚动视图动画完成后，调用该方法，如果没有动画，那么该方法将不被调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
     NSLog(@"scrollViewDidEndScrollingAnimation");//非人为拖动
    [self adjustPageWithScrollView:scrollView];
    

}
// 滑动视图，当手指离开屏幕那一霎那，调用该方法。一次有效滑动，只执行一次。
// decelerate,指代，当我们手指离开那一瞬后，视图是否还将继续向前滚动（一段距离），经过测试，decelerate=YES
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    

    [self adjustPageWithScrollView:scrollView];
    
}
// 人为拽
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
  NSLog(@"scrollViewWillBeginDragging");
    [self stopTimer];
}
#pragma mark - timer
-(void)stopTimer{

    [self.scrollTimer invalidate];
    self.scrollTimer = nil;

}

-(void)startTimer{

    if (!self.scrollTimer&&self.autoCircle) {
        self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    }
   
}

-(void)nextPage{

    _currentIndex = self.collectionView.contentOffset.x/self.bounds.size.width;
    _currentIndex++;
    if (_currentIndex>=self.datas.count) {
        [self.collectionView setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO];
    }
    else{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_currentIndex inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
   
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    //只要scrollview的offset 发生变化都会调用此方法
    NSInteger index = scrollView.contentOffset.x / ([UIScreen mainScreen].bounds.size.width);
    
    if (index==self.datas.count) {
        self.pagecontrol.currentPage = 0;
    }
    else if (index==0){
        self.pagecontrol.currentPage = self.datas.count-1;
    }
    else{
        
        self.pagecontrol.currentPage = index-1;
    }
    _currentIndex = index;
}

- (void)adjustPageWithScrollView:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / ([UIScreen mainScreen].bounds.size.width);
    
    NSLog(@"offset:%lf",scrollView.contentOffset.x);
    if (index == 0) {
        [scrollView setContentOffset:CGPointMake((_datas.count - 2) * ([UIScreen mainScreen].bounds.size.width)+scrollView.contentOffset.x, 0) animated:NO];
        
    } else if (index == _datas.count - 1) {
        [scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO];
        
    } else {
        
    }
}
// 获取父类控制器
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

-(void)dealloc{

    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
}

@end
