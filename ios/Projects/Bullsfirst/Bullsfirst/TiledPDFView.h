//
//  TiledPDFView.h
//  uniPresenter
//
//  Created by Pong Choa on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TiledPDFView : UIView {
	CGPDFPageRef pdfPage;
	CGFloat myScale;
}

- (id)initWithFrame:(CGRect)frame andScale:(CGFloat)scale;
- (void)setPage:(CGPDFPageRef)newPage;

@end
