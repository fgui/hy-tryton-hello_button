(import [trytond.pool [PoolMeta]])
(import [trytond.model [fields ModelView]])
(def --all-- ["Hello"])


(defclass Hello []
  "Hello Code"
  [--name-- "hello"
   --metaclass-- PoolMeta
   ]

  (with-decorator classmethod
    (defn --setup-- [cls]
      (.--setup-- (super Hello cls))
      (.update cls._buttons
               {"capitalise"
                {}})
      (.update cls._error_messages
               {"name_capitalized_alerady_message" "Record with name '%(name)s' already capitalzed."
                "delete_hello_message" "REALLY??? delete?"
                "not_empty_surname_message" "Surnamer cannot be empty for '%(name)s"}
               )
      ))

  
  (with-decorator classmethod ModelView.button
    (defn capitalise [cls records]
      (for [r records] (do
                         (if (= r.name (.capitalize r.name))
                           (.raise_user_error cls
                                              "name_capitalized_alerady_message"
                                              {"name" r.name}
                                              )
                           (setv r.name (.capitalize r.name))
                           )))
      (.save cls records)
      ))

  (with-decorator classmethod
    (defn delete [cls records]
      (.raise_user_warning cls "ask-again-id"  "delete_hello_message" {})
      (.delete (super Hello cls) records)
      ))

  (with-decorator classmethod
    (defn validate [cls records]
      (.validate (super Hello cls) records)
      (for [r records] (do
                         (when (not r.surname)
                           (.raise_user_error cls
                                              "not_empty_surname_message"
                                              {"name" r.name})
                           )))
      ))
  
  )


