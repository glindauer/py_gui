CGPostMouseEvent has been deprecated in SnowLeopard.

You can replace it with something like

CGEventRef mouseDownEv = CGEventCreateMouseEvent (NULL,kCGEventLeftMouseDown,pt,kCGMouseButtonLeft);
CGEventPost (kCGHIDEventTap, mouseDownEv);

CGEventRef mouseUpEv = CGEventCreateMouseEvent (NULL,kCGEventLeftMouseUp,pt,kCGMouseButtonLeft);
CGEventPost (kCGHIDEventTap, mouseUpEv );
