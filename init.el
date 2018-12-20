;; init.el --- Emacs configuration

(x-focus-frame nil)

(setq-default indent-tabs-mode nil)
(setq tab-width 4) ; or any other preferred value
;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)

(add-to-list 'package-archives
       '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)

;; Fetch list of packages available
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    ein ;; python (ipython)
    elpy ;; python editor
    flycheck ;; python spell check
    rebecca-theme
    ensime
    neotree ;; file tree
    ))

;; Installs packages ^ above
(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

(require 'neotree) ;; file tree
(global-set-key [f8] 'neotree-toggle)

;; BASIC CUSTOMIZATION
;; --------------------------------------

(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'rebecca t) ;; load material theme
(global-linum-mode t) ;; enable line numbers globally

;; LATEX
;; M-x package-install auctex
;; M-x package-install latex-preview-pane
;; --------------------------------------
(latex-preview-pane-enable)
(setq doc-view-continuous t)
(add-hook 'LaTeX-mode-hook 'latex-preview-pane-mode)

(require 'auto-complete-config)
(ac-config-default)

;; Activate auto-complete for latex modes (AUCTeX or Emacs' builtin one).
(add-to-list 'ac-modes 'latex-mode)

;; Activate ac-math.
(eval-after-load "latex"
  '(when (featurep 'auto-complete)
     ;; See https://github.com/vspinu/ac-math
     (require 'ac-math)
     (defun ac-latex-mode-setup ()       ; add ac-sources to default ac-sources
       (setq ac-sources
         (append '(ac-source-math-unicode ac-source-math-latex ac-source-latex-commands)
             ac-sources)))
     (add-hook 'LaTeX-mode-hook 'ac-latex-mode-setup)))

(add-hook 'LaTeX-mode-hook
      (lambda()
        (local-set-key [C-tab] 'TeX-complete-symbol)))

'(LaTeX-command "latex -shell-escape -synctex=1")

;; ORG MODE for latex
;; --------------------------------------

(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

;; SCALA
;; --------------------------------------
(require 'ensime)
;; Start ensime mode whenever we open scala mode, e.g. open a .scala file
;;(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
;; Start ensime with Super-e
;;(global-set-key (kbd "C-c C-c c") 'ensime)
(setq scala-indent:step 2) 

;; PYTHON CONFIGURATION
;; --------------------------------------

(elpy-enable)
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt")

;; use flycheck not flymake with elpy
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; enable autopep8 formatting on save
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)
;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (all-the-icons neotree auctex flycheck-irony latex-preview-pane company-irony rtags py-autopep8 material-theme irony-eldoc flycheck elpy ein cmake-ide better-defaults))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
