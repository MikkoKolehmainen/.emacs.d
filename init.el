;;; init.el -- my main configuration file

(setq read-process-output-max (* 2 1024 1024)) ;; 2mb
(setq gc-cons-threshold most-positive-fixnum)
(setq gc-cons-percentage 0.6)

(setq package-enable-at-startup nil)
(setq inhibit-startup-message t)

(server-start)

(when (native-comp-available-p)
  (setq native-comp-async-report-warnings-errors 'silent)
  (setq native-compile-prune-cache t))

;;; Package managers
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; initialize use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

(use-package no-littering
  :ensure t)

(setq make-backup-files nil)
(setq backup-inhibited nil)
(setq create-lockfiles nil)

(use-package which-os
  :straight (:host github :repo "kolemikko/which-os" :branch "master"))

(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

(setq default-directory "~/")
(set-default-coding-systems 'utf-8)

(fset 'yes-or-no-p 'y-or-n-p)

(use-package gcmh
  :ensure gcmh
  :diminish
  :functions
  gcmh-mode
  :init
  (gcmh-mode 1))

(run-with-idle-timer 4 nil
                     (lambda ()
                       "Clean up gc."
                       (setq gc-cons-threshold  67108864) ; 64M
                       (setq gc-cons-percentage 0.1) ; original value
                       (garbage-collect)))


(defvar emacs-config-dir (expand-file-name "~/.emacs.d/modules/")
  "Sub-directory containing config files.")

(add-to-list 'load-path emacs-config-dir)

(defvar my/module-list
  '("theme"
    "modeline"
    "icons"
    "evil-mode"
    "keys"
    "file-management"
    "completion"
    "org-mode"
    "prog"
    "lint-and-format"
    "misc"
    "utils"
    )
  "List of modules to load on startup.")

(dolist (pkg my/module-list)
  (if (file-readable-p (concat emacs-config-dir pkg ".el"))
      (load-library pkg)))

(setq initial-buffer-choice (lambda () (org-agenda nil "n")))

;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
