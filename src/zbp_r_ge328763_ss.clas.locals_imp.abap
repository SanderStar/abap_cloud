CLASS lhc_zr_ge328763_ss DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR ShoppingCart
        RESULT result,
      setStatusToNew FOR DETERMINE ON MODIFY
        IMPORTING keys FOR ShoppingCart~setStatusToNew.

    METHODS calculateOrderID FOR DETERMINE ON SAVE
      IMPORTING keys FOR ShoppingCart~calculateOrderID.

    METHODS setStatusToSaved FOR DETERMINE ON SAVE
      IMPORTING keys FOR ShoppingCart~setStatusToSaved.
ENDCLASS.

CLASS lhc_zr_ge328763_ss IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD setStatusToNew.
    DATA update TYPE TABLE FOR UPDATE zr_ge328763_ss\\ShoppingCart.
    DATA update_line TYPE STRUCTURE FOR UPDATE zr_ge328763_ss\\ShoppingCart .

    "Read entity instances of the transferred keys
    READ ENTITIES OF zr_ge328763_ss IN LOCAL MODE
        ENTITY ShoppingCart
          ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).

    "retrieve all instances where the overallstatus is not yet set
    "and set the initial value to 'new'
    LOOP AT entities INTO DATA(entity) WHERE OverallStatus IS INITIAL.
      update_line-%tky    = entity-%tky.
      update_line-OverallStatus = zbp_r_ge328763_ss=>order_state-new.
      APPEND update_line TO update.
    ENDLOOP.

    MODIFY ENTITIES OF zr_ge328763_ss IN LOCAL MODE
      ENTITY ShoppingCart
        UPDATE FIELDS ( OverallStatus )
          WITH update
     REPORTED DATA(update_reported).

    "Set the changing parameter
    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.

  METHOD calculateOrderID.
    DATA update TYPE TABLE FOR UPDATE zr_ge328763_ss\\ShoppingCart.
    DATA update_line TYPE STRUCTURE FOR UPDATE zr_ge328763_ss\\ShoppingCart .

    READ ENTITIES OF zr_ge328763_ss IN LOCAL MODE
        ENTITY ShoppingCart
          ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).

    DELETE entities WHERE orderID IS NOT INITIAL.
    CHECK entities IS NOT INITIAL.

    "Poor man's approach to determine object_id ;-)

    SELECT MAX( order_ID ) FROM zge328763_ss INTO @DATA(max_object_id).

    LOOP AT entities INTO DATA(entity).
      update_line-%tky    = entity-%tky.
      update_line-orderid = max_object_id + 1.
      APPEND update_line TO update.
    ENDLOOP.

    MODIFY ENTITIES OF zr_ge328763_ss IN LOCAL MODE
      ENTITY ShoppingCart
        UPDATE FIELDS ( orderID )
          WITH update
    REPORTED DATA(update_reported).

    "Set the changing parameter
    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.

  METHOD setStatusToSaved.
    DATA update TYPE TABLE FOR UPDATE zr_ge328763_ss\\ShoppingCart.
    DATA update_line TYPE STRUCTURE FOR UPDATE zr_ge328763_ss\\ShoppingCart .

    READ ENTITIES OF zr_ge328763_ss IN LOCAL MODE
       ENTITY ShoppingCart
         ALL FIELDS WITH CORRESPONDING #( keys )
       RESULT DATA(entities).

    LOOP AT entities INTO DATA(entity) WHERE OverallStatus = zbp_r_ge328763_ss=>order_state-new.
      update_line-%tky    = entity-%tky.
      update_line-OverallStatus = zbp_r_ge328763_ss=>order_state-saved.
      APPEND update_line TO update.
    ENDLOOP.

    MODIFY ENTITIES OF zr_ge328763_ss IN LOCAL MODE
     ENTITY ShoppingCart
       UPDATE FIELDS ( OverallStatus )
         WITH update
    REPORTED DATA(update_reported).

    "Set the changing parameter
    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.

ENDCLASS.
