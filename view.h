#import <ScreenSaver/ScreenSaver.h>

@interface DVDView : ScreenSaverView
@property NSImage * dvdLogo;
@property NSArray * dvdLogos;
@property NSColor * dvdColor;
@property NSRect dirtyRect;

@property int dvdWidth, dvdHeight;
@property int x, y;
@property int xSpeed, ySpeed;
@property unsigned long prevIdx;
@property BOOL initializing;
@end
