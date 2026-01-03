;; extends

; SQL -------------------------------------------------------------------------

; Inject SQL syntax highlighting into strings assigned to variables containing "sql" or "query"
(assignment
    left: (identifier) @_var_name
    (#match? @_var_name ".*(sql|query).*")
    right: (string
        ((string_content)(interpolation)*)+ @injection.content)
    (#set! injection.language "sql"))

; Also handle augmented assignments (+=, etc.) for SQL
(augmented_assignment
    left: (identifier) @_var_name
    (#match? @_var_name ".*(sql|query).*")
    right: (string
        ((string_content)(interpolation)*)+ @injection.content)
    (#set! injection.language "sql"))

(call
  function: (attribute attribute: (identifier) @id (#match? @id "execute|read_sql"))
  arguments: (argument_list
    (string (string_content) @injection.content (#set! injection.language "sql"))))

; (
;     ((string_content)(interpolation)*)+ @injection.content
; (#vim-match? @injection.content "^\s*SELECT|FROM|(INNER |LEFT )?JOIN|WHERE|CREATE|DROP|INSERT|UPDATE|ALTER|ORDER BY.*$")
;
;     (#set! injection.language "sql")
; )

; PySpark ----------------------------------------------------------------------

(
    ((string_content)(interpolation)*)+ @injection.content
    (#match? @injection.content "(import|spark|df)")
    (#set! injection.language "python")
)

