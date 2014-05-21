Gambit-GLFW
===========

Gambit bindings to GLFW. an Open Source, multi-platform library for creating windows with OpenGL contexts and managing input and events.

To compile glfw you need to get the glfw binaries +:
 
OS X:
Cocoa, OpenGL, IOKit and CoreVideo

Windows:
opengl3


There are now also a schemified version! see glfwREADME.md or read glwf.scm ;)
Do it!



To test, when compiled run: 
# Schemified mode
No program compilation needed ;)
Copy paste the following into your gambit to test:
```scheme
(load "glfw.o1")

(define window (glfw#make-window 100 100))
(define should-quit? #f)

(glfw#window-on-key-press-set! main-window
     (lambda (window in-key scancode a b)
       (if (eq? in-key GLFW_KEY_0)
           (set! should-quit? #t))
       (let ((key (glfw-key->schmobj in-key))
             (x-pos (glfw#window-position-x main-window))
             (y-pos (glfw#window-position-y main-window)))
             
         (print key)
         (newline)
         (case key
           ((key-left)  (glfw#window-position-x-set! main-window (- x-pos 5)))
           ((key-right) (glfw#window-position-x-set! main-window (+ x-pos 5)))
           ((key-up)    (glfw#window-position-y-set! main-window (- y-pos 5)))
           ((key-down)  (glfw#window-position-y-set! main-window (+ y-pos 5)))
           ))))
       
(let loop ()
  (glfw-native#poll-events)
  (glfw#window-swap-buffers main-window)
  (if should-quit? #f (loop))      
  )

```
You Should now have a 100 x 100 black window (might be flimmering due to non cleared buffers...
And you can move it around the screen with your arrow keys!

press "0" to quit


# Native mode
```scheme
(load "glfwNative.o1")
(if (not (glfw-native#init))
(print "glfw init error \n")
)
(define window (glfw-native#create-window 100 100 "test" #f #f))
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
