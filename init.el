;; Add things to be added
(add-to-list 'load-path "~/.emacs.d/non-elpa/")

;; separate the custom stuff from my stuff
(setq custom-file "~/.emacs.d/custom.el")
(if (file-exists-p custom-file)
    (progn
      (load custom-file)
      (message (concat "Loading " custom-file ".")))
  (message (concat "No " custom-file " to load.")))

;; Keep personal things out of here
(if (file-exists-p "~/.mellon.el")
    (progn
      (load "~/.mellon.el")
      (message "Loading sekrit keys."))
  (message "No sekrit keys to load."))

;; I'm a hippie
(global-set-key (kbd "M-RET") 'hippie-expand)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

(require 'package)
(setq package-archives '(;;("gnu" . "http://elpa.gnu.org/packages/")
			 ("marmalade" . "http://marmalade-repo.org/packages/")
			 ;;("melpa" . "http://melpa.milkbox.net/packages/")
                         ))
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))
(defvar my-packages '(clojure-mode
                      clojure-test-mode
                      nrepl
                      nrepl-ritz
                      ac-nrepl
                      slamhound
                      align-cljlet
                      hl-sexp
                      paredit
                      rainbow-delimiters
                      rainbow-mode
                      csv-mode
                      magit
                      gist
                      git-gutter
                      ido
                      refheap
                      deft
                      markdown-mode
		      color-theme-solarized
                      highlight-symbol))
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Look Pretty
(show-paren-mode +1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(line-number-mode 1)
(column-number-mode 1)
(add-hook 'prog-mode-hook 'linum-mode)

;; human readable dired file sizes
(setq dired-listing-switches "-alh")

;; (load-theme 'solarized-dark)
(load-theme 'emacslive-cyberpunk)

;; alpha alpha alpha
(defun toggle-transparency ()
  (interactive)
  (let ((param (cadr (frame-parameter nil 'alpha))))
    (if (and param (/= param 100))
        (set-frame-parameter nil 'alpha '(100 100))
      (set-frame-parameter nil 'alpha '(85 50)))))
(global-set-key (kbd "C-c t") 'toggle-transparency)


(require 'rainbow-mode)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook 'rainbow-mode)
(add-hook 'prog-mode-hook 'paredit-mode)
(add-hook 'prog-mode-hook 'highlight-symbol-mode)

;; my hack of window number mode to work with UK keyboards that do M-3 for #
(require 'window-number-super)
(window-number-mode 1) ;; for the window numbers
(window-number-super-mode 1) ;; for the super key binding

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Be sane
;; tabs are evil
(setq-default indent-tabs-mode nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Lisp hooks
(require 'clojure-mode)
(require 'clojure-test-mode)
(require 'nrepl)

(add-hook 'nrepl-interaction-mode-hook 'nrepl-turn-on-eldoc-mode)
(add-hook 'nrepl-mode-hook 'subword-mode)
(add-hook 'nrepl-interaction-mode-hook 'my-nrepl-mode-setup)
(defun my-nrepl-mode-setup ()
  (require 'nrepl-ritz))

(require 'highlight-symbol)
(require 'paredit)
(require 'rainbow-delimiters)
(setq lisp-hooks (lambda ()
		   (eldoc-mode +1)
                   (define-key paredit-mode-map
                     (kbd "{") 'paredit-open-curly)
                   (define-key paredit-mode-map
                     (kbd "}") 'paredit-close-curly)))
(add-hook 'emacs-lisp-mode-hook       lisp-hooks)
(add-hook 'lisp-mode-hook             lisp-hooks)
(add-hook 'lisp-interaction-mode-hook lisp-hooks)
(add-hook 'scheme-mode-hook           lisp-hooks)
(add-hook 'clojure-mode-hook          lisp-hooks)
(add-hook 'slime-repl-mode-hook       lisp-hooks)
(add-hook 'nrepl-mode-hook            lisp-hooks)

(add-hook 'javascript-mode-hook lisp-hooks)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; some sugar for kibit
;; Teach compile the syntax of the kibit output
(require 'compile)
(add-to-list 'compilation-error-regexp-alist-alist
	     '(kibit "At \\([^:]+\\):\\([[:digit:]]+\\):" 1 2 nil 0))
(add-to-list 'compilation-error-regexp-alist 'kibit)

;; A convenient command to run "lein kibit" in the project to which
;; the current emacs buffer belongs to.
(defun kibit ()
  "Run kibit on the current project.
Display the results in a hyperlinked *compilation* buffer."
  (interactive)
  (compile "lein kibit"))

(defun kibit-current-file ()
  "Run kibit on the current file.
Display the results in a hyperlinked *compilation* buffer."
  (interactive)
  (compile (concat "lein kibit " buffer-file-name)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Git Modes
(require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)

(require 'gist)

(require 'git-gutter-fringe)
(global-set-key (kbd "s-n") 'git-gutter:next-hunk)
(global-set-key (kbd "s-p") 'git-gutter:previous-hunk)
(global-git-gutter-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; erc


;; check channels
(erc-track-mode t)
(setq erc-track-exclude-types '("JOIN" "NICK" "PART" "QUIT" "MODE"
                                 "324" "329" "332" "333" "353" "477"))

;; don't show any of this
(setq erc-hide-list '("JOIN" "PART" "QUIT" "NICK"))
(add-hook 'erc-mode-hook 'erc-add-scroll-to-bottom)

(erc-spelling-mode 1)

;; ido
(require 'ido)
(setq ido-enable-flex-matching 1)
(ido-everywhere 1)

;; refheap
(require 'refheap)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Things broken on a Mac
(global-set-key (kbd "M-3") '(lambda () (interactive) (insert "#")))

(global-set-key (kbd "<f5>") '(lambda () (interactive)
					(nrepl-eval-expression-at-point)
                                        ;;slime-eval-defun
                                        ))

(setq exec-path '((concat (getenv "HOME") "/bin")
		  "/usr/local/bin"
		  "/usr/bin"
		  "/bin"
		  "/usr/sbin"
		  "/sbin"
		  "/usr/X11/bin"
		  "/usr/local/Library/Contributions/examples"
		  "/private/tmp/homebrew-emacs-HEAD-VoH4/lib-src"
		  "/private/tmp/homebrew-emacs-HEAD-VoH4/nextstep/Emacs.app/Contents/MacOS/libexec/emacs/24.0.91/i386-apple-darwin11.2.0"))

(setenv "PATH" (concat "~/bin:" (shell-command-to-string "echo $PATH")))

(setenv "PORT" "3000")
(put 'narrow-to-region 'disabled nil)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; deft and org-mode
;; flyspell-mode for text modes including org-mode
(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1)))
  (add-hook hook (lambda () (auto-fill-mode 1))))

(require 'deft)
(setq deft-directory "~/org/deft/")
(setq deft-extension "org")
(setq deft-text-mode 'org-mode)
(global-set-key [f8] 'deft)

(setq ispell-program-name "/usr/local/bin/aspell")


