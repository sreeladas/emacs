;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; pip install proselint pytest black poetry pyflakes isort python-language-server[all]
;; apt install discount go texlive jupyter gnuplot rustup

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Sreela Das"
      user-mail-address "sreela.das@gmail.com")
(add-to-list 'load-path "~/.local/bin/")

(set-keyboard-coding-system nil)

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 10 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 10))
;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
(setq evil-move-beyond-eol t)
(setq evil-move-cursor-back nil)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; (setq org-directory "~/code/org")
;; (setq org-indent-indentation-per-level 4)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that could help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(require 'multiple-cursors)
(global-set-key (kbd "C->")  'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(setq +latex-viewers '(zathura))
(setq +python-jupyter-repl-args '("--simple-prompt"))
(setq
    org-superstar-headline-bullets-list '("⁖" "◉" "○" "✸" "✿" "◉" "○" "✸" "✿")
)
(setq doom-font (font-spec :family "Fira Code" :size 10)
      doom-variable-pitch-font (font-spec :family "ETBembo" :size 10)
      doom-variable-pitch-font (font-spec :family "Alegreya" :size 10)
)

;; Maximize emacs on load
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; Set redo keys to C-S-/
(after! undo-fu
  (map! :map undo-fu-mode-map "C-?" #'undo-fu-only-redo))

;; Hide Emphasis markers in org-mode markup
(after! org (setq org-hide-emphasis-markers t))

;;;; Mouse scrolling in terminal emacs
(unless (display-graphic-p)
  ;; activate mouse-based scrolling
  (xterm-mouse-mode 1)
  (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
  (global-set-key (kbd "<mouse-5>") 'scroll-up-line)
  )
;; Org Agenda
;;(package! org-super-agenda)
;;(use-package! org-super-agenda
;;  :after org-agenda
;;  :config
;;  (setq org-super-agenda-groups '((:auto-dir-name t)))
;;  (org-super-agenda-mode))

;; Org fancy-priorities-list
(after! org-fancy-priorities
  (setq

   org-priority-highest '?A
   org-priority-lowest  '?E
   org-priority-default '?C
   org-priority-faces
   '((
      (?A . (:foreground "firebrick3" :weight bold))
      (?B . (:foreground "goldenrod3" :weight bold))
      (?C . (:foreground "orange3"))
      (?D . (:foreground "MediumPurple3"))
      (?E . (:foreground "RosyBrown3"))
      )))
   org-fancy-priorities-list '("❗" "⚑" "⬆" "■" "⬇" "☕")
   (add-hook 'org-agenda-mode-hook 'org-fancy-priorities-mode)
)
(setq-default require-final-newline t)
(setenv "PYTHONPATH" (shell-command-to-string "$SHELL --login -c 'echo -n $PYTHONPATH'"))
(setq debug-on-error t)

;; MacOS add path vars to emacs shell
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))
(when (daemonp)
  (exec-path-from-shell-initialize))
(exec-path-from-shell-copy-env "PYTHONPATH")
