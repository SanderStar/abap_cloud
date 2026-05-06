*"* use this source file for your ABAP unit test classes
CLASS ltcl_find_flights DEFINITION FOR TESTING
     DURATION MEDIUM RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    CLASS-DATA:
      the_carrier TYPE REF TO lcl_carrier,
      some_flight_data TYPE /lrn/cargoflight.

    CLASS-METHODS:
      class_setup.

    METHODS:
      setup,
      teardown.

    METHODS:
      test_find_cargo_flight FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_find_flights IMPLEMENTATION.

  METHOD setup.

  ENDMETHOD.

  METHOD teardown.

  ENDMETHOD.

  METHOD test_find_cargo_flight.

    the_carrier->find_cargo_flight(
         EXPORTING
           i_airport_from_id = some_flight_data-airport_from_id
           i_airport_to_id   = some_flight_data-airport_to_id
           i_from_date       = some_flight_data-flight_date
           i_cargo           = 1
         IMPORTING
           e_flight =     DATA(flight)
           e_days_later = DATA(days_later) ).

      cl_abap_unit_assert=>assert_not_initial( act = flight ).
      cl_abap_unit_assert=>assert_equals( act = 0 exp = days_later ).

  ENDMETHOD.

  METHOD class_setup.
    SELECT SINGLE carrier_id,
           connection_id,
           flight_date,
           airport_from_id,
           airport_to_id
      FROM /lrn/cargoflight
      WHERE maximum_load - actual_load >= 1
      INTO CORRESPONDING FIELDS OF @some_flight_data ##WARN_OK.
      .


    cl_abap_unit_assert=>assert_not_initial( act = some_flight_data ).

    TRY.
        the_carrier = NEW lcl_carrier( i_carrier_id = some_flight_data-carrier_id ).
     CATCH cx_abap_invalid_value.
        cl_abap_unit_assert=>fail( msg = 'Failed to instantiate lcl_carrier' ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
