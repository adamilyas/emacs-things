;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)

(add-to-list 'package-archives
       '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    ein ;; python (ipython)
    elpy ;; python editor
    flycheck ;; python spell check
    material-theme
    ))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

;; BASIC CUSTOMIZATION
;; --------------------------------------

(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'material t) ;; load material theme
(global-linum-mode t) ;; enable line numbers globally

;; LATEX
;; --------------------------------------
(latex-preview-pane-enable)
(setq doc-view-continuous t)

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

;; C++ CONFIGURATION
;; ---------------------------------------

;; =============
;; irony-mode
;; =============
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
;; =============
;; company mode
;; M-x package-install company-irony
;; =============
(add-hook 'c++-mode-hook 'company-mode)
(add-hook 'c-mode-hook 'company-mode)
;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
(define-key irony-mode-map [remap completion-at-point]
  'irony-completion-at-point-async)
(define-key irony-mode-map [remap complete-symbol]
  'irony-completion-at-point-async))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
(eval-after-load 'company
'(add-to-list 'company-backends 'company-irony))
;; (optional) adds CC special commands to `company-begin-commands' in order to
;; trigger completion at interesting places, such as after scope operator
;;     std::|
(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)
(add-hook 'after-init-hook 'global-company-mode)

;; =============
;; flycheck-mode
;; =============

(add-hook 'c++-mode-hook 'flycheck-mode)
(add-hook 'c-mode-hook 'flycheck-mode)

;; M-x package-install RET flycheck-irony RET
(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

;; =============
;; eldoc-mode
;; =============
(add-hook 'irony-mode-hook 'irony-eldoc)
;; ==========================================
;; (optional) bind TAB for indent-or-complete
;; ==========================================
(defun irony--check-expansion ()
(save-excursion
  (if (looking-at "\\_>") t
    (backward-char 1)
    (if (looking-at "\\.") t
      (backward-char 1)
      (if (looking-at "->") t nil)))))
(defun irony--indent-or-complete ()
"Indent or Complete"
(interactive)
(cond ((and (not (use-region-p))
            (irony--check-expansion))
       (message "complete")
       (company-complete-common))
      (t
       (message "indent")
       (call-interactively 'c-indent-line-or-region))))
(defun irony-mode-keys ()
"Modify keymaps used by `irony-mode'."
(local-set-key (kbd "TAB") 'irony--indent-or-complete)
(local-set-key [tab] 'irony--indent-or-complete))
(add-hook 'c-mode-common-hook 'irony-mode-keys)
;; init.el ends here
