; extends

(assignment) @local_variable_declaration

(dictionary
  (pair
    key: (_) @field_name
    value: (_) @field_value
  )
)

(for_in_clause
  left: (_) @for_in_clause_left
  right: (_) @for_in_clause_right
) @for_in_clause

(if_clause
  (comparison_operator) @comparison_operator
) @if_clause

(type) @type
