;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; pip install proselint pytest black poetry pyflakes isort python-language-server[all]
;; apt install discount go texlive jupyter gnuplot rustup

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Sreela Das"
      user-mail-address "sreela.das@gmail.com")

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
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq +latex-viewers '(zathura))
(setq +python-jupyter-repl-args '("--simple-prompt"))
(setq
    org-superstar-headline-bullets-list '("⁖" "◉" "○" "✸" "✿" "◉" "○" "✸" "✿")
)
(setq doom-font (font-spec :family "Fira Code" :size 18)
      ;;doom-variable-pitch-font (font-spec :family "ETBembo" :size 18)
      doom-variable-pitch-font (font-spec :family "Alegreya" :size 18))

;; Maximize emacs on load
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; Set redo keys to C-S-/
(after! undo-fu
  (map! :map undo-fu-mode-map "C-?" #'undo-fu-only-redo))

;; Hide Emphasis markers in org-mode markup
(after! org (setq org-hide-emphasis-markers t))


;; Org agenda display
(after! org-agenda
  (setq org-agenda-prefix-format
        '((agenda . " %i %-12:c%?-12t% s")
          ;; Indent todo items by level to show nesting
          (todo . " %i %-12:c%l")
          (tags . " %i %-12:c")
          (search . " %i %-12:c")))
  (setq org-agenda-include-diary t))

;; Add holidays to Agenda
(package! indian-holidays)
(package! canadian-holidays)


;; Org Agenda
(package! org-super-agenda)
(use-package! org-super-agenda
  :after org-agenda
  :config
  (setq org-super-agenda-groups '((:auto-dir-name t)))
  (org-super-agenda-mode))

;; Org Archive
(use-package! org-archive
  :after org
  :config
  (setq org-archive-location "archive.org::datetree/"))

;; Org Clock
(after! org-clock
  (setq org-clock-persist t)
  (org-clock-persistence-insinuate))

;; Org Capture Templates
;; (after! org
;;   (add-to-list 'org-capture-templates
;;              '(("l" "learn" entry
;;                (file+headline +org-capture-todo-file "learn")
;;                "* TODO %?\n :PROPERTIES:\n :CATEGORY: learn\n :END:\n %i\n"
;;                :prepend t :kill-buffer t))
