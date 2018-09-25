# EMACS on UBUNTU tings
____________

In terminal:
```
$ sudo apt-get install emacs25
```
Copy contents of init files to your own in file `~/.emacs.d/init.el`
if you dont have an init file, create one with the same path

start emacs via terminal
```$ emacs```

if for some reason, emacs does not load according to the `~/.emacs.d/init.el`,
add the following line to bash file `~/.bashrc`
```alias emacs="emacs -q -l ~/.emacs.d/init.el"```

The following is for aesthetics:

;; BASIC CUSTOMIZATION
;; --------------------------------------

(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'material t) ;; load material theme
(global-linum-mode t) ;; enable line numbers globally
```

The init file is commented. Please google!

I have included add-ons for the following:
- Latex
- Python and Ipython
- C/C++