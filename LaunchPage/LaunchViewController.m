//
//  LaunchViewController.m
//  LaunchPage
//
//  Created by Dylan Sewell on 8/22/14.
//  Copyright (c) 2014 DeepLinks. All rights reserved.
//

#import "LaunchViewController.h"
#import "imgCollectionViewCell.h"

@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    pageTouched = NO;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    layout.minimumInteritemSpacing = 0.0f;
    layout.minimumLineSpacing = 0.0f;
    layout.itemSize = self.view.frame.size;
    
    myCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [myCollectionView registerClass:[imgCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    myCollectionView.pagingEnabled = YES;
    
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    myCollectionView.scrollEnabled = YES;
    
    myCollectionView.backgroundColor = [UIColor clearColor];
    
    
    launchBackgroundImgs = @[@"terrace.jpg",@"friendsy2a.jpg",@"friendsy1a.jpg", @"friendsy3a.jpg"];
    
    launchImgs = @[@"launch-screen-0@2x.png", @"launch-screen-1@2x.png", @"launch-screen-2@2x.png", @"launch-screen-3@2x.png"];
    
    //NSLog(@"loaded imgs");
    
    // set up the page control
    CGFloat width = self.view.frame.size.width;
    
    CGRect frame = CGRectMake(0, 500, width, 10);
    pageControl = [[UIPageControl alloc]
                   initWithFrame:frame
                   ];
    
    // Set the number of pages to the number of pages in the paged interface
    // and let the height flex so that it sits nicely in its frame
    pageControl.numberOfPages = [launchImgs count];
    pageControl.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    pageControl.hidesForSinglePage = YES;
    
    index = 0;
    
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(scrollTo)
                                   userInfo:nil
                                    repeats:YES];
    
    prevAlpha = 0.0f;
    currentAlpha = 1.0f;
    nextAlpha = 0.0f;
    
    
    
    backgroundImgPrev = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    backgroundImgPrev.image = nil;
    backgroundImgPrev.alpha = prevAlpha;
    
    backgroundImgCurrent = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    backgroundImgCurrent.image = [UIImage imageNamed:launchBackgroundImgs[index]];
    backgroundImgCurrent.alpha = currentAlpha;
    
    backgroundImgNext = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    backgroundImgNext.image = [UIImage imageNamed:launchBackgroundImgs[index + 1]];
    backgroundImgNext.alpha = nextAlpha;
    
    
    friendsyLogo = [[UIImageView alloc]initWithFrame:CGRectMake(85, 20, 150, 100)];
    friendsyLogo.image = [UIImage imageNamed:@"launch-screen-logo@2x.png"];
    
//    btnSignUp = [[UIButton alloc]
//                 initWithFrame:CGRectMake(55, 505, 100, 30)];
//    btnSignIn = [[UIButton alloc]initWithFrame:CGRectMake(265, 505, 100, 30)];
//
    
    btnSignUp = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSignIn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnSignUp.frame = CGRectMake(45, 525, 100, 30);
    btnSignIn.frame = CGRectMake(175, 525, 100, 30);
    
    btnSignUp.layer.cornerRadius = 3.0f;
    btnSignUp.layer.masksToBounds = YES;
    
    btnSignIn.layer.cornerRadius = 3.0f;
    btnSignIn.layer.masksToBounds = YES;
    
    [btnSignUp setBackgroundImage:[UIImage imageNamed:@"sign-up@2x.png"]forState:UIControlStateNormal];
    
     [btnSignIn setBackgroundImage:[UIImage imageNamed:@"sign-in@2x.png"]forState:UIControlStateNormal];
    

    [self.view addSubview:backgroundImgPrev];
    [self.view addSubview:backgroundImgCurrent];
    [self.view addSubview:backgroundImgNext];
    
    
    [self.view addSubview:myCollectionView];
    
    [self.view addSubview:pageControl];
    
    [self.view addSubview:friendsyLogo];
    [self.view addSubview:btnSignUp];
    [self.view addSubview:btnSignIn];
   }

-(void)scrollTo
{
    if (!pageTouched) {
        index = pageControl.currentPage;
        if (index >= 3) {
            index = -1;
            NSLog(@"here");
        }
        
        index++;
        CGFloat pageWidth = myCollectionView.frame.size.width;
        CGPoint scrollTo = CGPointMake(pageWidth * index, 0);
        if (index != 0)
            [myCollectionView setContentOffset:scrollTo animated:YES];
        else
            [myCollectionView setContentOffset:scrollTo animated:NO];
        
        pageControl.currentPage = index;
        
        [self setBackgroundImage];
        //NSLog(@"Not touched");
        //NSLog(@"scrolled to page:%ld", (long)pageControl.currentPage);
        

    }
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [launchImgs count];
}


