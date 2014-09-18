;; ppYang's .emacs initialization file

;; Set up the keyboard so the delete key on both the regular keyboard
;; and the keypad delete the character under the cursor and to the right
;; under X, instead of the default, backspace behavior.
(global-set-key [delete] 'delete-char)
(global-set-key [kp-delete] 'delete-char)

;; Turn on font-lock mode for Emacs
;;(cond ((not running-xemacs)
;;       (global-font-lock-mode t)
;;))

;; Visual feedback on selections
(setq-default transient-mark-mode t)

;; Always end a file with a newline
(setq require-final-newline t)

;; Stop at the end of the file, not just add lines
(setq next-line-add-newlines nil)

;; Enable wheelmouse support by default
(cond (window-system
       (mwheel-install)
))

;;raully's emacs config options 06-03-22

;;;;;;;;;;;;;;;;;;environment 
(setq default-directory "~/Workspace/daixm/git/website/")
(setq inhibit-startup-message nil)
(setq load-path (append load-path'("~/Library/emacs/lib/")))
;;(normal-erase-is-backspace-mode 1)

;;display policies
(global-font-lock-mode t)
(transient-mark-mode t)
(mouse-avoidance-mode 'animate)
(auto-image-file-mode)
(setq-default truncate-partial-width-windows nil)
(setq default-fill-column 60)
(setq frame-title-format "raully@%b")
;(menu-bar-mode 1)
;(tool-bar-mode 1)

;;set background and forward color------------------------------------
;;(setq default-frame-alist
;      '(   (foreground-color . "Wheat")
;	   (background-color . "DarkSlateGray")
;	   (cursor-color     . "Orchid")
;))

; Show date and time
(setq display-time-format "%m-%d %R")
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(display-time-mode t)

;; backup policies
(setq make-backup-files t)
(setq version-control t)
(setq kept-old-versions 2)
(setq kept-new-versions 5)
(setq delete-old-versions t)
(setq backup-directory-alist '(("" . "~/.emacs.d/backup")))
;;auto save
(setq delete-auto-save-files t)

;;;;;;;;;;;;;;;;;global key bind
;;add new prefix;
(define-prefix-command 'meta-g-map);
(global-set-key (kbd "M-g") 'meta-g-map)
(global-unset-key "")
(global-set-key (kbd "M-g") 'goto-line)
(global-set-key (kbd "C-c n")  'setnu-mode)
(global-set-key (kbd "C-o") 'other-window)
(global-set-key (kbd "C-x o") 'other-frame)
(global-set-key "\357" 'open-line)
;; comment-region
(global-set-key (kbd "C-x M-c") 'comment-region)
(global-set-key (kbd "C-x M-u") 'uncomment-region)
''
(global-set-key (kbd "C-x C-r") 'replace-regexp)

(add-hook 'c++-mode-hook
 	  (lambda ()
	    (c-set-style "cc-mode")
 	    (hs-minor-mode t)
	    ;(hl-line-mode t)
	    (local-set-key "\C-c\t" 'complete-symbol)
	    ;;	    (local-set-key "\C-m" 'newline-and-indent)
	    (setq mslk-c++-key (make-keymap))
	    ;;	    (local-set-key "\C-j" mslk-c++-key)
					;(define-key mslk-c++-key "\C-j" 'complete-symbol)
 	    (define-key mslk-c++-key "\C-x a-h" 'hs-hide-all)
 	    (define-key mslk-c++-key "\C-x a-s" 'hs-show-all)
 	    (define-key mslk-c++-key "\C-x a-m" 'hs-hide-block)
 	    (define-key mslk-c++-key "\C-x a-n" 'hs-show-block)
 	    (define-key mslk-c++-key "\C-x a-l" 'hs-hide-level)
 	    (define-key mslk-c++-key "\C-x a-t" 'hs-toggle-hiding)
 	    ))

(add-hook 'c-mode-hook 'c++-mode)

;;;;;cedet
(load-file "~/Library/emacs/lib/cedet-1.0pre4/common/cedet.el")

;; Enabling various SEMANTIC minor modes.  See semantic/INSTALL for more ideas.
;; Select one of the following:

;; * This enables the database and idle reparse engines
;;(semantic-load-enable-minimum-features)

;; * This enables some tools useful for coding, such as summary mode
;;   imenu support, and the semantic navigator
;;(semantic-load-enable-code-helpers)

;;(setq semantic-idle-scheduler-idle-time 432000)

;; * This enables even more coding tools such as the nascent intellisense mode
;;   decoration mode, and stickyfunc mode (plus regular code helpers)
;; (semantic-load-enable-guady-code-helpers)

;; * This turns on which-func support (Plus all other code helpers)
;; (semantic-load-enable-excessive-code-helpers)

;; This turns on modes that aid in grammar writing and semantic tool
;; development.  It does not enable any other features such as code
;; helpers above.
;; (semantic-load-enable-semantic-debugging-helpers)


;;;; ecb ;;;;
(add-to-list 'load-path "~/Library/emacs/lib/ecb-2.32")
(require 'ecb)

;;;; etags ;;;;

;;(setq tags-file-name "~/app/search/news/searchui/TAGS")

;;;; deal with ^M ;;;;
(defun dos-unix () (interactive)
  (goto-char (point-min))
  (while (search-forward "\r" nil t) (replace-match "")))
(defun unix-dos () (interactive)
  (goto-char (point-min))
  (while (search-forward "\n" nil t) (replace-match "\r\n")))

;;;; about etags ;;;;
(defun lev/find-tag (&optional show-only)
  "Show tag in other window with no prompt in minibuf."
;  (interactive)
  (let ((default (funcall (or find-tag-default-function
                              (get major-mode 'find-tag-default-function)
                              'find-tag-default))))
    (if show-only
        (progn (find-tag-other-window default)
               (shrink-window (- (window-height) 12)) ;; ÏÞÖÆÎª 12 ÐÐ
               (recenter 1)
               (other-window 1))
      (find-tag default))))

(defun sucha-generate-tag-table ()
  "Generate tag tables under current directory(Linux)."
  (interactive)
  (let
      ((exp "")
       (dir ""))
    (setq dir
          (read-from-minibuffer "generate tags in: " default-directory)
          exp
          (read-from-minibuffer "suffix: "))
    (with-temp-buffer
      (shell-command
       (concat "find " dir " -name \"" exp "\" | xargs etags ")
       (buffer-name)))))

(defun sucha-release-small-tag-window ()
  "Kill other window also pop tag mark."
  (interactive)
  (delete-other-windows)
  (ignore-errors
    (pop-tag-mark)))
;;;;; key binding ;;;;;
(global-set-key (kbd "M-.") `find-tag)
(global-set-key (kbd "M-/") '(lambda () (interactive) (lev/find-tag t)))
(global-set-key (kbd "M-,") 'sucha-release-small-tag-window)
(global-set-key (kbd "C-c t") 'visit-tags-table)

;;;; session ;;;;
(require 'session)
(add-hook 'after-init-hook 'session-initialize)
(setq session-save-file "~/.emacs.d/session")
;work with desktop to avoid repetition
(setq desktop-globals-to-save '(desktop-missing-file-warning))

;;;; desptop ;;;;
(load "desktop") 
(require 'desktop)
(desktop-load-default) 
(desktop-read)
(desktop-save-mode 1)
(setq desktop-path '("~/.emacs.d/"))
(setq desktop-dirname "~/.emacs.d/")
(setq desktop-base-file-name ".emacs-desktop")


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(display-time-mode t)
 '(ecb-options-version "2.32")
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; by ppYang for macbook pro
;'(set-frame-font "Courier New-14")

;; UTF-8 settings
;; (set-language-environment "UTF-8")
;; (set-terminal-coding-system 'utf-8)
;; (set-keyboard-coding-system 'utf-8)
;; (set-clipboard-coding-system 'utf-8)
;; (set-buffer-file-coding-system 'utf-8)
;; (set-selection-coding-system 'utf-8)
;; (modify-coding-system-alist 'process "*" 'utf-8)

;; (setq default-process-coding-system
;;       '(chinese-gbk . chinese-gbk))
;; (setq-default pathname-coding-system 'chinese-gbk)

;; 配色方案
(add-to-list 'load-path "~/Library/emacs/lib/color-theme-6.6.0")
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
;;     (color-theme-blue-mood)
     (color-theme-calm-forest)
))

;; semantic.cache存储路径
(setq semanticdb-default-save-directory "~/Library/emacs/semantic")

;; 2011.06.09 add: php-mode
(add-to-list 'load-path "~/Library/emacs/lib/php-mode-1.5.0")
(require 'php-mode)

;; 2011.06.10 add: mode auto alist
(setq auto-mode-alist
      ;; 将文件模式和文件后缀关联起来
      (append '(("\\.py\\'" . python-mode)
                ("\\.php\\'" . php-mode)
                ("\\.dq\\'" . php-mode)
                )
	      auto-mode-alist))
;; 2011.06.13 add: 缩进设定为4
(setq standard-indent 4)

;; 2011.11.25 add: ess for connect with R
;; (setq load-path (append load-path'("/usr/share/emacs/site-lisp/ess/lisp/")))
;; (require 'ess-site)
;; 2012.06.17 add: ess chinese support
;; (add-hook 'ess-post-run-hook
;;	  (lambda ()
;;	    (set-buffer-file-coding-system 'utf-8 'utf-8)
;;	    (set-buffer-process-coding-system 'utf-8 'utf-8)
;;	    )
;;	  )

;; 2012.06.17 add: knitr support
;;(require 'ess-knitr)
;;(global-set-key (kbd "C-x C-k") 'ess-swv-knit)

;; 2013.02.21 add: mit-scheme
(setq scheme-program-name
    "/Users/ppyang/bin/MIT-SCHEME/mit-scheme")
(require 'xscheme)
(load-library "scheme")

;; rectangle矩阵操作
(require 'rect-mark)
(global-set-key (kbd "C-x r C-z") 'rm-set-mark)
(global-set-key (kbd "C-x r C-x C-x") 'rm-exchange-point-and-mark)
(global-set-key (kbd "C-x r C-w") 'rm-kill-region)
(global-set-key (kbd "C-x r M-w") 'rm-kill-ring-save)
(global-set-key (kbd "C-x r C-y") 'yank-rectangle)
;(global-set-key   [down-mouse-2]  'rm-mouse-drag-region)    ; mouse drag rect 
(global-set-key   "\M-I"          'string-insert-rectangle) ; insert string

;; 2014.01.09 改变中文的字体
(set-default-font "Courier New-14")
(set-fontset-font
    (frame-parameter nil 'font)
    'han
    (font-spec :family "STHeiti" :size 14))

(setq default-frame-alist 
      (append 
       '((font . "Courier New-14")) default-frame-alist))

;; 2014.06.07 对emacs的python支持
;; 包管理
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  )

(elpy-enable)
;; 修改一个bug
(define-key yas-minor-mode-map (kbd "C-c k") 'yas-expand)
(define-key global-map (kbd "C-c o") 'iedit-mode)
;; 强制使用进行pep8检查
(setq python-check-command "flake8")


;; 设置命令搜索路径
(defun set-exec-path-from-shell-PATH ()
  "Sets the exec-path to the same value used by the user shell"
  (let ((path-from-shell
         (replace-regexp-in-string
          "[[:space:]\n]*$" ""
          (shell-command-to-string "$SHELL -l -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))
 
(set-exec-path-from-shell-PATH)

;; 设置初始窗口位置及大小
(set-frame-position (selected-frame) 0 0)
(set-frame-width (selected-frame) 176)
(set-frame-height (selected-frame) 51)

;; 设置html模式缩进
(add-hook 'html-mode-hook
  (lambda ()
    ;; Default indentation is usually 2 spaces, changing to 4.
    (set (make-local-variable 'sgml-basic-offset) 4)))

;; 支持进行sudo的保存
(require 'sudo-save)

;; org && github pages settings
(require 'org-publish)
(setq org-publish-project-alist
      '(("org-acaird"
         ;; Path to your org files.
         :base-directory "~/Workspace/blog/raully7.github.io/_org" (srcdir)
         :base-extension "org" (extension)
         ;; Path to your Jekyll project.
         :publishing-directory "~/Workspace/blog/raully7.github.io/_posts" (destination)
         :recursive t
	 :publishing-function org-html-publish-to-html
         :headline-levels 4
         :html-extension "html"
         :body-only t ;; Only export section between <body> </body> (body-only)
         )
        ("org-static-acaird"
         :base-directory "~/Workspace/blog/raully7.github.io/assets" (imgsrc)
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|php" (imgext)
         :publishing-directory "~/Workspace/blog/raully7.github.io/assets" (imgdest)
         :recursive t
         :publishing-function org-publish-attachment)

        ("blog" :components ("org-acaird" "org-static-acaird"))
        ))

(add-hook 'org-mode-hook (lambda () (setq truncate-lines nil)))


;; 支持utf-8的shell
(defun utf8-shell ()
  "Create Shell that supports UTF-8."
  (interactive)
  (set-default-coding-systems 'utf-8)
  (shell))
(global-set-key (kbd "C-x SPC") 'utf8-shell)
