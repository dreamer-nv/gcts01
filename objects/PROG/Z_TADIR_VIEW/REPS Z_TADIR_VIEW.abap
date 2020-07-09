*&---------------------------------------------------------------------*
*& Report z_tadir_view
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_tadir_view.
DATA: go_alv TYPE REF TO cl_salv_table,
      gt_alv TYPE STANDARD TABLE OF z_tadir_view.

PARAMETERS: p_devcl TYPE devclass.

START-OF-SELECTION.
  PERFORM display.

FORM display.
  zcl_tadir=>get_object_list(
    EXPORTING
      iv_devclass = p_devcl
    IMPORTING
      et_table    = gt_alv
  ).

  TRY.
      cl_salv_table=>factory( IMPORTING r_salv_table = go_alv
                              CHANGING t_table = gt_alv ).

      go_alv->get_functions( )->set_all( abap_true ).

      go_alv->display( ).
    CATCH cx_salv_msg.
  ENDTRY.
ENDFORM..

CLASS lc_tadir_view_unit_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PUBLIC SECTION.
    METHODS _01_display_alv FOR TESTING.
    METHODS _02_display_alv FOR TESTING.
    METHODS _03_display_alv FOR TESTING.

  PRIVATE SECTION.
    CLASS-DATA: mr_test_environment TYPE REF TO if_cds_test_environment."if_osql_test_environment.

    CLASS-METHODS: class_setup.
    CLASS-METHODS: class_teardown.

    METHODS setup.
    METHODS teardown.

    DATA: mo_cut TYPE REF TO zcl_tadir.

ENDCLASS.

CLASS lc_tadir_view_unit_test IMPLEMENTATION.
  METHOD class_setup.
    "CDS
    mr_test_environment = cl_cds_test_environment=>create( i_for_entity = 'Z_TADIR_CDS' ).

    cl_salv_table=>factory( IMPORTING r_salv_table = go_alv
                           CHANGING t_table = gt_alv ).
    case sy-subrc.
      when others.
        endcase.

    DATA lt_table TYPE STANDARD TABLE OF tadir.
    lt_table = VALUE #(
    ( pgmid = 'R3TR' object = 'DOMA' obj_name = 'Z1' devclass = 'ZZZ' )
    ( pgmid = 'R3TR' object = 'DOMA' obj_name = 'Z2' devclass = 'ZZZ' )
    ( pgmid = 'R3TR' object = 'DOMA' obj_name = 'Z3' devclass = 'ZZZ' )
    ( pgmid = 'R3TR' object = 'DOMA' obj_name = 'Z4' devclass = 'YYY' )
    ( pgmid = 'R3TR' object = 'DOMA' obj_name = 'Z5' devclass = 'ZZZ' )
    ).

    DATA(lr_test_data) = cl_cds_test_data=>create( i_data = lt_table ).

    DATA(lr_tadir) = mr_test_environment->get_double( i_name = 'TADIR' ).

    lr_tadir->insert( lr_test_data ).

    p_devcl = 'ZZZ'.
  ENDMETHOD.

  METHOD setup.
    mo_cut = NEW #( ).
  ENDMETHOD.

  METHOD teardown.
    CLEAR mo_cut.
*    clear gt_alv.
*    mr_test_environment->clear_doubles(  ).
  ENDMETHOD.

  METHOD class_teardown.
    mr_test_environment->destroy( ).
  ENDMETHOD.

  METHOD _01_display_alv.

    PERFORM display.

    cl_abap_unit_assert=>assert_not_initial(
      EXPORTING
        act              =   gt_alv
        msg              =  'No data' ).

  ENDMETHOD.

  METHOD _02_display_alv.

*    PERFORM display.
*
    cl_abap_unit_assert=>assert_number_between(
      EXPORTING
        lower            = 0
        upper            = 4
        number           = lines( gt_alv ) ).

  ENDMETHOD.
  METHOD _03_display_alv.

*    PERFORM display.
*
    cl_abap_unit_assert=>assert_table_contains(
      EXPORTING
        line             = VALUE z_tadir_view( pgmid = 'R3TR' object = 'DOMA' obj_name = 'Z5' devclass = 'ZZZ' )
        table            = gt_alv
        msg              = 'Not my line' ).

  ENDMETHOD.

ENDCLASS.