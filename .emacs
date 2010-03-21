;; .emacs

;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; enable visual feedback on selections
;(setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

;; always end a file with a newline
(setq require-final-newline 't)

;;; uncomment for CJK utf-8 support for non-Asian users
;; (require 'un-define)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                    CUSTOM                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(current-language-environment "UTF-8")
 '(global-hl-line-mode t)
 '(hl-line-sticky-flag nil)
 '(ido-auto-merge-delay-time 0.2)
 '(ido-enable-flex-matching t)
 '(indicate-buffer-boundaries (quote left))
 '(initial-buffer-choice t)
 '(menu-bar-mode nil)
 '(mouse-scroll-delay 0.0)
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(tool-bar-mode nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                     MODES                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; start emacs server
`(server-start)

;; Interactively do things
(ido-mode 1)
(setq 
 iswitchb-default-method 'samewindow ;;buffers by default swith to same window
 ido-everwhere t ;;ido for more dialogs
) 

;; Load things from that folder
(normal-top-level-add-to-load-path '("~/.emacs.d/lisp"))

;; get rid of yes-or-no questions. y or n is enough
(defalias 'yes-or-no-p 'y-or-n-p)

;;word warp
(global-visual-line-mode 1) 

;;line numbers
(global-linum-mode 1)

;;echo keys quickly
(setq echo-keystrokes 0.1)

;;be able to del selection
(delete-selection-mode)

;;only one line scroling
(setq scroll-step 1)

;;compile command
(setq compile-command "gcc -Wall ")

;;emacs does not throw backups whethever it pleases
(setq backup-directory-alist
      (cons '("." . "~/.emacs-backups") backup-directory-alist))

;; Special buffers in their own frames
;; nah, looks kinda bad in awesome
; (setq special-display-buffer-names
;         (nconc '("*Backtrace*" "*VC-log*" "*compilation*" "*grep*")
;   	     special-display-buffer-names))
; (add-to-list 'special-display-frame-alist '(tool-bar-lines . 0))

;;imenu under RMB
;; (cond (window-system
;;        ;; imenu works great, is part of the standard distribution
;;        ;; and is used by a lot of packages. This way, it is a better choice
;;        ;; than func-menu.
;;        (define-key global-map [mouse-3] 'imenu)
;;        ;; SHIFT-right mouse button: give me a list of bookmarks
;;        (define-key global-map [S-mouse-3] 'bookmark-menu-jump)
;;        ;; CTRL-right mouse button: set a bookmark
;;        (define-key global-map [C-down-mouse-3] 'bookmark-set)
;;        ))

;;ido for M-x
(require 'smex)
(add-hook 'after-init-hook 'smex-initialize)
(global-set-key (kbd "M-x") 'smex) ;;Keys for it
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c M-x") 'smex-update-and-run)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command);; This is old M-x.
(smex-auto-update) ;;update chache when idle

;;nxhtml
(load-file "/usr/share/emacs/site-lisp/nxhtml/autostart.el")

;; lua-moe for awesome rc.lua
(require 'lua-mode)

;; java script
(autoload #'espresso-mode "espresso" "Start espresso-mode" t)
(add-to-list 'auto-mode-alist '("\\.js$" . espresso-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . espresso-mode))

;; haskel mode
(load "~/.emacs.d/lisp/haskell-mode-2.7.0/haskell-site-file.el")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

;; PKGBUILD mode
(autoload 'pkgbuild-mode "pkgbuild-mode.el" "PKGBUILD mode." t)
(setq auto-mode-alist (append '(("/PKGBUILD$" . pkgbuild-mode)) auto-mode-alist))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                    CEDET                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (load-file "~/.emacs.d/cedet/common/cedet.el")
  (global-ede-mode 1)
; Enable the Project management system
  (semantic-load-enable-excessive-code-helpers)
  (global-semantic-stickyfunc-mode nil)
  (require 'semantic-ia)
; Enable prototype help and smart completion 
  (global-srecode-minor-mode 1)
; Enable template insertion menu

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                   ALIASES                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; shortening of often used commands
(defalias 'gf 'grep-find)
(defalias 'fd 'find-dired)
(defalias 'sh 'shell)

(defalias 'qrr 'query-replace-regexp)
(defalias 'lml 'list-matching-lines)
(defalias 'dml 'delete-matching-lines)
(defalias 'rof 'recentf-open-files)
(defalias 'cr 'comment-region)
(defalias 'ur' 'uncomment-region) 

(defalias 'eb 'eval-buffer)
(defalias 'er 'eval-region)
(defalias 'ee 'eval-expression)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                   BINDINGS                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "M-n") 'forward-paragraph)
(global-set-key (kbd "M-p") 'backward-paragraph)
(global-set-key (kbd "C-c b") 'menu-bar-mode)
(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "C-c h") 'help)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                   COLORS!                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'color-theme)
(require 'zenburn)
(require 'color-theme-dark-vee)
(color-theme-initialize)
(color-theme-dark-vee)
;;(color-theme-zenburn)
;;(color-theme-charcoal-black)

;;fancy transparency
(defun djcb-opacity-modify (&optional dec)
  "modify the transparency of the emacs frame; if DEC is t,
decrease the transparency, otherwise increase it in 5%-steps"
  (let* ((alpha-or-nil (frame-parameter nil 'alpha)) ; nil before setting
   (oldalpha (if alpha-or-nil alpha-or-nil 100))
   (newalpha (if dec (- oldalpha 5) (+ oldalpha 5))))
    (when (and (>= newalpha frame-alpha-lower-limit) (<= newalpha 100))
      (modify-frame-parameters nil (list (cons 'alpha newalpha))))))
 
;; C-8 will increase opacity (== decrease transparency)
;; C-9 will decrease opacity (== increase transparency)
;; C-0 will returns the state to normal
(global-set-key (kbd "C-8") '(lambda()(interactive)(djcb-opacity-modify)))
(global-set-key (kbd "C-9") '(lambda()(interactive)(djcb-opacity-modify t)))
(global-set-key (kbd "C-0") '(lambda()(interactive)
                               (modify-frame-parameters nil `((alpha . 100)))))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#000200" :foreground "wheat" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 90 :width normal :foundry "Schumacher" :family "Clean"))))
 '(mumamo-background-chunk-major ((((class color) (min-colors 88) (background dark)) (:background "#344"))))
 '(mumamo-background-chunk-submode1 ((((class color) (min-colors 88) (background dark)) (:background "#334"))))
 '(mumamo-background-chunk-submode2 ((((class color) (min-colors 88) (background dark)) (:background "#343"))))
 '(mumamo-background-chunk-submode3 ((((class color) (min-colors 88) (background dark)) (:background "#443"))))
 '(mumamo-background-chunk-submode4 ((((class color) (min-colors 88) (background dark)) (:background "#433"))))
 '(semantic-highlight-func-current-tag-face ((((class color) (background light)) (:background "gray40"))))
 '(woman-bold ((((min-colors 88) (background light)) (:foreground "deepskyblue3" :weight bold))))
 '(woman-italic ((((min-colors 88) (background light)) (:foreground "indian red" :underline t :slant italic))))
 '(zenburn-highlight-subtle ((t (:background "#565656")))))
