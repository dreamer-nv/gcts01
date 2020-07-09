CLASS zcl_tadir DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

PUBLIC SECTION.
TYPES: mtt_tadir_view TYPE STANDARD TABLE OF Z_TADIR_view.


class-METHODS: get_object_list
IMPORTING iv_devclass type devclass
EXPORTING et_table TYPE mtt_tadir_view.