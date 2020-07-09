METHOD get_object_list.

" change 1426

" method body to check AUnit test
SELECT * FROM Z_TADIR_CDS
"UP TO 10 ROWS
into TABLE @et_table
WHERE devclass = @iv_devclass.

" method adding just to check ATC check
" TABLES: tcurc.

DATA: lv_isocd type ISOCD.

SELECT SINGLE land1 FROM t001 INTO @DATA(lv_land) WHERE bukrs EQ '1000'.
SELECT SINGLE land1 FROM t001 INTO lv_land WHERE spras EQ 'EN'.

SELECT * FROM t001 INTO TABLE @DATA(lt_t001). "PERFORMANCE_CHECKLIST_HDB - with error
*select bukrs, waers from t001 into table @data(lt_t001). "PERFORMANCE_CHECKLIST_HDB - without error

*{ PERFORMANCE_CHECKLIST_HDB - with error
LOOP AT lt_t001 INTO DATA(ls_t001).
  SELECT SINGLE isocd INTO lv_isocd
    FROM tcurc WHERE waers = ls_t001-waers.
ENDLOOP.
*}

ENDMETHOD.