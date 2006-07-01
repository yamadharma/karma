wm-focus-patch-v3 applies cleanly against CSV of 9/12/2004
wm2-focus-patch applies cleanly against WM2 CVS of 9/14/2004

Notice that wm-focus-patch-v3 includes fixes for two crash bugs, while 
wm2-focus patch does not.

The crash bugs are:

Around line 308 in src/workspace.c
 data = wmalloc(sizeof(WorkspaceNameData));
+data->back = NULL;
This is needed because some code paths (when errors are encountered) 
don't allocate data->back, and don't set it to NULL, which leads to 
a segfault. For example, this happens if you xrandr to a lower 
resolution (with workspace name display on the bottom), and try 
switching workspaces.

Around line 304 in wrlib/x86_specific.c
 "emms            \n"

 "popal           \n"
+"addl $128, %esp    \n" // dealloc our stack space
 );
Someone changed the MMX code, but didn't test it. This crash is triggered 
when a WINGs app attempts to start in 16-bit color. The problem is that
at the beginning of the function, we get extra stack space with a "subl",
but then never return the stack pointer. The return instruction then
justifiably returns to garbage and crashes. 

This bug is also present in x86_mmx_TrueColor_24_to_16 in this file, but
neither patch fixes this. This is because I never saw this problem
triggered, and couldn't test a solution. However, I strongly suggest that
the correction be applied in both places. (perhaps after consulting with
Alfredo)


