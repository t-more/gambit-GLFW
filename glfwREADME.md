Schemidfed glfw bindings
================================

This document specifices the procedures as redefined and how they work

# Init and terminate
```scheme
(glfw#init)
(glfw#terminate)
```
Simple as that call init to start glfw and terminate to terminate it.


# Error handling
```scheme
(glfw#set-error-callback on-error-procedure)
```
Takes either a lambda with two args or #f

# Window handling
```scheme
(glfw#make-window width height title
             #!key
             (monitor #f)
             (share   #f)
             )
```
Requires width height and title to run but takes monitor and share as key arguments
(see glfw documentation for monitor and share)
Making a window passes you a scheme object called "glfw#window" and this IS NOT compatible with native glfw.

```scheme
(glfw#window-destroy glfw#window)
```
To destroy a window.

```scheme
(glfw#window-show glfw#window)
```
Shows a hidden or iconified window

```scheme
(glfw#widnow-hide glfw#window)
```
Hides a window
```scheme
(glfw#window-iconify glfw#window)
```
Iconifies a window

```scheme
(glfw#window-pos glfw#window)
```
Gives you the height and with of a window as interer pixles
The result is a pair
head is the x position and tail is the y position 



```scheme
(glfw#window-position-x glfw#window)
(glfw#window-position-y glfw#window)
```
Gives you just the specific x or y coordinate

```scheme
(glfw#window-position-set! glfw#window x-pos y-pos)
```
Sets the position of the window second argument is x and second argument is y.

```scheme
(glfw#window-position-x-set! glfw#window x-pos)
(glfw#window-position-y-set! glfw#window y-pos)
```
To set a specific x or y position

```scheme
(glfw#window-size glfw#window)
```
Returns the width and height of the window as intergers.
The result comes in a pair

```scheme
(glfw#window-width glfw#window)
(glfw#window-height glfw#window)
```
Returns either with or heigt of the window

```scheme
(glfw#window-size-set! glfw#window width height)
```
Sets the heght of the window


```scheme
(glfw#window-width-set! glfw#window width)
(glfw#window-height-set! glfw#window height)
```
Sets the specific with or height of the window

```scheme
(glfw#window-title-set! glfw#window title-string)
```
Sets the title of the window

```scheme
(glfw#window-monitor glfw#window)
```
Returns the monitor of the window. The result is a C object

# Input events 

```scheme
(glfw#window-monitor glfw#window)
```


# Hints
Hints are used to tell glfw what properties a window is going to have
```scheme
(glfw#default-window-hint)
```
Resets hints to default glfw#window-hint
```scheme
(glfw#window-hint hint hint-value)
```
There are a small helper built in here that translates scheme symbls to the connect hints.
The default values can be passed as well
See: 
"symbol->glfw-hint" and "symbol->glfw-hint-value"
in 
https://github.com/black0range/gambit-GLFW/blob/master/glfwContantconveter.scm





# Clipboard handler
```scheme
(glfw#get-clipboard-string glfw#window)
```
Returns the current clipboard string

```scheme
(glfw#clipboard-string-set! window string)
```
Sets the current clipboard string

# Context handler
```scheme
(glfw#current-context #!optional  glfw#window)
```
Takes one optional argument that is the window,
If the procedure is run with the agrument that windows context is set to the current context.
If The procedure is run without arguments it returns the current context

```scheme
(glfw#window-swap-buffers glfw#window)
```
swaps the buffers of the context of the specified window

```scheme
(glfw##swap-interval fps)
```
Sets the "swap interval" commonly known as "v-sync" of opengl

# Monitor


```scheme
(glfw#get-monitors)
```
Returns a list of all available monitors

```scheme
(glfw#monitor-position monitor)
```
Returns the position of the specified monitor as a pair

```scheme
(glfw#monitor-position-x monitor)
(glfw#monitor-position-y monitor)
```
Returns the specifi and and y position of the monitor

```scheme
(glfw#monitor-physical-size monitor)
```
Returns the physical size of the monitor as a pair
```scheme
(glfw#monitor-physical-height monitor)
(glfw#monitor-physical-width monitor)
```
Returns either the height or the with of the monitor 

```scheme
(glfw#monitor-name monitor)
```
Returns the name of the monitor

```scheme
(glfw#on-monitor-connect/disconnet procedure)
```
To set a procedure that is run each time a monitor is connected or dissconnected
The procedure is given the arguments. monitor and a boolean
If #t the monitor is connected
If #f the monitor is disconnected
