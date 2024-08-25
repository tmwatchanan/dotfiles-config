;; extends

(dictionary
  (pair
    key: (_) @field_name
    value: (_) @field_value
  ) @field
)

(for_in_clause
  left: (_) @for_in_clause_left
  right: (_) @for_in_clause_right
) @for_in_clause

(if_clause
  (comparison_operator) @comparison_operator
) @if_clause

(type) @type

(keyword_argument
    name: (_) @keyword_argument_name
    value: (_) @keyword_argument_value
) @keyword_argument

(typed_parameter
  (identifier) @typed_parameter_identifier
  type: (_) @typed_parameter_type
) @typed_parameter

(typed_default_parameter
  name: (_) @typed_default_parameter_name
  .
  [
    type: (_)
  ] @typed_default_parameter_type
  value: (_) @typed_default_parameter_value
  (#make-range! "typed_default_parameter_name_type" @typed_default_parameter_name @typed_default_parameter_type)
)

(assignment
  left: (_) @assignment_left
  .
  [
    type: (_)
  ] @assignment_type
  (#make-range! "assignment_left_type" @assignment_left @assignment_type)
) @assignment @local_variable_declaration

(function_definition
  "->" @return_type_arrow
  .
  return_type: (_) @return_type_inner
  (#make-range! "return_type_outer" @return_type_arrow @return_type_inner)
)

(decorated_definition
  (decorator) @decorated_outer
  definition: (_) @decorated_inner
)
