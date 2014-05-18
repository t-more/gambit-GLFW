Gambit-GLFW
===========

Gambit bindings to GLFW. an Open Source, multi-platform library for creating windows with OpenGL contexts and managing input and events.

To compile glfw you need to get the glfw binaries +:
 
OS X:
Cocoa, OpenGL, IOKit and CoreVideo

Windows:
opengl3

Currently working on a "schemified" wrapper that takes care of all c specific interagation.

To test, when compiled run: 

```scheme
(load "gambitNative.o1")
(if (not (glfw-native#init))
(print "glfw init error \n")
)
(define window (glfw-native#create-window 100 100 #f #f))
```
This should give you a 100 x 100 black window.

To create functions compatible with the diffrent event handlers you must make c-defines such as:
```scheme
(c-define (glfw#error-callback-procedure error-code error-msg)(int nonnull-UTF-8-string) void "gambitErrorCallback" ""
          (print "Glfw error-code: ")
          (print error-code)
          (newline)
          (print "Glfw error-message: ")
          (print error-msg)
          (newline)
          #f)
```

You should now be able to run the follwing:
```scheme
(glfw#setErrorCallback glfw#error-callback-procedure)
```

If you have questions or remarks feel free to contact me on tomas.o.more@gmail.com
