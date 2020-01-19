#import <ScreenSaver/ScreenSaver.h>
@interface DVDView : ScreenSaverView
@property NSImage * dvdLogo;
@property NSColor * dvdColor;
@property NSRect dirtyRect;

@property int dvdWidth, dvdHeight;
@property int x, y;
@property int xSpeed, ySpeed;
@end
