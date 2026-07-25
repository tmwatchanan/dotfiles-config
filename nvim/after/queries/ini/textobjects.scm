; extends

(setting) @assignment.outer

(setting
  (setting_name) @assignment.lhs @key)

; `setting_value` spans everything after `=`, so trim the padding of `key = value`
(setting
  (setting_value) @assignment.rhs @assignment.inner @value
  (#trim! @assignment.rhs 1 1 1 1)
  (#trim! @assignment.inner 1 1 1 1)
  (#trim! @value 1 1 1 1))
