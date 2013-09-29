(in-package #:kafgsk)

;; инициализировать очередь страниц
;; добавить в очередь главную страницу сайта

;; @ для каждого урла страницы
;; загрузить адрес текущей страницы из очереди
;; загрузить страницу по этому адресу
;; найти все ссылки
;; если ссылка локальная - добавить в очередь, иначе - добавить в список внешних ссылок страницы

;; @ для каждой загруженной страницы
;; исключить общие элементы (дизайн, меню и;; т;; п;; ), очистить содержимое
;; построить прямой индекс
;; построить обратный индекс
;; tf:idf

(defun recur-files (path)
  ;; получаем список файлов и поддиректорий
  (let ((files (directory (merge-pathnames path "*.*")))
        (dirs  (directory (merge-pathnames path "*"))))
    (setf files (remove-if #'(lambda (x)
                               (find x dirs :test #'(lambda (a b)
                                                      (string= (format nil "~A" a)
                                                               (format nil "~A" b)))))
                           files))
    ;; для каждой поддиректории:
    (loop :for dir :in dirs :do
       ;; рекурсивно вызываем себя
       (setf files (append files (recur-files dir))))
    ;; возвращаем результат
    files))

(defun get-all-pages (path)
  (let ((all-files (recur-files path)))
    (loop :for file :in all-files :collect
       (list (format nil "~A" file)
             (alexandria:read-file-into-string file)))))

(defun get-search-words (search-query)
  (split-sequence:split-sequence #\Space search-query))


;; (defun search-word-in-page (word page)
;;   (search word page :test #'string=))

(let ((x 0))
  (defun search-word-in-page (word page)
    (let ((y (search word page)))
      (if (search word page)
          (progn
            (setf x (+ x 1))
            (search-word-in-page word (subseq page (+ y (length word)))))
          x))))
;; ищем, сколько раз слово встречается на странице

(defun search-in-pages (search-query pages)
  ;; разбить поисковый запрос на слова
  (let ((results nil)
        (words (get-search-words search-query)))
    (loop :for word :in words :do
       ;; для каждого слова: взять все страницы
       (loop :for (file page) :in pages :do
          ;; для каждой страницы: искать слово
          (if (not (eql (search-word-in-page word page) 0))
              ;; если слово есть (результат search-word-in-page не ноль)
              (push (cons (search-word-in-page word page) file) results))))
    ;; создаём конс-ячейку вида (количество слов на странице . файл)
    ;; и добавляем её в список результатов
              (mapcar #'cdr (sort results #'(lambda (a b) (> (car a) (car b)))))))
;; сортируем список результатов - берём car от каждой конс-ячейки (количество слов) и сортируем
;; список по возрастанию car-ов
;; потом от каждого элемента отсортированного списка берём cdr и получаем список файлов

(search-in-pages "факультет информационных технологий" (get-all-pages (path "content/")))


(defun relevance (pattern str &optional (start 0) (res 0))
  ;; Релевантность - это число, сопоставленное строке
  ;; (2 . "предположим, для примера, что вы пишете программу для...")
  ;; Инициализируем переменную возвращаемого результата :RES
  ;; Ищем первое вхождение слова :POS
  ;; Если нашли - инкрементируем X, и рекурсивно вызываем себя для оставшейся подстроки
  (let ((pos (search pattern str :start2 start)))
    (if pos
        (progn
          (incf res)
          (relevance pattern str (+ (length pattern) pos) res))
        (cons res str))))

(defun sort-strings (strings pattern)
  (mapcar #'cdr
          (sort (mapcar #'(lambda (x)
                            (relevance pattern x))
                        strings)
                #'(lambda (a b)
                    (> (car a) (car b))))))

;; tests

(defparameter *test*
  '("предположим, для примера, что вы пишете программу для подсчета релевантости"
    "для того чтобы ее правильно написать"
    "программа номер один и программа номер два"))

(defparameter *query-string* "для програм")

(defparameter *search-words* (get-search-words *query-string*))

(sort (mapcar #'(lambda (x)
                  (cons
                   (reduce #'+
                           (mapcar #'(lambda (y)
                                       (car (relevance y x)))
                                   *search-words*))
                   x))
              *test*)
      #'(lambda (a b)
          (> (car a) (car b))))

(sort-strings *test* "для")

(relevence "для" "предположим, для примера, что вы пишете программу для")


;; TODO
;; Stemming: Приводить слово к нормальной форме (отрезать окончания)
;; Оценивать релевантность
;;   Веса слов: TF-IDF
;;   BM25
;; Выводить сниппет
