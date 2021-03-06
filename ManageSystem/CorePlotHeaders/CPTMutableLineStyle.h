#import "CPTLineStyle.h"

@class CPTColor;

@interface CPTMutableLineStyle : CPTLineStyle {
}

@property (nonatomic, readwrite, assign) CGLineCap lineCap;
@property (nonatomic, readwrite, assign) CGLineJoin lineJoin;
@property (nonatomic, readwrite, assign) CGFloat miterLimit;
@property (nonatomic, readwrite, assign) CGFloat lineWidth;
@property (nonatomic, readwrite, retain) NSArray *dashPattern;
@property (nonatomic, readwrite, assign) CGFloat patternPhase;
@property (nonatomic, readwrite, retain) CPTColor *lineColor;
@property (nonatomic, readwrite, retain) CPTFill *lineFill;

@end
