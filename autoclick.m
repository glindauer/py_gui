// File: 
// click.m
//
// Compile with: 
// gcc -o click click.m -framework ApplicationServices -framework Foundation
//
// Usage:
// ./click -x pixels -y pixels 
// At the given coordinates it will click and release. If none are given, it will click at the current mouse location

#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>

//Global mouse position as stored by us. This will differ from the real mouse position if the cursor is moved by the user's actual mouse between calls to setMouseLoc
CGPoint gPosMouse;

void getMouseLoc(CGPoint *ptCurLoc)
{
	CGEventRef curLocEvent = CGEventCreate(NULL);
	*ptCurLoc = CGEventGetLocation(curLocEvent);
	gPosMouse=*ptCurLoc;
	CFRelease(curLocEvent);
}
void setMouseLoc(CGPoint *ptNewLoc)
{
	CGEventRef mouseMoveEv = CGEventCreateMouseEvent (NULL,kCGEventMouseMoved,*ptNewLoc,0);
	CGEventPost (kCGHIDEventTap, mouseMoveEv);
	CFRelease(mouseMoveEv);
	gPosMouse=*ptNewLoc;
}
void mouseLeftClick(CGPoint *pt)
{
	CGEventRef mouseDownEv = CGEventCreateMouseEvent (NULL,kCGEventLeftMouseDown,*pt,kCGMouseButtonLeft);
	CGEventPost (kCGHIDEventTap, mouseDownEv);

	CGEventRef mouseUpEv = CGEventCreateMouseEvent (NULL,kCGEventLeftMouseUp,*pt,kCGMouseButtonLeft);
	CGEventPost (kCGHIDEventTap, mouseUpEv );

  CFRelease (mouseDownEv);
  CFRelease (mouseUpEv);
}
int main(int argc, char *argv[]) {
  /* quartz requires a memory pool, hence the NSAutoreleasePool and
   * [pool release] at the end
   */
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSUserDefaults *args = [NSUserDefaults standardUserDefaults];

  /* a minimal sleep is needed for the system to register the 
   * key-up event for the return key the user presses to invoke this
   * command from the command line
   */
  sleep (2);

  // grabs command line arguments -x and -y
  //
  NSString *sFilename=[args stringForKey:@"f"];
  int x = [args integerForKey:@"x"];
  int y = [args integerForKey:@"y"];

  if (x==0 || y==0)
  {
	// user didn't enter one or both coordinates,
	// meaning that we should click at the current coordinate
       CGPoint ourLoc;
	getMouseLoc(&ourLoc);
	x = ourLoc.x;
	y = ourLoc.y;
  }

  // The data structure CGPoint represents a point in a two-dimensional
  // coordinate system.  Here, X and Y distance from upper left, in pixels.
  //
  CGPoint pt={x,y};

  mouseLeftClick(&pt);

  [pool release];
  return 0;
}