- (imgCollectionViewCell *)collectionView:(UICollectionView *)CollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    imgCollectionViewCell *cell = [CollectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    
    [cell setImage:launchImgs[indexPath.row]];
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //only iphone 5 right now, fix for iphone 4 later
    //NSLog(@"new cell");
    return CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
}


- (void)pageControlChanged:(id)sender
{
    UIPageControl *page = sender;
    CGFloat pageWidth = myCollectionView.frame.size.width;
    CGPoint scrollTo = CGPointMake(pageWidth * page.currentPage, 0);
    [myCollectionView setContentOffset:scrollTo animated:YES];
   
   
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = myCollectionView.frame.size.width;
    pageControl.currentPage = myCollectionView.contentOffset.x / pageWidth;
    pageTouched = YES;
    index = pageControl.currentPage;
    
    prevAlpha = 0.0f;
    currentAlpha = 1.0f;
    nextAlpha = 0.0f;
    NSLog(@"end scroll");
    
    NSLog(@"DUN DUN - prevAlpha: %f", prevAlpha);
    NSLog(@"DUN DUN - currentAlpha: %f", currentAlpha);
    NSLog(@"DUN DUN - nextAlpha: %f", nextAlpha);
    NSLog(@"index pls: %ld", (long)index);
    
    [self setBackgroundImage];
    
    backgroundImgPrev.alpha = prevAlpha;
    backgroundImgCurrent.alpha = currentAlpha;
    backgroundImgNext.alpha = nextAlpha;

    }


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)setBackgroundImage
{
//    backgroundImg
//    NSLog(@"new image, index: %ld", (long)index);
   // NSLog(@"new image, index: %ld", (long)index);
//    
    if (index < 3 && index > 0) {
        backgroundImgPrev.image = [UIImage imageNamed:launchBackgroundImgs[index - 1]];
        backgroundImgCurrent.image = [UIImage imageNamed:launchBackgroundImgs[index]];
        backgroundImgNext.image = [UIImage imageNamed:launchBackgroundImgs[index+1]];
    }
    else if (index == 0) {
        backgroundImgPrev.image = nil;
        backgroundImgCurrent.image = [UIImage imageNamed:launchBackgroundImgs[index]];
        backgroundImgNext.image = [UIImage imageNamed:launchBackgroundImgs[index+1]];
    }
    else {
        backgroundImgPrev.image = [UIImage imageNamed:launchBackgroundImgs[index - 1]];
        backgroundImgCurrent.image = [UIImage imageNamed:launchBackgroundImgs[index]];
        backgroundImgNext.image = nil;
    
    }
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView

{
   // NSLog(@"HELLO");
   // NSLog(@"le index: %ld", (long)index);
    
    //Going left
    
    if (myCollectionView.contentOffset.x < (myCollectionView.frame.size.width *index)) {
        
        prevAlpha = 0.5 + ((myCollectionView.frame.size.width * index) - myCollectionView.contentOffset.x)/(myCollectionView.frame.size.width);
        
        currentAlpha =  1 - (fabsf(myCollectionView.frame.size.width * index - myCollectionView.contentOffset.x ))/(myCollectionView.frame.size.width);
        nextAlpha = (myCollectionView.contentOffset.x - (myCollectionView.frame.size.width * index))/(myCollectionView.frame.size.width);
        NSLog(@"going left");
        
    }
    //going right
    else
    {
        
        prevAlpha = ((myCollectionView.frame.size.width * index) - myCollectionView.contentOffset.x)/(myCollectionView.frame.size.width);
        
        currentAlpha =  1 - (fabsf(myCollectionView.frame.size.width * index - myCollectionView.contentOffset.x ))/(myCollectionView.frame.size.width);
        nextAlpha = 0.25  + (myCollectionView.contentOffset.x - (myCollectionView.frame.size.width * index))/(myCollectionView.frame.size.width);
        NSLog(@"going right");
    }
    
    
    
    
    
    
    
    
    NSLog(@"newPrevAlpa: %f", prevAlpha);
    NSLog(@"newCurrentAlpha: %f", currentAlpha);
    NSLog(@"newNextAlpha: %f", nextAlpha);
    
    
    backgroundImgPrev.alpha = prevAlpha;
    backgroundImgCurrent.alpha = currentAlpha;
    backgroundImgNext.alpha = nextAlpha;
    
}











@end