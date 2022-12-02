#!/usr/bin/env newlisp

(setf input (open "input.txt" "read")
      candidates '(0))

(while (read-line input)
  (cond
    ((empty? (current-line))
      (setf candidates (sort candidates))
      (when (> (length candidates) 3)
        (pop candidates))
      (push 0 candidates))

    (true
      (inc (first candidates) (int (current-line) 0 10)))))

(setf candidates (sort candidates))
(when (> (length candidates) 3)
  (pop candidates))

(println (apply '+ candidates))
(exit 0)
