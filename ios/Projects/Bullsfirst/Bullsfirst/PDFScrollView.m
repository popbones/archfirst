//
//  PDFScrollView.m
//  uniPresenter
//
//  Created by Pong Choa on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PDFScrollView.h"
#import "TiledPDFView.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
//#import "annotationObject.h"
//#import "annotationView.h"

@implementation PDFScrollView
@synthesize currentPage;
@synthesize totalPage;
@synthesize pdf;
@synthesize annotations;
/*
-(void) getAnnotations {
    CGPDFDictionaryRef pageDictionary = CGPDFPageGetDictionary(page);
    CGPDFArrayRef annotsArray;
    
    annotations = [[NSMutableArray alloc] init];
    //Get the Annots array
    if(!CGPDFDictionaryGetArray(pageDictionary, "Annots", &annotsArray)) {
        return;
    }
    
    int annotsArrayCount = CGPDFArrayGetCount(annotsArray);
    for (int j=annotsArrayCount; j >= 0; j--) {
        
        CGPDFObjectRef aDictObj;
        if(!CGPDFArrayGetObject(annotsArray, j, &aDictObj)) {
            continue;
        }

        CGPDFDictionaryRef annotDict;
        if(!CGPDFObjectGetValue(aDictObj, kCGPDFObjectTypeDictionary, &annotDict)) {
            //DLog(@"%@", @"can't get annotDict");
            continue;
        }

        annotationObject *annotation = [[annotationObject alloc] initWithDictionaryRef:annotDict];
        if (annotation != nil) {
            [annotations addObject:annotation];
            annotationView *annotationIcon = [[annotationView alloc] initWithFrame:annotation.frame annotation:annotation];
            [pdfView addSubview:annotationIcon];
        }
    }

}

- (id)initWithFrame:(CGRect)frame content:(ContentObject *)theContent
{
    if ((self = [super initWithFrame:frame])) {
		
		// Set up the UIScrollView
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.clearsContextBeforeDrawing = YES;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
		[self setBackgroundColor:[UIColor grayColor]];
		self.maximumZoomScale = 5.0;
		self.minimumZoomScale = .25;
        
        SapientViewerAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        NSString *contentURLString = [[NSString alloc] initWithFormat:@"http://%@/%@/services/ObjectService?method=getContentStream&repositoryId=%@&documentId=%@", appDelegate.serviceHost, appDelegate.serviceName, theContent.repositoryID, theContent.contentID];
        
		// Open the PDF document
		pdf = CGPDFDocumentCreateWithURL((__bridge CFURLRef)[NSURL URLWithString:contentURLString]);
        totalPage = CGPDFDocumentGetNumberOfPages(pdf);
        currentPage = 1;
        [self gotoPage:currentPage];
    }
    return self;
}
*/
- (id)initWithFrame:(CGRect)frame url:(NSURL *)theURL;
{
    if ((self = [super initWithFrame:frame])) {
		
		// Set up the UIScrollView
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.clearsContextBeforeDrawing = YES;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
		[self setBackgroundColor:[UIColor grayColor]];
		self.maximumZoomScale = 5.0;
		self.minimumZoomScale = .25;
                
		// Open the PDF document
        
		pdf = CGPDFDocumentCreateWithURL((__bridge CFURLRef)theURL);
        totalPage = CGPDFDocumentGetNumberOfPages(pdf);
        currentPage = 1;
        [self gotoPage:currentPage];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame pdfDocmentRef:(CGPDFDocumentRef)thePDF;
{
    if ((self = [super initWithFrame:frame])) {
		
		// Set up the UIScrollView
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.clearsContextBeforeDrawing = YES;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
		[self setBackgroundColor:[UIColor grayColor]];
		self.maximumZoomScale = 5.0;
		self.minimumZoomScale = .25;
        
		// Open the PDF document
        
		pdf = thePDF;
        totalPage = CGPDFDocumentGetNumberOfPages(pdf);
        currentPage = 1;
        [self gotoPage:currentPage];
    }
    return self;
}


-(id) getPdfViewAtPage:(int) pageNumber frame:(CGRect)theframe
{    
    // Get the PDF Page that we will be drawing
    CGPDFPageRef aPage = CGPDFDocumentGetPage(pdf, pageNumber);
    CGPDFPageRetain(aPage);
    
    // determine the size of the PDF page
    CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    
    CGFloat heightScale = theframe.size.height/pageRect.size.height;
    CGFloat widthScale = theframe.size.width/pageRect.size.width;
    
    pdfScale = MIN(heightScale, widthScale);
    pageRect.size = CGSizeMake(pageRect.size.width*pdfScale, pageRect.size.height*pdfScale);
    
    // Create the TiledPDFView based on the size of the PDF page and scale it to fit the view.
    TiledPDFView *aPDFView = [[TiledPDFView alloc] initWithFrame:pageRect andScale:pdfScale];
    [aPDFView setPage:aPage];

    CGPDFPageRelease(aPage);
    return aPDFView;
}

-(void) gotoPage:(int) pageNumber
{
    if (page != NULL)
        CGPDFPageRelease(page);
    
    if (pdfView != NULL)
        [pdfView removeFromSuperview];
    
    // Get the PDF Page that we will be drawing
    page = CGPDFDocumentGetPage(pdf, pageNumber);
    CGPDFPageRetain(page);
    
    // determine the size of the PDF page
    CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    
    CGFloat heightScale = self.frame.size.height/pageRect.size.height;
    CGFloat widthScale = self.frame.size.width/pageRect.size.width;

    pdfScale = MIN(heightScale, widthScale);
    pageRect.size = CGSizeMake(pageRect.size.width*pdfScale, pageRect.size.height*pdfScale);
        
    // Create the TiledPDFView based on the size of the PDF page and scale it to fit the view.
    pdfView = [[TiledPDFView alloc] initWithFrame:pageRect andScale:pdfScale];
    [pdfView setPage:page];

    [self addSubview:pdfView];

//    [self getAnnotations];
}

- (void)dealloc
{
	// Clean up
	CGPDFPageRelease(page);
	CGPDFDocumentRelease(pdf);
}

#pragma mark -
#pragma mark Override layoutSubviews to center content

// We use layoutSubviews to center the PDF page in the view
- (void)layoutSubviews 
{
    [super layoutSubviews];
    
    // center the image as it becomes smaller than the size of the screen
	
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = pdfView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    pdfView.frame = frameToCenter;
    
	// to handle the interaction between CATiledLayer and high resolution screens, we need to manually set the
	// tiling view's contentScaleFactor to 1.0. (If we omitted this, it would be 2.0 on high resolution screens,
	// which would cause the CATiledLayer to ask us for tiles of the wrong scales.)
	pdfView.contentScaleFactor = 1.0;
}

#pragma mark -
#pragma mark UIScrollView delegate methods

// A UIScrollView delegate callback, 
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return pdfView;
}

// A UIScrollView delegate callback, called when the user stops zooming. 
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
}

// A UIScrollView delegate callback, called when the user begins zooming.  
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
}



@end
