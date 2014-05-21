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
(glfw#window-show glfw#window)
```
```scheme
(glfw#window-show glfw#window)
```
