*"* use this source file for your ABAP unit test classes
CLASS lc_tadir_unit_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PUBLIC SECTION.
    METHODS _01_get_object_list FOR TESTING.
    METHODS _02_get_object_list FOR TESTING.
    METHODS _03_get_object_list FOR TESTING.

  PRIVATE SECTION.
    CLASS-DATA: mr_test_environment TYPE REF TO if_cds_test_environment."if_osql_test_environment.

    CLASS-METHODS: class_setup.
    CLASS-METHODS: class_teardown.

    METHODS setup.
    METHODS teardown.

    DATA: mo_cut TYPE REF TO zcl_tadir.

ENDCLASS.

CLASS lc_tadir_unit_test IMPLEMENTATION.
  METHOD class_setup.
    DATA lt_table TYPE STANDARD TABLE OF tadir. "Z_TADIR_VIEW.

*    SELECT * FROM tadir UP  TO 4 ROWS INTO CORRESPONDING FIELDS OF TABLE @lt_table
*      WHERE devclass = 'MB' AND obj_name LIKE 'Z%'.

      lt_table = VALUE #(
      ( pgmid = 'R3TR' object = 'DOMA' obj_name = 'Z1' devclass = 'ZZZ' )
      ( pgmid = 'R3TR' object = 'DOMA' obj_name = 'Z2' devclass = 'ZZZ' )
      ( pgmid = 'R3TR' object = 'DOMA' obj_name = 'Z3' devclass = 'ZZZ' )
      ( pgmid = 'R3TR' object = 'DOMA' obj_name = 'Z4' devclass = 'YYY' )
      "!!! comment this row to activate AUnit error
      "( pgmid = 'R3TR' object = 'DOMA' obj_name = 'Z5' devclass = 'ZZZ' )
      ).

    "DDIC
    "mr_test_environment = cl_osql_test_environment=>create(  i_dependency_list = VALUE #( ( 'TADIR' ) ) ).

    "mr_test_environment->insert_test_data( i_data  = lt_table ).

    "CDS
    mr_test_environment = cl_cds_test_environment=>create( i_for_entity = 'Z_TADIR_CDS' ).

    DATA(lr_test_data) = cl_cds_test_data=>create( i_data = lt_table ).

    DATA(lr_tadir) = mr_test_environment->get_double( i_name = 'TADIR' ).

    lr_tadir->insert( lr_test_data ).

  ENDMETHOD.

  METHOD setup.
    mo_cut = NEW #( ).
  ENDMETHOD.

  METHOD teardown.
    CLEAR mo_cut.
*    mr_test_environment->clear_doubles(  ).
  ENDMETHOD.

  METHOD class_teardown.
    mr_test_environment->destroy( ).
  ENDMETHOD.

  METHOD _01_get_object_list.

    mo_cut->get_object_list( EXPORTING iv_devclass = 'ZZZ' IMPORTING et_table = data(lt_table) ).

    cl_abap_unit_assert=>assert_not_initial(
      EXPORTING
        act              =   lt_table
        msg              =  'No data' ).

  ENDMETHOD.

  METHOD _02_get_object_list.

    mo_cut->get_object_list( EXPORTING iv_devclass = 'ZZZ' IMPORTING et_table = data(lt_table) ).

    cl_abap_unit_assert=>assert_number_between(
      EXPORTING
        lower            = 4
        upper            = 4
        number           = lines( lt_table ) ).

  ENDMETHOD.
    METHOD _03_get_object_list.

    mo_cut->get_object_list( EXPORTING iv_devclass = 'ZZZ' IMPORTING et_table = data(lt_table) ).

    cl_abap_unit_assert=>assert_table_contains(
      EXPORTING
        line             = VALUE z_tadir_view( pgmid = 'R3TR' object = 'DOMA' obj_name = 'Z5' devclass = 'ZZZ' )
        table            = lt_table
        msg              = 'Not my line' ).

  ENDMETHOD.
ENDCLASS.