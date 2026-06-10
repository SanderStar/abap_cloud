CLASS zcl_ge328763_generate_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ge328763_generate_data IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA demo_data TYPE STANDARD TABLE OF zge328763_ss.
    DATA demo_data_line LIKE LINE OF demo_data.
    DATA number TYPE n LENGTH 3 .
    DATA long_time_stamp TYPE timestampl.

    WHILE number < 10.
      number += 1.
      GET TIME STAMP FIELD long_time_stamp.
      demo_data_line-client = sy-mandt.
      demo_data_line-order_uuid = xco_cp=>uuid( )->value.
      demo_data_line-order_id = number .
      demo_data_line-ordered_item = |HT-1{ number }|.
      demo_data_line-order_quantity =  number .
      "sy-datum
      demo_data_line-requested_delivery_date = xco_cp=>sy->date( )->as( xco_cp_time=>format->abap )->value.
      demo_data_line-total_price = number * 10.
      demo_data_line-currency = 'EUR'.
      "sy-uname
      demo_data_line-created_by = xco_cp=>sy->user( )->name.
      demo_data_line-created_at = long_time_stamp.
      "sy-uname
      demo_data_line-last_changed_by = xco_cp=>sy->user( )->name.
      demo_data_line-last_changed_at = long_time_stamp.
      demo_data_line-local_last_changed_at = long_time_stamp.
      APPEND demo_data_line TO demo_data.
    ENDWHILE.

    INSERT zge328763_ss FROM TABLE @demo_data.

    COMMIT WORK.

    SELECT * FROM zge328763_ss INTO TABLE @demo_data.

    LOOP AT demo_data INTO demo_data_line.
      out->write( demo_data_line ).
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
