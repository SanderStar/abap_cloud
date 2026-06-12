CLASS zcl_GE328763_generate_data DEFINITION
PUBLIC
FINAL
CREATE PUBLIC .

PUBLIC SECTION.
INTERFACES if_oo_adt_classrun.

PROTECTED SECTION.
PRIVATE SECTION.
METHODS: delete_demo_data.
METHODS: generate_demo_data.

ENDCLASS.

CLASS zcl_GE328763_generate_data IMPLEMENTATION.
METHOD if_oo_adt_classrun~main.

delete_demo_data(  ).
out->write( 'Table entries deleted' ).

generate_demo_data(  ).
out->write( 'Demo data was generated' ).

ENDMETHOD.

METHOD delete_demo_data.
DELETE FROM zge328763_ss.
COMMIT WORK.
ENDMETHOD.


METHOD generate_demo_data.
  DATA: demo_data_line TYPE zge328763_ss,
        demo_data      TYPE STANDARD TABLE OF zge328763_ss,
        lv_idx         TYPE i,
        lv_order_id    TYPE n LENGTH 8.
  DATA long_time_stamp TYPE timestampl.

  " Generate 10 demo entries
  DO 10 TIMES.
    demo_data_line-client = '100'.
    demo_data_line-order_uuid = xco_cp=>uuid( )->value.
    lv_order_id = |{ sy-index WIDTH = 8 }|.
" Now lv_order_id contains the ALPHA-formatted value, e.g., '00000001'
    demo_data_line-order_id = lv_order_id.
    demo_data_line-ordered_item = |HT-{ 1000 + sy-index }|.

    demo_data_line-order_quantity = |{ sy-index WIDTH = 4 }|.

    demo_data_line-total_price = |{ 10 * sy-index }.00|.
    demo_data_line-currency = 'EUR'.
    demo_data_line-requested_delivery_date = xco_cp=>sy->date( )->as( xco_cp_time=>format->abap )->value.
    demo_data_line-created_by = xco_cp=>sy->user( )->name.
    demo_data_line-created_at = long_time_stamp.
    demo_data_line-last_changed_by = xco_cp=>sy->user( )->name.
    demo_data_line-last_changed_at = long_time_stamp.
    demo_data_line-local_last_changed_at = long_time_stamp.
    APPEND demo_data_line TO demo_data.
  ENDDO.

  INSERT zge328763_ss FROM TABLE @demo_data.
  COMMIT WORK.
  CLEAR demo_data.
ENDMETHOD.
ENDCLASS.
