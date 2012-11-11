//
//  PDFScrollView.h
//  uniPresenter
//
//  Created by Pong Choa on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>


@class TiledPDFView;

@interface PDFScrollView : UIScrollView <UIScrollViewDelegate> {
	// The TiledPDFView that is currently front most
	TiledPDFView *pdfView;
	// The old TiledPDFView that we draw on top of when the zooming stops
	TiledPDFView *oldPDFView;

	// current pdf zoom scale
	CGFloat pdfScale;
	
	CGPDFPageRef page;
	CGPDFDocumentRef pdf;
    
    int currentPage;
    int totalPage;
    NSMutableArray *annotations;
}

@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) int totalPage;
@property (nonatomic, assign) CGPDFDocumentRef pdf;
@property (nonatomic, strong) NSMutableArray *annotations;

- (id)initWithFrame:(CGRect)frame url:(NSURL *)theURL;
- (id)initWithFrame:(CGRect)frame pdfDocmentRef:(CGPDFDocumentRef)thePDF;

-(void) gotoPage:(int) pageNumber;
-(id) getPdfViewAtPage:(int) pageNumber frame:(CGRect)theframe;

@end
