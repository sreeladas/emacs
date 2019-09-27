;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;        Initialize         ;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Install from MELPA: 

(require 'package)
;; Install auctex, rename yasnippet directory
;; load emacs 24's package system. Add MELPA repository.
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list 'package-archives   '("melpa" . "https://melpa.org/packages/") t)
  (package-refresh-contents))
;; list the packages you want
(setq package-list
      '(auctex bind-key company elpy epl flx flx-ido flycheck jedi let-alist move-text multiple-cursors pdf-tools pkg-info projectile seq smart-tabs-mode smooth-scrolling spacemacs-theme use-package yasnippet))
;; activate all the packages
(package-initialize)
(setq package-enable-at-startup nil)

;; (add-to-list 'load-path "~/.emacs.d/elpa/auctex-12.1")
;; (load "auctex.el" nil t t)
;; (load "preview-latex.el" nil t t)
;; (load "latex.el" nil t t)

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


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;      Org Mode     ;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'org)
 SCHEDULED: <2019-09-30 Mon>
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(setq org-agenda-start-day "+0d")

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

;; smart tabs for the frequently used languages
(smart-tabs-insinuate 'c 'c++ 'python 'java)

;; insert pair of whatevs
(defvar skeletons-alist
  '((?\( . ?\))
    (?\' . ?\')
    (?\" . ?\")
    (?[  . ?])
    (?{  . ?})
    (?$  . ?$)))

(setq skeleton-pair t)
(global-set-key (kbd "$") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "(") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "[") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "{") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "\"") 'skeleton-pair-insert-maybe) ; wraps in "", for ``'' use C-' from yasnippet
(global-set-key (kbd "\'") 'skeleton-pair-insert-maybe)

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
;; (global-set-key (kbd "M-)") 'delete-pair)
;; (global-set-key (kbd "M-]") 'delete-pair)
;; (global-set-key (kbd "M-}") 'delete-pair)

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

;;;; Company. Auto-completion, used for python mostly.
(use-package company
  :ensure t
  :bind (("C-<tab>" . company-complete))
  :config
  (global-company-mode))


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;        Org mode        ;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq org-agenda-files (list "~/Documents/CV/2019_09_transit/prompt.org"
                             "~/Documents/Data4Good/d4g.org" 
                             "~/Documents/msc_thesis/fixes.org"))

(require 'ox-latex)
(unless (boundp 'org-latex-classes)
  (setq org-latex-classes nil))
(add-to-list 'org-latex-classes
             '("article"
               "\\documentclass{article}"
               ("\\section{%s}" . "\\section*{%s}")))


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
  (add-hook 'python-mode-hook 'color-identifiers-mode))

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

;; auctex
(use-package tex
  :ensure auctex
  :mode ("\\.tex\\'" . TeX-latex-mode)
  :commands (TeX-command-run-all TeX-clean)
  :bind (:map LaTeX-mode-map
	          ("M-p" . latex-do-everything))
  :config
  (setq TeX-auto-save t)
  (setq-default LaTeX-clean-intermediate-suffixes t)
  ;; ##### changing default master file from current file to main.tex
  (setq-default TeX-master nil)
  ;; (add-hook 'LaTeX-mode-hook (lambda () (setq TeX-master (concat (projectile-project-root) "./main.tex"))))
  (add-hook 'LaTeX-mode-hook 'flyspell-mode)
  (defun latex-do-everything ()
    "Save the buffer and run 'TeX-command-run-all'."
    (interactive)
    (save-buffer)
    (TeX-command-run-all nil)))


;; Spellcheck
(use-package flyspell
  :ensure
  :config
  (add-hook 'prog-mode-hook 'flyspell-prog-mode))

;; Set PDFTools as the default PDF viewer to use pdfview with auctex
(pdf-tools-install)
(use-package pdf-tools
  :pin manual ;; manually update
  :config
  ;; initialise
  (pdf-tools-install)
  ;; open pdfs scaled to fit page
  (setq-default pdf-view-display-size 'fit-page)
  ;; automatically annotate highlights
  (setq pdf-annot-activate-created-annotations t)
  ;; use normal isearch
  (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward))

(server-start)
(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      Tex-source-correlate-mode t
      LaTeX-command "latex --synctex=1") ;; optional: enable synctex

;; to have the buffer refresh after compilation
(add-hook 'TeX-after-compilation-finished-functions
          #'TeX-revert-document-buffer)

;; yasnippet
;; wrap in parentheses C-L
;; wrap in $-signs C-$
;; wrap in quotes C-'
(use-package yasnippet
  :config
  (yas-global-mode 1)
  (yas-load-directory "~/.emacs.d/elpa/yasnippet-20190724.1204/snippets/"))

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

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;        tramp         ;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; tramp - edit/remove
;; Keep the path settings of the remote account.
(use-package tramp
  :config
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
  (custom-set-variables
   '(tramp-default-method "ssh")
   '(tramp-default-user "")
   '(tramp-default-host "reedbuck")))

(global-set-key (kbd "C-S-t") 'tramp-cleanup-all-connections)


;; (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes (quote (spacemacs-dark)))
 '(custom-safe-themes
   (quote
    ("bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "c48551a5fb7b9fc019bf3f61ebf14cf7c9cdca79bcb2a4219195371c02268f11" default)))
 '(hl-todo-keyword-faces
   (quote
    (("TODO" . "#dc752f")
     ("NEXT" . "#dc752f")
     ("THEM" . "#2d9574")
     ("PROG" . "#4f97d7")
     ("OKAY" . "#4f97d7")
     ("DONT" . "#f2241f")
     ("FAIL" . "#f2241f")
     ("DONE" . "#86dc2f")
     ("NOTE" . "#b1951d")
     ("KLUDGE" . "#b1951d")
     ("HACK" . "#b1951d")
     ("TEMP" . "#b1951d")
     ("FIXME" . "#dc752f")
     ("XXX" . "#dc752f")
     ("XXXX" . "#dc752f")
     ("???" . "#dc752f"))))
 '(org-export-latex-default-packages-alist
   (quote
    (("AUTO" "inputenc" t)
     ("T1" "fontenc" nil)
     ("" "graphicx" t)
     ("" "float" nil)
     ("" "wrapfig" nil)
     ("" "soul" t)
     ("" "latexsym" t)
     ("" "amssymb" t)
     ("" "hyperref" nil)
     "\\tolerance=1000")))
 '(package-selected-packages
   (quote
    (auctex-latexmk spacemacs-theme jedi elpy company-jedi company magit no-littering smooth-scrolling smart-tabs-mode move-text projectile yasnippet use-package tabbar sublime-themes pdf-tools multiple-cursors flycheck flx-ido auctex)))
 '(pdf-view-midnight-colors (quote ("#b2b2b2" . "#292b2e")))
 '(send-mail-function (quote mailclient-send-it))
 '(tramp-default-host "reedbuck" nil (tramp))
 '(tramp-default-method "ssh" nil (tramp))
 '(tramp-default-user "" nil (tramp))
 '(yas-use-menu nil))

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
