(import [trytond.pool [PoolMeta]])
(import [trytond.model [fields ModelView]])
(import [trytond.exceptions [UserError UserWarning]])
(import [trytond.i18n [gettext]])

(setv --all-- ["Hello"])


(defclass Hello [:metaclass PoolMeta]
  "Hello Code"
  [--name-- "hello"]

  (with-decorator classmethod
    (defn --setup-- [cls]
      (.--setup-- (super Hello cls))
      (.update cls._buttons
               {"capitalise"
                {}})
      ))

  
  (with-decorator classmethod ModelView.button
    (defn capitalise [cls records]
      (for [r records] (do
                         (if (= r.name (.capitalize r.name))
                             (raise (UserError
                                      (gettext 
                                        "hello_button.name_capitalized_alerady_message"
                                        :name r.name))
                                              )
                           (setv r.name (.capitalize r.name))
                           )))
      (.save cls records)
      ))

  (with-decorator classmethod
    (defn delete [cls records]
      (raise (UserWarning "ask-again-id"  (gettext "hello_button.delete_hello_message")))
      (.delete (super Hello cls) records)
      ))

  (with-decorator classmethod
    (defn validate [cls records]
      (.validate (super Hello cls) records)
      (for [r records] (do
                         (when (not r.surname)
                           (raise (UserError
                                    "hello_button.not_empty_surname_message"
                                    :name r.name))
                           )))
      ))
  
  )


