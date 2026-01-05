class lhc_rap_tdat_cts definition final.
  public section.
    class-methods:
      get
        returning
          value(result) type ref to if_mbc_cp_rap_tdat_cts.

endclass.

class lhc_rap_tdat_cts implementation.
  method get.
    result = mbc_cp_api=>rap_tdat_cts( tdat_name = 'ZFI_TAXCODE'
                                       table_entity_relations = value #(
                                         ( entity = 'TaxCode' table = 'ZFI_T_TAXCODE' )
                                       ) ) ##NO_TEXT.
  endmethod.
endclass.
class lhc_zfi_i_taxcode_s definition final inheriting from cl_abap_behavior_handler.
  private section.
    methods:
      get_instance_features for instance features
        importing
                  keys   request requested_features for taxcodes
        result    result,
      get_global_authorizations for global authorization
        importing
        request requested_authorizations for taxcodes
        result result.
endclass.

class lhc_zfi_i_taxcode_s implementation.
  method get_instance_features.
    data: edit_flag            type abp_behv_op_ctrl    value if_abap_behv=>fc-o-enabled.

    if lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    endif.
    result = value #( for key in keys (
               %tky = key-%tky
               %action-edit = edit_flag
               %assoc-_taxcode = edit_flag ) ).
  endmethod.
  method get_global_authorizations.
*    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZFI_I_TAXCODE' ID 'ACTVT' FIELD '02'.
*    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
*                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%update      = if_abap_behv=>auth-allowed.
    result-%action-edit = if_abap_behv=>auth-allowed.
  endmethod.
endclass.
class lsc_zfi_i_taxcode_s definition final inheriting from cl_abap_behavior_saver.
  protected section.
    methods:
      save_modified redefinition.
endclass.

class lsc_zfi_i_taxcode_s implementation.
  method save_modified ##NEEDED.
  endmethod.
endclass.
class lhc_zfi_i_taxcode definition final inheriting from cl_abap_behavior_handler.
  private section.
    methods:
      get_global_features for global features
        importing
        request requested_features for taxcode
        result result,
      copytaxcode for modify
        importing
          keys for action taxcode~copytaxcode,
      get_global_authorizations for global authorization
        importing
        request requested_authorizations for taxcode
        result result,
      get_instance_features for instance features
        importing
                  keys   request requested_features for taxcode
        result    result.
endclass.

class lhc_zfi_i_taxcode implementation.
  method get_global_features.
    data edit_flag type abp_behv_op_ctrl value if_abap_behv=>fc-o-enabled.
    if lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    endif.
    result-%update = edit_flag.
    result-%delete = edit_flag.
  endmethod.
  method copytaxcode.
    data new_taxcode type table for create zfi_i_taxcode_s\_taxcode.

    if lines( keys ) > 1.
      insert mbc_cp_api=>message( )->get_select_only_one_entry( ) into table reported-%other.
      failed-taxcode = value #( for fkey in keys ( %tky = fkey-%tky ) ).
      return.
    endif.

    read entities of zfi_i_taxcode_s in local mode
      entity taxcode
        all fields with corresponding #( keys )
        result data(ref_taxcode)
        failed data(read_failed).

    if ref_taxcode is not initial.
      assign ref_taxcode[ 1 ] to field-symbol(<ref_taxcode>).
      data(key) = keys[ key draft %tky = <ref_taxcode>-%tky ].
      data(key_cid) = key-%cid.
      append value #(
        %tky-TaxCodeSingleID = 'VALUES'
        %is_draft = <ref_taxcode>-%is_draft
        %target = value #( (
          %cid = key_cid
          %is_draft = <ref_taxcode>-%is_draft
          %data = corresponding #( <ref_taxcode> except
          TaxCodeSingleID
          taxuuid
        ) ) )
      ) to new_taxcode assigning field-symbol(<new_taxcode>).

      modify entities of zfi_i_taxcode_s in local mode
        entity taxcodes create by \_taxcode
        fields (
                 mwskz
                 kschl
                 ktosl
                 taxrate
               ) with new_taxcode
        mapped data(mapped_create)
        failed failed
        reported reported.

      mapped-taxcode = mapped_create-taxcode.
    endif.

    insert lines of read_failed-taxcode into table failed-taxcode.

    if failed-taxcode is initial.
      reported-taxcode = value #( for created in mapped-taxcode (
                                                 %cid = created-%cid
                                                 %action-copytaxcode = if_abap_behv=>mk-on
                                                 %msg = mbc_cp_api=>message( )->get_item_copied( )
                                                 %path-taxcodes-%is_draft = created-%is_draft
                                                 %path-taxcodes-TaxCodeSingleID = 'VALUES' ) ).
    endif.
  endmethod.
  method get_global_authorizations.
*    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZFI_I_TAXCODE' ID 'ACTVT' FIELD '02'.
*    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
*                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%action-copytaxcode = if_abap_behv=>auth-allowed.
  endmethod.
  method get_instance_features.
    result = value #( for row in keys ( %tky = row-%tky
                                        %action-copytaxcode = cond #( when row-%is_draft = if_abap_behv=>mk-off then if_abap_behv=>fc-o-disabled else if_abap_behv=>fc-o-enabled )
    ) ).
  endmethod.
endclass.
