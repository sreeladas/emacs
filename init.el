;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;        Initialize         ;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; speedup/sanity
;; gc-cons-threshold is the number of bytes of consing before a garbage collection is invoked.
;; It's normally set super low for compatibility with older machines, but any modern machine with decent RAM can handle 50MB of garbage
;; (setq gc-cons-threshold 100000000)

;; Install from MELPA: 

(require 'package)
;; Install auctex, rename yasnippet directory
;; load emacs 24's package system. Add MELPA repository.

;; (when (>= emacs-major-version 24)
;;   (require 'package)
;;   (add-to-list 'package-archives   '("melpa" . "https://melpa.org/packages/") t)
;;   (package-refresh-contents))
;; list the packages you want

(setq package-list
      ;; auctex pdf-tools
      '(bind-key company elpy epl flx flx-ido flycheck jedi let-alist magit move-text multiple-cursors pkg-info projectile seq smart-tabs-mode smooth-scrolling spacemacs-theme use-package yasnippet))
;; activate all the packages
(package-initialize)
(setq package-enable-at-startup nil
      package--init-file-ensured t)

;; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))
;; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(let ((default-directory "~/.emacs.d/elpa"))
  (normal-top-level-add-subdirs-to-load-path))
(eval-when-compile (require 'use-package))


;; redefines the silly indent of keyword lists
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;      fix elisp indent issue     ;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;      Appearance/Miscellaneous     ;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; save session on close
(desktop-save-mode 1)

;; set tab width to 4
(setq tab-width 4) ; or any other preferred value

;; hide toolbar and scroll bar
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; overwrite selected text on type - exceptions in latex mode/yasnippet
(delete-selection-mode t)

;; ask y/n instead of yes/no, just less tedious
(defalias 'yes-or-no-p 'y-or-n-p)

;; drag lines up and down
(global-set-key [(control shift up)]  'move-text-up)
(global-set-key [(control shift down)]  'move-text-down)


(show-paren-mode t)
(setq show-paren-style 'expression)

;; smart tabs for the frequently used languages
(use-package smart-tabs-mode
  :ensure t
  :config
  ;; (autoload 'smart-tabs-mode "smart-tabs-mode"
  ;;   "Intelligently indent with tabs, align with spaces!")
  ;; (autoload 'smart-tabs-mode-enable "smart-tabs-mode")
  ;; (autoload 'smart-tabs-advice "smart-tabs-mode")

  ;; C/C++
  (add-hook 'c-mode-hook 'smart-tabs-mode-enable)
  (smart-tabs-advice c-indent-line c-basic-offset)
  (smart-tabs-advice c-indent-region c-basic-offset)

  ;; Python
  (add-hook 'python-mode-hook 'smart-tabs-mode-enable)
  (smart-tabs-advice python-indent-line-1 python-indent))

(with-eval-after-load 'lisp-mode
  (if (version<= "26.2" emacs-version)
    (advice-add 'lisp-indent-calc-next :override #'lisp-indent-calc-next-patch)))

;; insert pair of whatevs
(defvar skeletons-alist
  '((?\( . ?\))
    (?\' . ?\')
    (?\" . ?\")
    (?\[  . ?\])
    (?\{  . ?\})
    (?\$  . ?\$)))

(setq skeleton-pair t)
(global-set-key (kbd "$") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "(") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "[") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "{") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "\"") 'skeleton-pair-insert-maybe) ; wraps in "", for ``'' use C-' from yasnippet
(global-set-key (kbd "'") 'skeleton-pair-insert-maybe)

(require 'multiple-cursors)
(global-set-key (kbd "C->")  'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; delete pair of whatevs
(defadvice delete-backward-char (before delete-empty-pair activate)
  (if (eq (cdr (assq (char-before) skeletons-alist)) (char-after))
      (and (char-after) (delete-char 1))))
(defadvice backward-kill-word (around delete-pair activate)
  (if (eq (char-syntax (char-before)) ?\()
      (progn
        (backward-char 1)
        (save-excursion
          (forward-sexp 1)
          (delete-char -1))
        (forward-char 1)
        (append-next-kill)
        (kill-backward-chars 1))
    ad-do-it))

;; company mode (autocomplete)
(add-hook 'after-init-hook 'global-company-mode)

(setq split-height-threshold nil
      split-width-threshold 160)

;; remove extra newline at the end of snippets!
(setq-default mode-require-final-newline nil)

;; no-littering
(use-package no-littering               ; Keep .emacs.d clean
  :ensure t
  :config
  (require 'recentf)
  (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory)
  (setq auto-save-file-name-transforms
        `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

;; spacemacs dark theme
(use-package spacemacs-theme
  :defer t
  :init (load-theme 'spacemacs-dark t))

(use-package ido                        ; Better minibuffer completion
  :init (progn
          (ido-mode)
          (ido-everywhere))
  :config
  (setq ido-enable-flex-matching t      ; Match characters if string doesn't match
	    ido-default-file-method 'selected-window ; Visit buffers and files in the selected window
	    ido-default-buffer-method 'selected-window
	    ido-use-faces nil             ; Prefer flx ido faces
	    ido-decorations (quote ("\n-> " "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))
  ;; Display ido results vertically, rather than horizontally
  (defun ido-disable-line-truncation () (set (make-local-variable 'truncate-lines) nil))
  (add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-truncation)
  (defun ido-define-keys () ;; C-n/p is more intuitive in vertical layout
    (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
    (define-key ido-completion-map (kbd "C-p") 'ido-prev-match)
    (add-hook 'ido-setup-hook 'ido-define-keys)))

(use-package flx-ido                    ; Flex matching for IDO
  :ensure t
  :init (flx-ido-mode))

;; disable help menu
(define-key global-map [menu-bar help-menu] nil)

;; disable help menu
(define-key global-map [menu-bar tools] nil)

;; projectile
(use-package projectile
  :defer 5
  :diminish
  :bind* (("C-c TAB" . projectile-find-other-file)
          ("C-c P" . (lambda () (interactive)
                       (projectile-cleanup-known-projects)
                       (projectile-discover-projects-in-search-path))))
  :bind-keymap (("C-c p" . projectile-command-map)
		        ("s-p" . projectile-command-map)) 
  :config

  (projectile-global-mode))
  (setq projectile-enable-caching t)


;;;; Company. Auto-completion, used for python mostly.
(use-package company
  :ensure t
  :bind (("C-<tab>" . company-complete))
  :config
  (global-company-mode))

;; code folding hs-minor-mode
(defun toggle-selective-display (column)
  (interactive "P")
  (set-selective-display
   (or column
       (unless selective-display
         (1+ (current-column))))))

(defun toggle-hiding (column)
  (interactive "P")
  (if hs-minor-mode
      (if (condition-case nil
              (hs-toggle-hiding)
            (error t))
          (hs-show-all))
    (toggle-selective-display column)))

(load-library "hideshow")
(global-set-key (kbd "C-}") 'toggle-hiding)
(global-set-key (kbd "C-S-}") 'toggle-selective-display)

(add-hook 'c-mode-common-hook   'hs-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
(add-hook 'java-mode-hook       'hs-minor-mode)
(add-hook 'lisp-mode-hook       'hs-minor-mode)
(add-hook 'perl-mode-hook       'hs-minor-mode)
(add-hook 'sh-mode-hook         'hs-minor-mode)

;; Use Multiple-cursors
(use-package multiple-cursors
  :ensure t
  :bind ("C->" . mc/mark-next-like-this)
  ("C-<" . mc/mark-previous-like-this)
  ("C-c C-<" . mc/mark-all-like-this))

;; outline-magic
(add-hook 'outline-mode-hook 
          (lambda () 
            (require 'outline-cycle)))

(add-hook 'outline-minor-mode-hook 
          (lambda () 
            (require 'outline-magic)
            (define-key outline-minor-mode-map  (kbd "C-<tab>") 'outline-cycle)))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;        Magit        ;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key (kbd "C-x g") 'magit-status)


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;        Org mode        ;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package org
  :init
  (setq org-startup-truncated nil)
  (add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
  (define-key global-map "\C-cl" 'org-store-link)
  (define-key global-map "\C-ca" 'org-agenda)
  (define-key global-map (kbd "C-c c") 'org-capture)
  (setq org-log-done t)
  (setq org-agenda-start-day "+0d")
  
  (setq org-directory "~/code/")
  (setq org-default-notes-file (concat org-directory "master_todo.org"))
  (setq org-agenda-files (list "/Users/sreela/code/master_todo.org"))
  (with-eval-after-load 'org-agenda
    (add-to-list 'org-agenda-prefix-format '(todo . "  %b")))
  
  ;;set priority range from A to C with default A
  (setq org-highest-priority ?A)
  (setq org-lowest-priority ?E)
  (setq org-default-priority ?C)

  ;; Auto mark task done if all children are done
  (defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

  (add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

  ;; Always use all children to calculate cookie data
  (setq org-hierarchical-todo-statistics nil)
  
  ;;set colours for priorities
  (setq org-priority-faces '((?A . (:foreground "firebrick3" :weight bold))
                             (?B . (:foreground "goldenrod3" :weight bold))
                             (?C . (:foreground "orange3")))
                             (?D . (:foreground "MediumPurple3"))
                             (?E . (:foreground "RosyBrown3")))
  
  (setq org-completion-use-ido t)
  
  ;;open agenda in current window
  (setq org-agenda-window-setup (quote current-window))
  
  ;;capture todo items using C-c c [custom project key]
  (setq org-capture-templates
        '(("c" "CS Streamlit" entry (file+headline "/Users/sreela/code/master_todo.org" "CS Streamlit Feature Request")
           "* TODO %T%?\n\n")
          ("s" "Scheduler" entry (file+headline "/Users/sreela/code/master_todo.org" "Scheduler Feature Request")
           "* TODO %T%?\n\n")
          ("p" "Tutor Pay-Tracker" entry (file+headline "/Users/sreela/code/master_todo.org" "Tutor Pay-Raise Tracker")
           "* TODO %T%?\n\n")
          ("n" "Add New Project" entry (file+headline "/Users/sreela/code/master_todo.org" "New Project [/]")
           "* TODO %T%?\n\n")))
  
  ; Allow setting single tags without the menu
  (setq org-fast-tag-selection-single-key (quote expert))
  
  ; For tag searches ignore tasks with scheduled and deadline dates
  (setq org-agenda-tags-todo-honor-ignore-options t)
  
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "|" "DONE(d)")
          (sequence "|" "CANCELLED(c)")))
  
  (setq org-todo-keyword-faces
        '(("TODO" :foreground "firebrick" :weight bold)
          ("NEXT" :foreground "turquoise" :weight bold)
          ("DONE" :foreground "royal blue" :weight bold)
          ("WAITING" :foreground "tomato" :weight bold)
          ("CANCELLED" :foreground "olive drab" :weight bold)
          ("MEETING" :foreground "forest green" :weight bold)))
  
  (setq org-todo-state-tags-triggers
        '(("CANCELLED" ("CANCELLED" . t))
          ("WAITING" ("WAITING" . t))
          (done ("WAITING"))
          ("TODO" ("WAITING") ("CANCELLED"))
          ("NEXT" ("WAITING") ("CANCELLED"))
          ("DONE" ("WAITING") ("CANCELLED"))))
  )
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;        Python        ;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package python
  :mode ("\\.py\\'" . python-mode)
  ("\\.wsgi$" . python-mode)
  :interpreter ("python" . python-mode)

  :init
  (setq-default indent-tabs-mode nil)

  :config
  (setq python-indent-offset 4)
  (add-hook 'python-mode-hook 'smartparens-mode)
  (add-hook 'python-mode-hook 'color-identifiers-mode)
  (require 'multi-line)
  (global-set-key (kbd "C-c d") 'multi-line))

;; (use-package py-autopep8
;;   :after python
;;   ;; :ensure-system-package (autopep8 . py37-autopep8)
;;   :hook (python-mode . py-autopep8-enable-on-save)
;;   :init (setq py-autopep8-options '("--max-line-length=79")))

(use-package jedi
  :ensure t
  :after company
  :init
  (add-to-list 'company-backends 'company-jedi)
  :config
  (use-package company-jedi
    :ensure t
    :init
    (add-to-list 'company-backends 'company-jedi))
  (setq company-jedi-python-bin "python"))

(use-package elpy
  :ensure t
  :commands elpy-enable
  :init (with-eval-after-load 'python (elpy-enable))

  :config
  ;; Automatically run Black on buffer save
  (add-hook 'elpy-mode-hook
            '(lambda ()
               (when (eq major-mode 'python-mode)
                 (add-hook 'before-save-hook 'elpy-black-fix-code))))
  (electric-indent-local-mode -1)
  (delete 'elpy-module-highlight-indentation elpy-modules)
  (delete 'elpy-module-flymake elpy-modules)

  (defun ha/elpy-goto-definition ()
    (interactive)
    (condition-case err
        (elpy-goto-definition)
      ('error (xref-find-definitions (symbol-name (symbol-at-point))))))

  :bind (:map elpy-mode-map ([remap elpy-goto-definition] .
                             ha/elpy-goto-definition)))


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;        LaTeX         ;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (use-package tex
;;   :ensure auctex
;;   :mode ("\\.tex\\'" . TeX-latex-mode)
;;   :commands (TeX-command-run-all TeX-clean)
;;   :bind (:map LaTeX-mode-map
;; 	          ("M-p" . latex-do-everything))
;;   :config
;;   (setq TeX-auto-save t)
;;   (setq-default LaTeX-clean-intermediate-suffixes t)
;;   ;; ##### changing default master file from current file to main.tex
;;   (setq-default TeX-master nil)
;;   (add-hook 'LaTeX-mode-hook (lambda () (setq TeX-master (concat (projectile-project-root) "./main.tex"))))
;;   (add-hook 'LaTeX-mode-hook 'flyspell-mode)
;;   (defun latex-do-everything ()
;;     "Save the buffer and run 'TeX-command-run-all'."
;;     (interactive)
;;     (save-buffer)
;;     (TeX-command-run-all nil)))


;; Spellcheck
(use-package flyspell
  :ensure
  :config
  (add-hook 'prog-mode-hook 'flyspell-prog-mode))

;; ;; Set PDFTools as the default PDF viewer to use pdfview with auctex
;; (pdf-tools-install)
;; (use-package pdf-tools
;;   :pin manual ;; manually update
;;   :config
;;   ;; initialise
;;   (pdf-tools-install)
;;   ;; open pdfs scaled to fit page
;;   (setq-default pdf-view-display-size 'fit-page)
;;   ;; automatically annotate highlights
;;   (setq pdf-annot-activate-created-annotations t)
;;   ;; use normal isearch
;;   (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward))

;; (server-start)
;; (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
;;       Tex-source-correlate-mode t
;;       LaTeX-command "latex --synctex=1") ;; optional: enable synctex

;; ;; to have the buffer refresh after compilation
;; (add-hook 'TeX-after-compilation-finished-functions
;;           #'TeX-revert-document-buffer)

;; yasnippet
;; wrap in parentheses C-L
;; wrap in $-signs C-$
;; wrap in quotes C-'

;; (use-package yasnippet
;;   :config
;;   (yas-global-mode 1)
;;   (yas-load-directory "~/.emacs.d/elpa/yasnippet-20190724.1204/snippets/"))


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;        tramp         ;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; tramp - edit/remove
;; Keep the path settings of the remote account.

;; (use-package tramp
;;   :config
;;   (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
;;   (custom-set-variables
;;    '(tramp-default-method "ssh")
;;    '(tramp-default-user "")
;;    '(tramp-default-host "reedbuck")))

;; (global-set-key (kbd "C-S-t") 'tramp-cleanup-all-connections)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"]))


(with-eval-after-load 'ox-latex
  (add-to-list 'org-latex-classes
               '("article"
                 "\\documentclass{article}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}"))))
(global-set-key (kbd "C-x C-b") 'ibuffer)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
