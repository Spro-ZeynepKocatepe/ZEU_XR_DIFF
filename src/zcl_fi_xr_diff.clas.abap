class zcl_fi_xr_diff definition public final create public.
  public section.
    interfaces:
      if_oo_adt_classrun.

    constants:
      co_true  type abap_boolean value 'X',
      co_false type abap_boolean value '',
      co_msgcl type sy-msgid     value 'ZFI_XR_DIFF'.

    class-methods
      set_taxcode_initial_values.

  protected section.
  private section.
ENDCLASS.



CLASS ZCL_FI_XR_DIFF IMPLEMENTATION.


  method if_oo_adt_classrun~main.
    set_taxcode_initial_values( ).
  endmethod.


  method set_taxcode_initial_values.
    data:
      lt_taxcode_trg type table of zfi_t_taxcode,
      lv_taxuuid     type sysuuid_x16.

    select single count(*) from zfi_t_taxcode.
    if sy-subrc ne 0.
      select * from i_taxcode
        order by taxcode
        into table @final(lt_taxcode_src).

      loop at lt_taxcode_src into data(ls_taxcode_src).
        clear lv_taxuuid.

        try.
            lv_taxuuid = cl_system_uuid=>create_uuid_x16_static( ).

            append value #(
              taxuuid = lv_taxuuid
              mwskz   = ls_taxcode_src-taxcode
            ) to lt_taxcode_trg.
          catch cx_uuid_error into data(lx_uuid).
        endtry.
      endloop.
      if sy-subrc eq 0.
        insert zfi_t_taxcode from table @lt_taxcode_trg.
        if sy-subrc eq 0.
          commit work.
        endif.
      endif.
    endif.
  endmethod.
ENDCLASS.
