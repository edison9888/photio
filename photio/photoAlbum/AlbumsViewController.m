//
//  AlbumsViewController.m
//  photio
//
//  Created by Troy Stribling on 7/15/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "AlbumsViewController.h"
#import "ViewGeneral.h"
#import "Album.h"
#import "AlbumManager.h"
#import "Capture.h"
#import "ImageThumbnail.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AlbumsViewController (PrivateAPI)

- (NSMutableArray*)addAlbums;
- (NSMutableArray*)addAlbum:(Album*)_album;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AlbumsViewController

@synthesize containerView, dragGridView, imagesPerAlbum; 

#pragma mark -
#pragma mark AlbumsViewController PrivateAPI

- (NSMutableArray*)addAlbums {
    NSArray* albums = [AlbumManager albums];
    NSMutableArray* allAlbumViews = [NSMutableArray arrayWithCapacity:[albums count]];
    for (Album* album in albums) {
        [allAlbumViews addObject:[self addAlbum:album]];
    }
    return allAlbumViews;
}

- (NSMutableArray*)addAlbum:(Album*)_album {
    NSMutableArray* albumViews = [NSMutableArray arrayWithCapacity:self.imagesPerAlbum];
    NSArray* captures = [AlbumManager fetchCapturesForAlbum:_album withLimit:self.imagesPerAlbum];
    for (Capture* capture in captures) {
        UIImage* thumbnail = capture.thumbnail.image;
        [albumViews addObject:[[UIImageView alloc] initWithImage:thumbnail]];
    }
    return albumViews;
}


#pragma mark -
#pragma mark AlbumsViewController

+ (id)inView:(UIView *)_containerView {
    return [[AlbumsViewController alloc] initWithNibName:@"AlbumsViewController" bundle:Nil inView:_containerView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView *)_containerView {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.containerView = _containerView;
        self.imagesPerAlbum = THUMBNAILS_IN_ROW;
    }
    return self;
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dragGridView = [DragGridView withFrame:self.view.frame delegate:self rows:[self addAlbums] andRelativeView:self.containerView];
    [self.view addSubview:self.dragGridView];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark DragGridViewDelegate

- (void)didDragRight:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [[ViewGeneral instance] dragAlbums:_drag];
}

- (void)didDragLeft:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [[ViewGeneral instance] dragAlbums:_drag];
}

- (void)didReleaseRight:(CGPoint)_location {
    [[ViewGeneral instance] releaseAlbums];
}

- (void)didReleaseLeft:(CGPoint)_location {
    [[ViewGeneral instance] releaseAlbums];
}

- (void)didSwipeRight:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [[ViewGeneral instance] transitionAlbumsToCamera];
}

- (void)didSwipeLeft:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [[ViewGeneral instance] releaseAlbums];
}

- (void)didReachMaxDragRight:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [[ViewGeneral instance] transitionAlbumsToCamera];    
}

- (void)didReachMaxDragLeft:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [[ViewGeneral instance] releaseAlbums];
}

@end
