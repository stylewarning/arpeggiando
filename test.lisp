(in-package :portaudio)

(defparameter +frames-per-buffer+ 1024)
(defparameter +sample-rate+ 44100d0
  "Audio samples per second.")
(defparameter +seconds+ 15)
(defparameter +sample-format+ :float)
(defparameter +num-channels+ 2)

;; separate-array-to-channels
;; merge-channels-into-array

(defun play-samples (samples)
    (with-audio
      (with-default-audio-stream (astream +num-channels+ +num-channels+
                                  :sample-format +sample-format+
                                  :sample-rate +sample-rate+
                                  :frames-per-buffer +frames-per-buffer+)
        (dolist (sample samples)
          (write-stream astream sample)))))

(defun record-microphone (time-in-seconds)
  (with-audio
    (with-default-audio-stream (astream +num-channels+ +num-channels+
                                :sample-format +sample-format+
                                :sample-rate +sample-rate+
                                :frames-per-buffer +frames-per-buffer+)
      (loop :repeat (round (* time-in-seconds +sample-rate+)
                           +frames-per-buffer+)
            :collect (read-stream astream)))))

(defun echo-for (time-in-seconds)
  (format t "RECORDING...~%")
  (force-output)
  (let ((samples (record-microphone time-in-seconds)))
    (format t "DONE.~%PLAYING...~%")
    (force-output)
    (play-samples samples)
    (format t "DONE.~%")
    (force-output)))
