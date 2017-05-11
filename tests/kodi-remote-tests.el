

(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "https://melpa.org/packages/")
   t)
  (package-initialize))

;; (require 'ert)
(add-to-list 'load-path "~/.emacs.d/config/")
(require 'kodi-remote)
;; (setq kodi-host-name "mars:8080")

(ert-deftest fullscreen-test ()
  (should (booleanp (kodi-remote-is-fullscreen))))

(ert-deftest volume-test ()
  (should (integerp (kodi-remote-get-volume))))

(ert-deftest volume-complex-test ()
  (dotimes (x 20) (kodi-remote-volume-decrease))
  (should (eql (kodi-remote-get-volume )0))
  (dotimes (x 9) (kodi-remote-volume-increase))
  (should (eql (kodi-remote-get-volume )90)))


(ert-deftest active-window-is-home-test ()
  (should (string-equal "Home" (kodi-remote-get-active-window))))

(ert-deftest series-window-open-test ()
  (kodi-remote-series)
  (should (string-equal "*kodi-remote-series*" (buffer-name))))


(ert-deftest playlist-window-open-test ()
  (kodi-remote-playlist)
  (should (string-equal "*kodi-remote-playlist*" (buffer-name))))


(ert-deftest playlist-complex-test ()
  (kodi-remote-playlist)
  ;; (kodi-remote-playlist-clear)
  (kodi-remote-playlist-add-url "http://example.org/video1.avi")
  (sit-for 0.4)
  (kodi-remote-playlist-add-url "http://example.org/video2.avi")
  (sit-for 0.4)
  (kodi-remote-playlist-add-url "http://example.org/video3.avi")
  (sit-for 0.4)
  (revert-buffer)
  (should (equal (buffer-substring 1 (buffer-size)) "video1.avi\nvideo2.avi\nvideo3.avi"))
  (kodi-remote-playlist-move-down)
  (sit-for 0.4)
  (revert-buffer)
  (should (equal (buffer-substring 1 (buffer-size)) "video2.avi\nvideo1.avi\nvideo3.avi"))
  (kodi-remote-playlist-move-down)
  (sit-for 0.4)
  (revert-buffer)
  (should (equal (buffer-substring 1 (buffer-size)) "video1.avi\nvideo2.avi\nvideo3.avi"))
  (kodi-remote-playlist-move-up)
  (sit-for 0.4)
  (revert-buffer)
  (should (equal (buffer-substring 1 (buffer-size)) "video1.avi\nvideo2.avi\nvideo3.avi"))
  (next-line)
  (kodi-remote-playlist-move-up)
  (sit-for 0.4)
  (revert-buffer)
  (should (equal (buffer-substring 1 (buffer-size)) "video2.avi\nvideo1.avi\nvideo3.avi"))
  (kodi-remote-playlist-remove)
  (sit-for 0.4)
  (revert-buffer)
  (should (equal (buffer-substring 1 (buffer-size)) "video1.avi\nvideo3.avi"))
  (kodi-remote-playlist-clear)
  (sit-for 0.4)
  (revert-buffer)
  (should (equal (buffer-size) 0))
  )


