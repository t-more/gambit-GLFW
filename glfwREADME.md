Schemidfed glfw bingins
================================

Well documented schtuff is comming soon.
for now...

I've remade it such that no extra c bindings is needed and everything works from the compiler

First (glfw#init) isn't realy needen anymore, (although it is there)

if you're calling glfw#make-window and we're not initated it will do so automaticly


(glfw#make-window width height title #!key (share #f) (monitor #f))
Is used to make a window and returns an instance of the glfw#window define-type

to set for example a on key press function
run
(glfw#window-on-key-press-set! WINDOW (lambda (window in-key scancodeaction mods)
                                            ... CODE
                                             ))


or read glfw.scm and glfwContantconverter.scm ;)
