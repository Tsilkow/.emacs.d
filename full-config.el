(require `package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(setq god-mode-enable-function-key-translation nil)

(defvar my_packages
  `(evil
    god-mode
    ;; undo-tree
    elpy
    general
    flycheck
    blacken
    wakib-keys
    expand-region
    )
)
      
(mapc #'(lambda (package)
	  (unless (package-installed-p package)
	    (package-install package)))
      my_packages)

(mapc #'(lambda (package)
	  (require package))
      my_packages)

(setq inhibit-startup-message t) ; Don't show startup screen
; (setq visible-bell t)            ; Flash when the bell rings

;; Turn off some unneeded UI elements
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(show-paren-mode 1)
(column-number-mode 1)
(desktop-save-mode 1)

;; Set default font
(set-face-attribute 'default nil
                    :family "Iosevka"
                    :height 110
                    :weight 'normal
                    :width 'expanded)

;; Store backup files in
(setq backup-directory-alist '(("." . "~/.emacs.d/saves/")))

;; use human-readable sizes in dired
(setq-default dired-listing-switches "-alh")

(evil-mode 0)
(god-mode)
;; (evil-set-undo-system `undo-tree)
;; (undo-tree-mode)
;; (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/saves/")))

(elpy-enable)
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

(setq flycheck-flake8rc "~/.emacs.d/flake8")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(vscode-dark-plus))
 '(custom-safe-themes
   '("e09401ab2c457e2e4d8b800e1c546dbc8339dc33b2877836ba5d9b6294ae6e55" "314045e2924c1390bcbc03c31dada444526b02e75f3dbef65199c7cbed0f4117" default))
 '(package-selected-packages '(ein vscode-dark-plus-theme elpy)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defun my-god-mode-update-mode-line ()
  (cond
   (god-local-mode
    (set-face-attribute 'mode-line nil
                        :foreground "#fafafa"
                        :background "#a157b3")
    (set-face-attribute 'mode-line-inactive nil
                        :foreground "#d4d4d4"
                        :background "#813992"))
   (t
    (set-face-attribute 'mode-line nil
			:foreground "#fafafa"
			:background "#007acc")
    (set-face-attribute 'mode-line-inactive nil
			:foreground "#d4d4d4"
			:background "#005aa3"))))

(add-hook 'post-command-hook #'my-god-mode-update-mode-line)

(global-display-line-numbers-mode 1) ; Display line numbers in every buffer
(setq-default fill-column 100)
(global-display-fill-column-indicator-mode t)
(setq indent-tabs-mode nil)
(setq-default indent-tabs-mode nil)

;; keybinds

;; (global-set-key (kbd "q") 'keyboard-escape-quit)
(global-set-key (kbd "<escape>") #'god-mode-all)
(global-set-key (kbd "<escape>") #'keyboard-quit)
(wakib-keys 1)

(define-key wakib-keys-overriding-map (kbd "<escape>") 'god-mode-all)
(define-key global-map (kbd "<tab>") 'indent-for-tab-command)
(define-key minibuffer-local-map (kbd "<tab>") 'minibuffer-complete)
(define-key isearch-mode-map (kbd "<tab>") 'isearch-repeat-forward)
(define-key wakib-keys-overriding-map (kbd "C-<tab>") 'indent-for-tab-command)
;; (define-key wakib-keys-overriding-map (kbd "C-q") 'keyboard-quit)
(define-key wakib-keys-overriding-map (kbd "C-q") 'keyboard-quit)
(define-key wakib-keys-overriding-map (kbd "C-w") 'other-window)
(define-key wakib-keys-overriding-map (kbd "C-i") 'write-file)
(define-key wakib-keys-overriding-map (kbd "C-o") 'find-file)
(define-key wakib-keys-overriding-map (kbd "C-p") 'revert-buffer)
(define-key wakib-keys-overriding-map (kbd "C-a") 'er/expand-region)
(define-key wakib-keys-overriding-map (kbd "M-a") 'er/contract-region)
;; (define-key wakib-keys-overriding-map (kbd "C-f") 'isearch-repeat-forward)
(define-key isearch-mode-map (kbd "C-f") 'isearch-repeat-forward)
;; (define-key wakib-keys-overriding-map (kbd "C-S-f") 'isearch-repeat-backward)
(define-key isearch-mode-map (kbd "C-r") 'isearch-repeat-backward)
(define-key wakib-keys-overriding-map (kbd "C-k") 'delete-region)
(define-key wakib-keys-overriding-map (kbd "M-k") 'kill-current-buffer)
(define-key wakib-keys-overriding-map (kbd "C-l") 'goto-line)
(define-key wakib-keys-overriding-map (kbd "M-z") 'undo-redo)
(define-key wakib-keys-overriding-map (kbd "C-,") 'backward-word)
(define-key wakib-keys-overriding-map (kbd "C-.") 'forward-word)
(define-key wakib-keys-overriding-map (kbd "C-/") 'comment-or-uncomment-region)

(defadvice kill-region (before slick-cut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (list (line-beginning-position) (line-beginning-position 2)))))

(defadvice delete-region (before slick-cut activate compile)
  "When called interactively with no active region, delete a single line instead."
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (list (line-beginning-position) (line-beginning-position 2)))))

(defadvice kill-ring-save (before slick-copy activate compile)
  "When called interactively with no active region, copy a single line instead."
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (message "Copied line")
     (list (line-beginning-position) (line-beginning-position 2)))))
