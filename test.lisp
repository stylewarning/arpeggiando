(in-package :portaudio)

(defparameter +frames-per-buffer+ 1024)
(defparameter +sample-rate+ 44100d0
  "Audio samples per second.")
(defparameter +seconds+ 15)
(defparameter +sample-format+ :float)
(defparameter +num-channels+ 2)

(defvar *console* (iolib.trivial-sockets:open-stream "127.0.0.1" 6007))

;; separate-array-to-channels
;; merge-channels-into-array

(defun play-frame-buffers (samples)
  (with-audio
      (with-default-audio-stream (astream
                                  +num-channels+ +num-channels+
                                  :sample-format +sample-format+
                                  :sample-rate +sample-rate+
                                  :frames-per-buffer +frames-per-buffer+)
        (dolist (sample samples)
          (write-stream astream sample)))))

(defun record-microphone (time-in-seconds)
  (with-audio
    (with-default-audio-stream (astream
                                +num-channels+ +num-channels+
                                :sample-format +sample-format+
                                :sample-rate +sample-rate+
                                :frames-per-buffer +frames-per-buffer+)
      (loop :repeat (round (* time-in-seconds +sample-rate+)
                           +frames-per-buffer+)
            :for sample := (read-stream astream)
            :collect sample))))

(defun echo-for (time-in-seconds)
  (format t ";;; RECORDING...~%")
  (force-output)
  (let ((buffers (record-microphone time-in-seconds)))
    (format t ";;; DONE.~%;;; PLAYING...~%")
    (force-output)
    (play-frame-buffers buffers)
    (format t ";;; DONE.~%")
    (force-output)))

(defun write-buffers-to-file (filename frame-buffers)
  (with-open-file (stream filename :direction :output
                                   :if-exists :supersede
                                   :if-does-not-exist :create)
    (dolist (buffer frame-buffers)
      (loop :for sample :across buffer
            :do (progn 
                  (princ sample stream)
                  (terpri stream)))))
  filename)
