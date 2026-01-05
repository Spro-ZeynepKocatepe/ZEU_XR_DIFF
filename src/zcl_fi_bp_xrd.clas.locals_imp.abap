class lcl_buffer definition inheriting from cl_abap_behv.
  public section.
    types:
      begin of ts_txpid,
        txuuid type sysuuid_x16,
        pid    type abp_behv_pid,
      end of ts_txpid,
      tt_txpid type standard table of ts_txpid with default key.

    types:
      ts_failed_late                 type response for failed late zfi_i_xrdh,
      ts_reported_late               type response for reported late zfi_i_xrdh,
      tt_entity_c_xrdh               type table for create zfi_i_xrdh,
      ts_entity_c_xrdh               type structure for create zfi_i_xrdh,
      tt_entity_c_xrdi               type table for create zfi_i_xrdh\_item,
      ts_entity_c_xrdi               type structure for create zfi_i_xrdh\_item,
      tt_xrdh                        type table of zfi_t_xrdh with default key,
      tt_xrdi                        type table of zfi_t_xrdi with default key,
      ts_xrdh                        type zfi_t_xrdh,
      ts_xrdi                        type zfi_t_xrdi,
      tt_currencyclearing_key        type table for action import zfi_i_xrdh~currencyclearing,
      tt_reversecurrencyclearing_key type table for action import zfi_i_xrdh~reversecurrencyclearing,
      tt_reversexrdifference_key     type table for action import zfi_i_xrdh~reversexrdifference.

    constants:
      co_txstat_a type zfi_e_txstat value 'A',
      co_txstat_b type zfi_e_txstat value 'B',
      co_txstat_c type zfi_e_txstat value 'C'.

    class-methods:
      get_instance
        returning
          value(ro_instance) type ref to lcl_buffer.

    methods
      add_entity_xrdh
        importing
          is_entity type ts_entity_c_xrdh.
    methods
      add_entity_xrdi
        importing
          is_entity type ts_entity_c_xrdi.
    methods
      prepare_db_tables.
    methods
      add_xrdh_by_txuuid
        importing
          iv_txuuid type sysuuid_x16.
    methods
      add_xrdi_by_txuuid
        importing
          iv_txuuid type sysuuid_x16.
    methods
      add_xrdh
        importing
          is_data type ts_xrdh.
    methods
      add_xrdi
        importing
          is_data type ts_xrdi.
    methods
      add_xrdh_upd
        importing
          is_data type ts_xrdh.
    methods
      get_xrdh
        returning
          value(rt_data) type tt_xrdh.
    methods
      get_xrdi
        returning
          value(rt_data) type tt_xrdi.
    methods
      set_je_pid_by_txuuid
        importing
          iv_txuuid type sysuuid_x16
          iv_pid    type abp_behv_pid.
    methods
      create_accdoc_numbers.
    methods
      set_xr_diff_invoice_by_txuuid
        importing
          iv_txuuid type sysuuid_x16
          iv_bukrs  type bukrs
          iv_gjahr  type gjahr
          iv_belnr  type belnr_d.
    methods
      set_clearing_doc_by_txuuid
        importing
          iv_txuuid type sysuuid_x16
          iv_auggj  type gjahr
          iv_augbl  type augbl.
    methods
      set_curr_clearing_by_txuuid
        importing
          iv_txuuid type sysuuid_x16
          iv_bukrs  type bukrs
          iv_gjahr  type gjahr
          iv_belnr  type belnr_d.
    methods
      set_transaction_stat_by_txuuid
        importing
          iv_txuuid type sysuuid_x16
          iv_txstat type zfi_e_txstat.
    methods
      create_xr_diff_invoices
        changing
          failed   type ts_failed_late
          reported type ts_reported_late.
    methods
      create_currency_clearing_docs
        changing
          failed   type ts_failed_late
          reported type ts_reported_late.
    methods
      reverse_currency_clearing_docs
        changing
          failed   type ts_failed_late
          reported type ts_reported_late.
    methods
      reverse_xr_difference_docs
        changing
          failed   type ts_failed_late
          reported type ts_reported_late.
    methods
      save_db.
    methods
      get_currency_clearing_keys
        returning
          value(rt_data) type tt_currencyclearing_key.
    methods
      set_currency_clearing_keys
        importing
          it_key type tt_currencyclearing_key.
    methods
      set_reverse_curr_clearing_keys
        importing
          it_key type tt_reversecurrencyclearing_key.
    methods
      set_reverse_xr_difference_keys
        importing
          it_key type tt_reversexrdifference_key.

  private section.
    class-data:
      mo_instance type ref to lcl_buffer.

    data:
      mt_xrdh_ins                    type tt_xrdh,
      mt_xrdi_ins                    type tt_xrdi,
      mt_xrdh_upd                    type tt_xrdh,
      mt_entity_c_xrdh               type tt_entity_c_xrdh,
      mt_entity_c_xrdi               type tt_entity_c_xrdi,
      mt_txpid                       type tt_txpid,
      mt_currencyclearing_key        type tt_currencyclearing_key,
      mt_reversecurrencyclearing_key type tt_reversecurrencyclearing_key,
      mt_reversexrdifference_key     type tt_reversexrdifference_key.
endclass.

class lcl_journalentry definition.
  public section.
    types:
      ts_post           type structure for action import i_journalentrytp~post,
      tt_glitem         type ts_post-%param-_glitems,
      ts_glitem         type line of tt_glitem,
      tt_currencyamount type ts_glitem-_currencyamount,
      ts_currencyamount type line of tt_currencyamount.

    types:
      tt_message type table of bapiret2.

    constants:
      co_ledger_0l  type fins_ledger value '0L',
      co_btt_rfbu   type glvor       value 'RFBU',
      co_curtp_00   type curtp       value '00',
      co_shkzg_h    type shkzg       value 'H',
      co_shkzg_s    type shkzg       value 'S',
      co_ktosl_mws  type ktosl       value 'MWS',
      co_kschl_mwas type kschl       value 'MWAS',
      co_stgrd_01   type stgrd       value '01'.

    class-methods
      add_message
        importing
          iv_msgid   type sy-msgid
          iv_msgno   type sy-msgno
          iv_msgty   type sy-msgty
          iv_msgv1   type sy-msgv1 optional
          iv_msgv2   type sy-msgv2 optional
          iv_msgv3   type sy-msgv3 optional
          iv_msgv4   type sy-msgv4 optional
        changing
          ct_message type tt_message.
    class-methods
      create_xr_diff_invoice
        importing
          is_xrdh    type lcl_buffer=>ts_xrdh
          it_xrdi    type lcl_buffer=>tt_xrdi
        exporting
          ev_pid     type abp_behv_pid
          et_message type tt_message.
    class-methods
      create_accdoc_number_by_pid
        importing
          iv_pid   type abp_behv_pid
        exporting
          ev_bukrs type bukrs
          ev_gjahr type gjahr
          ev_belnr type belnr_d.
    class-methods
      create_currency_clearing_doc
        importing
          iv_bukrs     type bukrs
          iv_gjahr     type gjahr
          iv_belnr     type belnr_d
          iv_kunnr     type kunnr
          iv_lifnr     type lifnr
          iv_belnr_ref type belnr_d optional
          iv_gjahr_ref type gjahr   optional
          iv_xblnr     type xblnr   optional
        exporting
          ev_pid       type abp_behv_pid
          et_message   type tt_message.
    class-methods
      create_reverse_document
        importing
          iv_bukrs   type bukrs
          iv_gjahr   type gjahr
          iv_belnr   type belnr_d
        exporting
          et_message type tt_message.
endclass.

class lcl_buffer implementation.
  method get_instance.
    if mo_instance is not bound.
      mo_instance = new #( ).
    endif.

    ro_instance = mo_instance.
  endmethod.

  method add_entity_xrdh.
    append is_entity to mt_entity_c_xrdh.
  endmethod.

  method add_entity_xrdi.
    append is_entity to mt_entity_c_xrdi.
  endmethod.

  method prepare_db_tables.
    loop at mt_entity_c_xrdh into data(ls_entity_c_xrdh).
      add_xrdh_by_txuuid( ls_entity_c_xrdh-transactionuuid ).
      add_xrdi_by_txuuid( ls_entity_c_xrdh-transactionuuid ).
    endloop.
  endmethod.

  method add_xrdh_by_txuuid.
    data ls_xrdh type zfi_t_xrdh.

    loop at mt_entity_c_xrdh into data(ls_entity_c_xrdh) using key entity where transactionuuid eq iv_txuuid.
      clear ls_xrdh.

      ls_xrdh = corresponding #( ls_entity_c_xrdh mapping from entity ).
      get time stamp field ls_xrdh-createdat.
      ls_xrdh-createdby = cl_abap_context_info=>get_user_technical_name( ).
      add_xrdh( ls_xrdh ).
    endloop.
  endmethod.

  method add_xrdi_by_txuuid.
    data ls_xrdi type zfi_t_xrdi.

    loop at mt_entity_c_xrdi into data(ls_entity_c_xrdi) using key entity where transactionuuid eq iv_txuuid.
      loop at ls_entity_c_xrdi-%target into data(ls_target).
        clear ls_xrdi.

        ls_xrdi = corresponding #( ls_target mapping from entity ).
        add_xrdi( ls_xrdi ).
      endloop.
    endloop.
  endmethod.

  method add_xrdh.
    append is_data to mt_xrdh_ins.
  endmethod.

  method add_xrdi.
    append is_data to mt_xrdi_ins.
  endmethod.

  method add_xrdh_upd.
    append is_data to mt_xrdh_upd.
  endmethod.

  method get_xrdh.
    rt_data = mt_xrdh_ins.
  endmethod.

  method get_xrdi.
    rt_data = mt_xrdi_ins.
  endmethod.

  method set_je_pid_by_txuuid.
    append initial line to mt_txpid reference into data(lo_txpid).
    lo_txpid->txuuid = iv_txuuid.
    lo_txpid->pid    = iv_pid.
  endmethod.

  method create_accdoc_numbers.
    data:
      lv_bukrs type bukrs,
      lv_gjahr type gjahr,
      lv_belnr type belnr_d.

    loop at mt_txpid into data(ls_txpid).
      clear: lv_bukrs, lv_gjahr, lv_belnr.

      lcl_journalentry=>create_accdoc_number_by_pid(
        exporting
          iv_pid   = ls_txpid-pid
        importing
          ev_bukrs = lv_bukrs
          ev_gjahr = lv_gjahr
          ev_belnr = lv_belnr
      ).

      if mt_xrdh_ins is not initial.
        set_xr_diff_invoice_by_txuuid(
          iv_txuuid = ls_txpid-txuuid
          iv_bukrs  = lv_bukrs
          iv_gjahr  = lv_gjahr
          iv_belnr  = lv_belnr
        ).
      elseif mt_xrdh_upd is not initial.
        set_curr_clearing_by_txuuid(
          iv_txuuid = ls_txpid-txuuid
          iv_bukrs  = lv_bukrs
          iv_gjahr  = lv_gjahr
          iv_belnr  = lv_belnr
        ).
      endif.
    endloop.
  endmethod.

  method set_xr_diff_invoice_by_txuuid.
    loop at mt_xrdh_ins reference into data(lo_xrdh) where txuuid eq iv_txuuid.
      lo_xrdh->txstat = co_txstat_a.
      lo_xrdh->gjahr  = iv_gjahr.
      lo_xrdh->belnr  = iv_belnr.
    endloop.
  endmethod.

  method set_clearing_doc_by_txuuid.
    loop at mt_xrdh_upd reference into data(lo_xrdh) where txuuid eq iv_txuuid.
      lo_xrdh->auggj = iv_auggj.
      lo_xrdh->augbl = iv_augbl.
    endloop.
  endmethod.

  method set_curr_clearing_by_txuuid.
    loop at mt_xrdh_upd reference into data(lo_xrdh) where txuuid eq iv_txuuid.
      lo_xrdh->txstat  = co_txstat_b.
      lo_xrdh->gjahr_c = iv_gjahr.
      lo_xrdh->belnr_c = iv_belnr.
    endloop.
  endmethod.

  method set_transaction_stat_by_txuuid.
    loop at mt_xrdh_upd reference into data(lo_xrdh) where txuuid eq iv_txuuid.
      lo_xrdh->txstat = iv_txstat.

      if iv_txstat eq co_txstat_a.
        clear:
          lo_xrdh->gjahr_c,
          lo_xrdh->belnr_c,
          lo_xrdh->augbl,
          lo_xrdh->auggj.
      elseif iv_txstat eq co_txstat_c.
        lo_xrdh->disabled = abap_true.
      endif.
    endloop.
  endmethod.

  method create_xr_diff_invoices.
    data:
      lt_message type lcl_journalentry=>tt_message,
      lt_xrdi_je type lcl_buffer=>tt_xrdi,
      lv_pid_je  type abp_behv_pid.

    loop at mt_xrdh_ins into data(ls_xrdh).
      clear: lt_xrdi_je, lt_message, lv_pid_je.

      loop at mt_xrdi_ins into data(ls_xrdi) where txuuid eq ls_xrdh-txuuid.
        append ls_xrdi to lt_xrdi_je.
      endloop.

      lcl_journalentry=>create_xr_diff_invoice(
        exporting
          is_xrdh    = ls_xrdh
          it_xrdi    = lt_xrdi_je
        importing
          ev_pid     = lv_pid_je
          et_message = lt_message
      ).

      if lv_pid_je is initial.
        loop at lt_message into data(ls_message).
          append initial line to reported-zfi_i_xrdh reference into data(lo_reported_xrdh).
          lo_reported_xrdh->%key-transactionuuid = ls_xrdh-txuuid.
          lo_reported_xrdh->%msg = new_message(
            id       = ls_message-id
            number   = ls_message-number
            severity = conv #( ls_message-type )
            v1       = ls_message-message_v1
            v2       = ls_message-message_v2
            v3       = ls_message-message_v3
            v4       = ls_message-message_v4
          ).
        endloop.

        append initial line to failed-zfi_i_xrdh reference into data(lo_failed_xrdh).
        lo_failed_xrdh->%key-transactionuuid = ls_xrdh-txuuid.
        lo_failed_xrdh->%fail-cause = if_abap_behv=>cause-unspecific.
      else.
        set_je_pid_by_txuuid(
          iv_txuuid = ls_xrdh-txuuid
          iv_pid    = lv_pid_je
        ).
      endif.
    endloop.
  endmethod.

  method create_currency_clearing_docs.
    data:
      lt_message type lcl_journalentry=>tt_message,
      lv_pid_je  type abp_behv_pid.

    loop at mt_currencyclearing_key into data(ls_currencyclearing_key).
      clear: lt_message, lv_pid_je.

      select single * from zfi_t_xrdh
        where txuuid eq @ls_currencyclearing_key-transactionuuid
        into @data(ls_xrdh).
      check sy-subrc eq 0.

      add_xrdh_upd( ls_xrdh ).

      lcl_journalentry=>create_currency_clearing_doc(
        exporting
          iv_bukrs     = ls_currencyclearing_key-%param-companycode
          iv_gjahr     = ls_currencyclearing_key-%param-fiscalyear
          iv_belnr     = ls_currencyclearing_key-%param-accountingdocument
          iv_kunnr     = ls_currencyclearing_key-%param-customer
          iv_lifnr     = ls_currencyclearing_key-%param-supplier
          iv_belnr_ref = ls_xrdh-belnr
          iv_gjahr_ref = ls_xrdh-gjahr
          iv_xblnr     = ls_xrdh-xblnr
        importing
          ev_pid       = lv_pid_je
          et_message   = lt_message
      ).

      if lv_pid_je is initial.
        loop at lt_message into data(ls_message).
          append initial line to reported-zfi_i_xrdh reference into data(lo_reported_xrdh).
          lo_reported_xrdh->%key = ls_currencyclearing_key-%key.
          lo_reported_xrdh->%msg = new_message(
            id       = ls_message-id
            number   = ls_message-number
            severity = conv #( ls_message-type )
            v1       = ls_message-message_v1
            v2       = ls_message-message_v2
            v3       = ls_message-message_v3
            v4       = ls_message-message_v4
          ).
        endloop.

        append initial line to failed-zfi_i_xrdh reference into data(lo_failed_xrdh).
        lo_failed_xrdh->%key = ls_currencyclearing_key-%key.
        lo_failed_xrdh->%fail-cause = if_abap_behv=>cause-unspecific.
      else.
        set_je_pid_by_txuuid(
          iv_txuuid = ls_currencyclearing_key-transactionuuid
          iv_pid    = lv_pid_je
        ).

        set_clearing_doc_by_txuuid(
          iv_txuuid = ls_currencyclearing_key-transactionuuid
          iv_auggj  = ls_currencyclearing_key-%param-fiscalyear
          iv_augbl  = ls_currencyclearing_key-%param-accountingdocument
        ).
      endif.
    endloop.
  endmethod.

  method reverse_currency_clearing_docs.
    data:
      lt_message type lcl_journalentry=>tt_message,
      lv_pid_je  type abp_behv_pid.

    loop at mt_reversecurrencyclearing_key into data(ls_reversecurrencyclearing_key).
      clear: lt_message.

      select single * from zfi_t_xrdh
        where txuuid eq @ls_reversecurrencyclearing_key-transactionuuid
        into @data(ls_xrdh).
      check sy-subrc eq 0.

      add_xrdh_upd( ls_xrdh ).

      lcl_journalentry=>create_reverse_document(
        exporting
          iv_bukrs   = ls_xrdh-bukrs
          iv_gjahr   = ls_xrdh-gjahr_c
          iv_belnr   = ls_xrdh-belnr_c
        importing
          et_message = lt_message
      ).

      if lt_message is not initial.
        loop at lt_message into data(ls_message).
          append initial line to reported-zfi_i_xrdh reference into data(lo_reported_xrdh).
          lo_reported_xrdh->%key = ls_reversecurrencyclearing_key-%key.
          lo_reported_xrdh->%msg = new_message(
            id       = ls_message-id
            number   = ls_message-number
            severity = conv #( ls_message-type )
            v1       = ls_message-message_v1
            v2       = ls_message-message_v2
            v3       = ls_message-message_v3
            v4       = ls_message-message_v4
          ).
        endloop.

        append initial line to failed-zfi_i_xrdh reference into data(lo_failed_xrdh).
        lo_failed_xrdh->%key = ls_reversecurrencyclearing_key-%key.
        lo_failed_xrdh->%fail-cause = if_abap_behv=>cause-unspecific.
      else.
        set_transaction_stat_by_txuuid(
          iv_txuuid = ls_xrdh-txuuid
          iv_txstat = co_txstat_a
        ).
      endif.
    endloop.
  endmethod.

  method reverse_xr_difference_docs.
    data lt_message type lcl_journalentry=>tt_message.

    loop at mt_reversexrdifference_key into data(ls_reversexrdifference_key).
      clear: lt_message.

      select single * from zfi_t_xrdh
        where txuuid eq @ls_reversexrdifference_key-transactionuuid
        into @data(ls_xrdh).
      check sy-subrc eq 0.

      add_xrdh_upd( ls_xrdh ).

      if ls_xrdh-belnr_c is not initial.
        lcl_journalentry=>create_reverse_document(
          exporting
            iv_bukrs   = ls_xrdh-bukrs
            iv_gjahr   = ls_xrdh-gjahr_c
            iv_belnr   = ls_xrdh-belnr_c
          importing
            et_message = lt_message
        ).
      endif.

      if lt_message is initial.
        lcl_journalentry=>create_reverse_document(
          exporting
            iv_bukrs   = ls_xrdh-bukrs
            iv_gjahr   = ls_xrdh-gjahr
            iv_belnr   = ls_xrdh-belnr
          importing
            et_message = lt_message
        ).
      endif.

      if lt_message is not initial.
        loop at lt_message into data(ls_message).
          append initial line to reported-zfi_i_xrdh reference into data(lo_reported_xrdh).
          lo_reported_xrdh->%key = ls_reversexrdifference_key-%key.
          lo_reported_xrdh->%msg = new_message(
            id       = ls_message-id
            number   = ls_message-number
            severity = conv #( ls_message-type )
            v1       = ls_message-message_v1
            v2       = ls_message-message_v2
            v3       = ls_message-message_v3
            v4       = ls_message-message_v4
          ).
        endloop.

        append initial line to failed-zfi_i_xrdh reference into data(lo_failed_xrdh).
        lo_failed_xrdh->%key = ls_reversexrdifference_key-%key.
        lo_failed_xrdh->%fail-cause = if_abap_behv=>cause-unspecific.
      else.
        set_transaction_stat_by_txuuid(
          iv_txuuid = ls_xrdh-txuuid
          iv_txstat = co_txstat_c
        ).
      endif.
    endloop.
  endmethod.

  method save_db.
    if mt_xrdh_ins is not initial.
      insert zfi_t_xrdh from table @mt_xrdh_ins.
    endif.

    if mt_xrdi_ins is not initial.
      insert zfi_t_xrdi from table @mt_xrdi_ins.
    endif.

    if mt_xrdh_upd is not initial.
      update zfi_t_xrdh from table @mt_xrdh_upd.
    endif.
  endmethod.

  method get_currency_clearing_keys.
    rt_data = mt_currencyclearing_key.
  endmethod.

  method set_currency_clearing_keys.
    mt_currencyclearing_key = it_key.
  endmethod.

  method set_reverse_curr_clearing_keys.
    mt_reversecurrencyclearing_key = it_key.
  endmethod.

  method set_reverse_xr_difference_keys.
    mt_reversexrdifference_key = it_key.
  endmethod.
endclass.

class lcl_journalentry implementation.
  method add_message.
    append value #(
      id         = iv_msgid
      number     = iv_msgno
      type       = iv_msgty
      message_v1 = iv_msgv1
      message_v2 = iv_msgv2
      message_v3 = iv_msgv3
      message_v4 = iv_msgv4
    ) to ct_message.
  endmethod.

  method create_xr_diff_invoice.
    data:
      lo_currencyamount    type ref to ts_currencyamount,
      lo_currencyamount_00 type ref to ts_currencyamount,
      lt_post              type table for action import i_journalentrytp~post,
      lt_currencyrole      type table of i_companycodecurrencyrole,
      ls_currencyrole      type i_companycodecurrencyrole,
      lv_lineitem(6)       type n,
      lv_index             type i,
      lv_wrbtr             type wrbtr,
      lv_taxrate           type zfi_e_taxrate,
      lv_base_amount       type wrbtr,
      lv_mwskz             type mwskz.

    define get_currency_amount.
      clear &3.

      case &1.
        when 1.
          &3 = cond #( when &2-debia is not initial then &2-debia
                       else &2-creda ).
        when 2.
          &3 = &2-coma1.
        when 3.
          &3 = &2-loca1.
        when 4.
          &3 = &2-loca2.
      endcase.
    end-of-definition.

    define add_currency_cus_ven.
      loop at lt_currencyrole into ls_currencyrole.
        lv_index = sy-tabix.
        get_currency_amount lv_index &2 lv_wrbtr.

        append initial line to &1 reference into lo_currencyamount.
        lo_currencyamount->currencyrole           = ls_currencyrole-currencyrole.
        lo_currencyamount->currency               = ls_currencyrole-currency.
        lo_currencyamount->journalentryitemamount = lv_wrbtr.

        if ls_xrdi-shkzg eq co_shkzg_h.
          lo_currencyamount->journalentryitemamount *= -1.
        endif.
      endloop.
    end-of-definition.

    select single * from i_companycode
      where companycode eq @is_xrdh-bukrs
      into @data(ls_companycode).

    select * from i_companycodecurrencyrole
      where companycode eq @is_xrdh-bukrs
      order by currencyrole
      into table @lt_currencyrole.

    loop at it_xrdi into data(ls_xrdi_glacc)
      where hkont ne space.
      exit.
    endloop.

    loop at it_xrdi into data(ls_xrdi_taxcode)
      where mwskz ne space.
      lv_mwskz = ls_xrdi_taxcode-mwskz.
      exit.
    endloop.

    if lv_mwskz is not initial.
      select * from zfi_t_taxcode
        where mwskz eq @lv_mwskz
        into table @data(lt_taxcode).
    endif.

    loop at it_xrdi into data(ls_xrdi_cusven)
      where ( kunnr ne space or
              lifnr ne space ).
      exit.
    endloop.

    if not line_exists( lt_currencyrole[ currencyrole = co_curtp_00 ] ).
      append initial line to lt_currencyrole reference into data(lo_currencyrole).
      lo_currencyrole->companycode  = is_xrdh-bukrs.
      lo_currencyrole->currencyrole = co_curtp_00.
      lo_currencyrole->currency     = is_xrdh-waers.

      sort lt_currencyrole by currencyrole.
    endif.

    lv_taxrate = reduce #(
      init x = 0
      for taxcode in lt_taxcode
      next x = x + taxcode-taxrate
    ).

    loop at lt_currencyrole into ls_currencyrole.
      get_currency_amount sy-tabix ls_xrdi_cusven lv_wrbtr.

      if lv_wrbtr is not initial.
        exit.
      endif.
    endloop.
    if lv_wrbtr is not initial.
      lv_base_amount = lv_wrbtr * 100 / ( 100 + lv_taxrate ).
    endif.

    append initial line to lt_post reference into data(lo_post).
    lo_post->%cid = 1.
    lo_post->%param-companycode                  = is_xrdh-bukrs.
    lo_post->%param-businesstransactiontype      = co_btt_rfbu.
    lo_post->%param-accountingdocumenttype       = is_xrdh-blart.
    lo_post->%param-accountingdocumentheadertext = is_xrdh-bktxt.
    lo_post->%param-createdbyuser                = cl_abap_context_info=>get_user_technical_name( ).
    lo_post->%param-documentdate                 = is_xrdh-bldat.
    lo_post->%param-postingdate                  = is_xrdh-budat.
    lo_post->%param-postingfiscalperiod          = is_xrdh-monat.
    lo_post->%param-documentreferenceid          = is_xrdh-xblnr.
    lo_post->%param-taxdeterminationdate         = is_xrdh-budat.
    lo_post->%param-taxreportingdate             = is_xrdh-budat.

    loop at it_xrdi into data(ls_xrdi).
      lv_lineitem += 1.

      if ls_xrdi-hkont is not initial.
        append initial line to lo_post->%param-_glitems reference into data(lo_glitem).
        lo_glitem->glaccountlineitem   = lv_lineitem.
        lo_glitem->glaccount           = ls_xrdi-hkont.
        lo_glitem->documentitemtext    = ls_xrdi-sgtxt.
        lo_glitem->assignmentreference = ls_xrdi-zuonr.
        lo_glitem->taxcode             = lv_mwskz.
        lo_glitem->taxcountry          = ls_companycode-country.
        lo_glitem->valuedate           = is_xrdh-budat.
        lo_glitem->costcenter          = ls_xrdi-kostl.
        lo_glitem->profitcenter        = ls_xrdi-prctr.
        lo_glitem->segment             = ls_xrdi-fb_segment.
        lo_glitem->wbselement          = ls_xrdi-ps_posid.

        lo_glitem->_profitabilitysupplement-costcenter     = lo_glitem->costcenter.
        lo_glitem->_profitabilitysupplement-profitcenter   = lo_glitem->profitcenter.
        lo_glitem->_profitabilitysupplement-wbselement     = lo_glitem->wbselement.
      elseif ls_xrdi-kunnr is not initial.
        append initial line to lo_post->%param-_aritems reference into data(lo_aritem).
        lo_aritem->glaccountlineitem      = lv_lineitem.
        lo_aritem->customer               = ls_xrdi-kunnr.
        lo_aritem->documentitemtext       = ls_xrdi-sgtxt.
        lo_aritem->assignmentreference    = ls_xrdi-zuonr.
        lo_aritem->taxcode                = lv_mwskz.
        lo_aritem->taxcountry             = ls_companycode-country.
        lo_aritem->duecalculationbasedate = is_xrdh-budat.

        add_currency_cus_ven lo_aritem->_currencyamount ls_xrdi.
      elseif ls_xrdi-lifnr is not initial.
        append initial line to lo_post->%param-_apitems reference into data(lo_apitem).
        lo_apitem->glaccountlineitem      = lv_lineitem.
        lo_apitem->supplier               = ls_xrdi-lifnr.
        lo_apitem->documentitemtext       = ls_xrdi-sgtxt.
        lo_apitem->assignmentreference    = ls_xrdi-zuonr.
        lo_apitem->taxcode                = lv_mwskz.
        lo_apitem->taxcountry             = ls_companycode-country.
        lo_apitem->duecalculationbasedate = is_xrdh-budat.

        add_currency_cus_ven lo_apitem->_currencyamount ls_xrdi.
      endif.
    endloop.

    loop at lt_taxcode into data(ls_taxcode).
      clear lo_currencyamount_00.
      lv_lineitem += 1.

      append initial line to lo_post->%param-_taxitems reference into data(lo_taxitem).
      lo_taxitem->glaccountlineitem     = lv_lineitem.
      lo_taxitem->taxcode               = ls_taxcode-mwskz.
      lo_taxitem->taxcountry            = ls_companycode-country.
      lo_taxitem->taxitemclassification = ls_taxcode-ktosl.
      lo_taxitem->conditiontype         = ls_taxcode-kschl.
      lo_taxitem->taxrate               = ls_taxcode-taxrate.

      loop at lt_currencyrole into ls_currencyrole.
        lv_index = sy-tabix.
        get_currency_amount lv_index ls_xrdi_cusven lv_wrbtr.

        append initial line to lo_taxitem->_currencyamount reference into lo_currencyamount.
        lo_currencyamount->currencyrole = ls_currencyrole-currencyrole.
        lo_currencyamount->currency     = ls_currencyrole-currency.

        if lv_wrbtr is not initial.
          lo_currencyamount->journalentryitemamount = lv_base_amount * abs( ls_taxcode-taxrate ) / 100.
          lo_currencyamount->taxbaseamount          = lv_base_amount.
        endif.

        if ls_taxcode-taxrate lt 0.
          lo_currencyamount->journalentryitemamount *= -1.
          lo_currencyamount->taxbaseamount          *= -1.
        endif.

        if lv_index eq 1.
          lo_currencyamount_00 = lo_currencyamount.
        endif.

        if ls_xrdi_cusven-shkzg ne co_shkzg_h.
          lo_currencyamount->journalentryitemamount *= -1.
        endif.

        if ls_xrdi_cusven-shkzg eq co_shkzg_h.
          lo_currencyamount->taxbaseamount *= -1.
        endif.

        if lv_index ne 1 and
           lo_currencyamount_00 is bound.
          if lo_currencyamount_00->journalentryitemamount is initial and
             lo_currencyamount->journalentryitemamount is not initial.
            lo_currencyamount_00->taxbaseamount = lo_currencyamount->taxbaseamount * -1.
          endif.
        endif.
      endloop.
    endloop.

    if lo_glitem is bound.
      loop at lt_currencyrole into ls_currencyrole.
        lv_index = sy-tabix.
        get_currency_amount lv_index ls_xrdi_glacc lv_wrbtr.

        append initial line to lo_glitem->_currencyamount reference into lo_currencyamount.
        lo_currencyamount->currencyrole = ls_currencyrole-currencyrole.
        lo_currencyamount->currency     = ls_currencyrole-currency.

        if lv_wrbtr is not initial.
          lo_currencyamount->journalentryitemamount = lv_base_amount.
        endif.

        if ls_xrdi_glacc-shkzg eq co_shkzg_h.
          lo_currencyamount->journalentryitemamount *= -1.
        endif.
      endloop.
    endif.

    modify entities of i_journalentrytp privileged
      entity journalentry
        execute post
        from lt_post
      mapped data(ls_mapped)
      failed data(ls_failed)
      reported data(ls_reported).

    if ls_failed-journalentry is not initial.
      loop at ls_reported-journalentry into data(ls_message).
        append initial line to et_message reference into data(lo_message).
        lo_message->type       = ls_message-%msg->if_t100_dyn_msg~msgty.
        lo_message->id         = ls_message-%msg->if_t100_message~t100key-msgid.
        lo_message->number     = ls_message-%msg->if_t100_message~t100key-msgno.
        lo_message->message_v1 = ls_message-%msg->if_t100_dyn_msg~msgv1.
        lo_message->message_v2 = ls_message-%msg->if_t100_dyn_msg~msgv2.
        lo_message->message_v3 = ls_message-%msg->if_t100_dyn_msg~msgv3.
        lo_message->message_v4 = ls_message-%msg->if_t100_dyn_msg~msgv4.
        lo_message->message    = ls_message-%msg->if_message~get_text(  ).
      endloop.
    else.
      loop at ls_mapped-journalentry into data(ls_mapped_journalentry).
        ev_pid = ls_mapped_journalentry-%pid.
        exit.
      endloop.
    endif.
  endmethod.

  method create_accdoc_number_by_pid.
    convert key of i_journalentrytp from iv_pid to data(ls_key).
    ev_bukrs = ls_key-companycode.
    ev_gjahr = ls_key-fiscalyear.
    ev_belnr = ls_key-accountingdocument.
  endmethod.

  method create_currency_clearing_doc.
    data:
      lo_currencyamount      type ref to ts_currencyamount,
      lt_post                type table for action import i_journalentrytp~post,
      lt_currencyrole        type table of i_companycodecurrencyrole,
      ls_currencyrole        type i_companycodecurrencyrole,
      ls_journalentryitem_gl type i_journalentryitem,
      lv_lineitem(6)         type n.

    define add_currencyamounts.
      loop at lt_currencyrole into ls_currencyrole.
        append initial line to &1 reference into lo_currencyamount.
        lo_currencyamount->currencyrole           = ls_currencyrole-currencyrole.
        lo_currencyamount->currency               = ls_currencyrole-currency.

        if lo_currencyamount->currency eq ls_journalentryitem_gl-companycodecurrency.
          lo_currencyamount->journalentryitemamount = ls_journalentryitem_gl-amountincompanycodecurrency.
        endif.

        if &2 is not initial.
          lo_currencyamount->journalentryitemamount *= -1.
        endif.
      endloop.
    end-of-definition.

    select single * from i_journalentry
      where companycode        eq @iv_bukrs
        and fiscalyear         eq @iv_gjahr
        and accountingdocument eq @iv_belnr
      into @data(ls_journalentry)
      options privileged access.
    if sy-subrc ne 0.
      add_message(
        exporting
          iv_msgid   = zcl_fi_xr_diff=>co_msgcl
          iv_msgno   = '003'
          iv_msgty   = conv #( if_abap_behv_message=>severity-error )
        changing
          ct_message = et_message
      ).
      return.
    endif.

    if ls_journalentry-reversedocument is not initial.
      add_message(
        exporting
          iv_msgid   = zcl_fi_xr_diff=>co_msgcl
          iv_msgno   = '004'
          iv_msgty   = conv #( if_abap_behv_message=>severity-error )
        changing
          ct_message = et_message
      ).
      return.
    endif.

    select * from i_journalentryitem
      where sourceledger       eq @co_ledger_0l
        and ledger             eq @co_ledger_0l
        and companycode        eq @iv_bukrs
        and fiscalyear         eq @iv_gjahr
        and accountingdocument eq @iv_belnr
      into table @data(lt_journalentryitem)
      options privileged access.

    sort lt_journalentryitem by glaccount supplier customer.
    delete adjacent duplicates from lt_journalentryitem comparing glaccount supplier customer.

    loop at lt_journalentryitem into ls_journalentryitem_gl
      where glaccount is not initial
        and customer is initial
        and supplier is initial
        and amountincompanycodecurrency is not initial
        and transactiontypedetermination eq 'KDF'.
      exit.
    endloop.

    select * from i_companycodecurrencyrole
      where companycode eq @ls_journalentry-companycode
      order by currencyrole
      into table @lt_currencyrole.

    if not line_exists( lt_currencyrole[ currencyrole = co_curtp_00 ] ).
      append initial line to lt_currencyrole reference into data(lo_currencyrole).
      lo_currencyrole->companycode  = ls_journalentry-companycode.
      lo_currencyrole->currencyrole = co_curtp_00.
      lo_currencyrole->currency     = ls_journalentryitem_gl-transactioncurrency.

      sort lt_currencyrole by currencyrole.
    endif.

    append initial line to lt_post reference into data(lo_post).
    lo_post->%cid = 1.
    lo_post->%param-companycode                  = ls_journalentry-companycode.
    lo_post->%param-businesstransactiontype      = co_btt_rfbu.
    lo_post->%param-accountingdocumenttype       = ls_journalentry-accountingdocumenttype.
    lo_post->%param-accountingdocumentheadertext = |{ iv_belnr_ref }{ iv_gjahr_ref }|.
    lo_post->%param-createdbyuser                = cl_abap_context_info=>get_user_technical_name( ).
    lo_post->%param-documentdate                 = ls_journalentry-documentdate.
    lo_post->%param-postingdate                  = ls_journalentry-postingdate.
    lo_post->%param-postingfiscalperiod          = ls_journalentry-fiscalperiod.
    lo_post->%param-documentreferenceid          = iv_xblnr.
    lo_post->%param-taxdeterminationdate         = ls_journalentry-postingdate.
    lo_post->%param-taxreportingdate             = ls_journalentry-postingdate.

    loop at lt_journalentryitem into data(ls_journalentryitem).
      if ls_journalentryitem-glaccount is not initial and
         ls_journalentryitem-customer is initial and
         ls_journalentryitem-supplier is initial and
         ls_journalentryitem-amountincompanycodecurrency is not initial and
         ls_journalentryitem-transactiontypedetermination eq 'KDF'.
        lv_lineitem += 1.

        append initial line to lo_post->%param-_glitems reference into data(lo_glitem).
        lo_glitem->glaccountlineitem   = lv_lineitem.
        lo_glitem->glaccount           = ls_journalentryitem-glaccount.
        lo_glitem->documentitemtext    = ls_journalentryitem-documentitemtext.
        lo_glitem->assignmentreference = ls_journalentryitem-assignmentreference.
        lo_glitem->valuedate           = ls_journalentry-postingdate.
        lo_glitem->costcenter          = ls_journalentryitem-costcenter.
        lo_glitem->profitcenter        = ls_journalentryitem-profitcenter.
        lo_glitem->segment             = ls_journalentryitem-segment.
        lo_glitem->functionalarea      = ls_journalentryitem-functionalarea.

        if ls_journalentryitem-wbselementinternalid ne '00000000'.
          lo_glitem->wbselement        = ls_journalentryitem-wbselementinternalid.
        endif.

        lo_glitem->_profitabilitysupplement-costcenter     = lo_glitem->costcenter.
        lo_glitem->_profitabilitysupplement-profitcenter   = lo_glitem->profitcenter.
        lo_glitem->_profitabilitysupplement-wbselement     = lo_glitem->wbselement.
        lo_glitem->_profitabilitysupplement-functionalarea = lo_glitem->functionalarea.

        add_currencyamounts lo_glitem->_currencyamount abap_true.
      elseif ls_journalentryitem-customer is not initial.
        lv_lineitem += 1.

        append initial line to lo_post->%param-_aritems reference into data(lo_aritem).
        lo_aritem->glaccountlineitem      = lv_lineitem.
        lo_aritem->customer               = ls_journalentryitem-customer.
        lo_aritem->documentitemtext       = |{ ls_journalentry-accountingdocument } { ls_journalentry-fiscalyear }|.
        lo_aritem->assignmentreference    = ls_journalentryitem-assignmentreference.
        lo_aritem->duecalculationbasedate = ls_journalentry-postingdate.

        add_currencyamounts lo_aritem->_currencyamount abap_false.
      elseif ls_journalentryitem-supplier is not initial.
        lv_lineitem += 1.

        append initial line to lo_post->%param-_apitems reference into data(lo_apitem).
        lo_apitem->glaccountlineitem      = lv_lineitem.
        lo_apitem->supplier               = ls_journalentryitem-supplier.
        lo_apitem->documentitemtext       = |{ ls_journalentry-accountingdocument } { ls_journalentry-fiscalyear }|.
        lo_apitem->assignmentreference    = ls_journalentryitem-assignmentreference.
        lo_apitem->duecalculationbasedate = ls_journalentry-postingdate.

        add_currencyamounts lo_apitem->_currencyamount abap_false.
      endif.
    endloop.

    modify entities of i_journalentrytp privileged
      entity journalentry
        execute post
        from lt_post
      mapped data(ls_mapped)
      failed data(ls_failed)
      reported data(ls_reported).

    if ls_failed-journalentry is not initial.
      loop at ls_reported-journalentry into data(ls_message).
        append initial line to et_message reference into data(lo_message).
        lo_message->type       = ls_message-%msg->if_t100_dyn_msg~msgty.
        lo_message->id         = ls_message-%msg->if_t100_message~t100key-msgid.
        lo_message->number     = ls_message-%msg->if_t100_message~t100key-msgno.
        lo_message->message_v1 = ls_message-%msg->if_t100_dyn_msg~msgv1.
        lo_message->message_v2 = ls_message-%msg->if_t100_dyn_msg~msgv2.
        lo_message->message_v3 = ls_message-%msg->if_t100_dyn_msg~msgv3.
        lo_message->message_v4 = ls_message-%msg->if_t100_dyn_msg~msgv4.
        lo_message->message    = ls_message-%msg->if_message~get_text(  ).
      endloop.
    else.
      loop at ls_mapped-journalentry into data(ls_mapped_journalentry).
        ev_pid = ls_mapped_journalentry-%pid.
        exit.
      endloop.
    endif.
  endmethod.

  method create_reverse_document.
    data lt_reverse type table for action import i_journalentrytp~reverse.

    select single * from i_journalentry
      where companycode        eq @iv_bukrs
        and fiscalyear         eq @iv_gjahr
        and accountingdocument eq @iv_belnr
      into @data(ls_journalentry)
      options privileged access.

    append initial line to lt_reverse reference into data(lo_reverse).
*    lo_reverse->%cid_ref = 1.
    lo_reverse->companycode        = iv_bukrs.
    lo_reverse->fiscalyear         = iv_gjahr.
    lo_reverse->accountingdocument = iv_belnr.

    lo_reverse->%param-postingdate    = ls_journalentry-postingdate.
    lo_reverse->%param-reversalreason = co_stgrd_01.
    lo_reverse->%param-createdbyuser  = cl_abap_context_info=>get_user_technical_name( ).

    modify entities of i_journalentrytp privileged
      entity journalentry
        execute reverse
        from lt_reverse
      mapped data(ls_mapped)
      failed data(ls_failed)
      reported data(ls_reported).

    if ls_failed-journalentry is not initial.
      loop at ls_reported-journalentry into data(ls_message).
        append initial line to et_message reference into data(lo_message).
        lo_message->type       = ls_message-%msg->if_t100_dyn_msg~msgty.
        lo_message->id         = ls_message-%msg->if_t100_message~t100key-msgid.
        lo_message->number     = ls_message-%msg->if_t100_message~t100key-msgno.
        lo_message->message_v1 = ls_message-%msg->if_t100_dyn_msg~msgv1.
        lo_message->message_v2 = ls_message-%msg->if_t100_dyn_msg~msgv2.
        lo_message->message_v3 = ls_message-%msg->if_t100_dyn_msg~msgv3.
        lo_message->message_v4 = ls_message-%msg->if_t100_dyn_msg~msgv4.
        lo_message->message    = ls_message-%msg->if_message~get_text(  ).
      endloop.
    endif.
  endmethod.
endclass.

class lhc_zfi_i_xrdh definition inheriting from cl_abap_behavior_handler.
  private section.
    methods get_global_authorizations for global authorization
      importing request requested_authorizations for zfi_i_xrdh result result.
    methods get_instance_features for instance features
      importing keys request requested_features for zfi_i_xrdh result result.
    methods get_global_features for global features
      importing request requested_features for zfi_i_xrdh result result.
    methods create for modify
      importing entities for create zfi_i_xrdh.
    methods update for modify
      importing entities for update zfi_i_xrdh.
    methods delete for modify
      importing keys for delete zfi_i_xrdh.
    methods read for read
      importing keys for read zfi_i_xrdh result result.
    methods lock for lock
      importing keys for lock zfi_i_xrdh.
    methods rba_item for read
      importing keys_rba for read zfi_i_xrdh\_item full result_requested result result link association_links.
    methods cba_item for modify
      importing entities_cba for create zfi_i_xrdh\_item.
    methods getdefaultsforcreate for read
      importing keys for function zfi_i_xrdh~getdefaultsforcreate result result.
    methods getdefaultsforitemcreate for read
      importing keys for function zfi_i_xrdh~getdefaultsforitemcreate result result.
    methods checkfieldsmandatoryonsave for validate on save
      importing keys for zfi_i_xrdh~checkfieldsmandatoryonsave.
    methods currencyclearing for modify
      importing keys for action zfi_i_xrdh~currencyclearing result result.
    methods getdefaultsforcurrencyclearing for read
      importing keys for function zfi_i_xrdh~getdefaultsforcurrencyclearing result result.
    methods reversexrdifference for modify
      importing keys for action zfi_i_xrdh~reversexrdifference result result.
    methods reversecurrencyclearing for modify
      importing keys for action zfi_i_xrdh~reversecurrencyclearing result result.
endclass.

class lhc_zfi_i_xrdh implementation.
  method get_global_authorizations.
  endmethod.

  method get_instance_features.
    read entities of zfi_i_xrdh in local mode
      entity zfi_i_xrdh
        all fields with corresponding #( keys )
        result data(lt_xrdh)
      failed data(ls_failed)
      reported data(ls_reported).

    loop at keys into data(ls_key).
      append initial line to result reference into data(lo_result).
      lo_result->%tky = ls_key-%tky.
      lo_result->%action-edit = if_abap_behv=>fc-o-disabled.
      lo_result->%action-currencyclearing = if_abap_behv=>fc-o-disabled.
      lo_result->%action-reversexrdifference = if_abap_behv=>fc-o-disabled.
      lo_result->%action-reversecurrencyclearing = if_abap_behv=>fc-o-disabled.

      check ls_key-%tky-%is_draft eq if_abap_behv=>mk-off.

      read table lt_xrdh from corresponding #( ls_key )
        using key entity into data(ls_xrdh).
      if sy-subrc eq 0.
        if ls_xrdh-disabled eq abap_false.
          lo_result->%action-reversexrdifference = if_abap_behv=>fc-o-enabled.

          if ls_xrdh-transactionstatus eq lcl_buffer=>co_txstat_a.
            lo_result->%action-currencyclearing = if_abap_behv=>fc-o-enabled.
          endif.

          if ls_xrdh-transactionstatus eq lcl_buffer=>co_txstat_b.
            lo_result->%action-reversecurrencyclearing = if_abap_behv=>fc-o-enabled.
          endif.
        endif.
      endif.
    endloop.
  endmethod.

  method get_global_features.
    result-%delete = if_abap_behv=>fc-o-disabled.
  endmethod.

  method create.
    data(lo_buffer) = lcl_buffer=>get_instance(  ).

    loop at entities into data(ls_entity).
      lo_buffer->add_entity_xrdh( ls_entity ).

      append initial line to mapped-zfi_i_xrdh reference into data(lo_mapped_xrdh).
      lo_mapped_xrdh->* = corresponding #( ls_entity ).
    endloop.
  endmethod.

  method update.
  endmethod.

  method delete.
  endmethod.

  method read.
    loop at keys into data(ls_key).
      select single * from zfi_i_xrdh
        where transactionuuid eq @ls_key-transactionuuid
        into @data(ls_xrdh).
      if sy-subrc eq 0.
        append corresponding #( ls_xrdh ) to result.
      else.
        append initial line to failed-zfi_i_xrdh reference into data(lo_failed_xrdh).
        lo_failed_xrdh->%key        = ls_key-%key.
        lo_failed_xrdh->%fail-cause = if_abap_behv=>cause-not_found.

        append initial line to reported-zfi_i_xrdh reference into data(lo_reported_xrdh).
        lo_reported_xrdh->%key = ls_key-%key.
        lo_reported_xrdh->%msg = new_message(
          id       = zcl_fi_xr_diff=>co_msgcl
          number   = '002'
          severity = if_abap_behv_message=>severity-error
        ).
      endif.
    endloop.
  endmethod.

  method lock.
  endmethod.

  method rba_item.
    loop at keys_rba into data(ls_key).
      select * from zfi_i_xrdi
        where transactionuuid eq @ls_key-transactionuuid
        into table @data(lt_xrdi).
      if sy-subrc eq 0.
        loop at lt_xrdi into data(ls_xrdi).
          append corresponding #( ls_xrdi ) to result.
        endloop.
      endif.
    endloop.
  endmethod.

  method cba_item.
    data(lo_buffer) = lcl_buffer=>get_instance(  ).

    loop at entities_cba into data(ls_entity).
      lo_buffer->add_entity_xrdi( ls_entity ).

      loop at ls_entity-%target into data(ls_target).
        append initial line to mapped-zfi_i_xrdi reference into data(lo_mapped_xrdi).
        lo_mapped_xrdi->* = corresponding #( ls_target ).
      endloop.

      append initial line to mapped-zfi_i_xrdh reference into data(lo_mapped_xrdh).
      lo_mapped_xrdh->* = corresponding #( ls_entity ).
      lo_mapped_xrdh->%cid = ls_entity-%cid_ref.
    endloop.
  endmethod.

  method getdefaultsforcreate.
    loop at keys into data(ls_key).
      append initial line to result reference into data(lo_result).
      lo_result->%cid = ls_key-%cid.
      lo_result->%param-noaccountingdocument = abap_true.
      lo_result->%param-nocurrencyclearingdocument = abap_true.
    endloop.
  endmethod.

  method getdefaultsforitemcreate.
    read entities of zfi_i_xrdh in local mode
      entity zfi_i_xrdh
        all fields with corresponding #( keys )
        result data(lt_result)
      reported data(ls_reported)
      failed data(ls_failed).

    check lt_result is not initial.

    select * from i_companycodecurrencyrole
      order by currencyrole
      into table @data(lt_currencyrole).

    loop at keys into data(ls_key).
      read table lt_result from corresponding #( ls_key )
        using key entity into data(ls_result).

      append initial line to result reference into data(lo_result).
      lo_result->%tky = ls_key-%tky.
      lo_result->%param-currency = ls_result-transactioncurrency.

      loop at lt_currencyrole into data(ls_currencyrole).
        case sy-tabix.
          when 1.
            lo_result->%param-companycodecurrency1 = ls_currencyrole-currency.
          when 2.
            lo_result->%param-localcurrency1 = ls_currencyrole-currency.
          when 3.
            lo_result->%param-localcurrency2 = ls_currencyrole-currency.
        endcase.
      endloop.
    endloop.
  endmethod.

  method checkfieldsmandatoryonsave.
    data:
      ls_request     type structure for permissions request zfi_i_xrdh,
      lv_error       type abap_boolean,
      lv_description type string.

    data(lo_structdescr) = cast cl_abap_structdescr( cl_abap_typedescr=>describe_by_data_ref( ref #( ls_request-%field ) ) ).
    data(lt_component) = lo_structdescr->get_components( ).

    read entities of zfi_i_xrdh in local mode
      entity zfi_i_xrdh
        all fields with corresponding #( keys )
        result data(lt_xrdh)
      reported data(ls_reported)
      failed data(ls_failed).

    check ls_failed-zfi_i_xrdh is initial.

    ls_request-%create = if_abap_behv=>mk-on.

    loop at lt_component into data(ls_component).
      ls_request-%field-(ls_component-name) = if_abap_behv=>mk-on.
    endloop.

    loop at lt_xrdh into data(ls_xrdh).
      clear lv_error.

      append initial line to reported-zfi_i_xrdh reference into data(lo_reported_xrdh).
      lo_reported_xrdh->%tky = ls_xrdh-%tky.
      lo_reported_xrdh->%state_area = 'MANDANT'.

      get permissions entity zfi_i_xrdh
        from value #( ( %key = ls_xrdh-%key ) )
        request ls_request
        result data(ls_permission)
        failed data(ls_failed_perm)
        reported data(ls_reported_perm).

      check ls_failed_perm-zfi_i_xrdh is initial.

      loop at lt_component into ls_component.
        if ls_permission-global-%field-(ls_component-name) eq if_abap_behv=>perm-f-mandatory.
          if ls_xrdh-(ls_component-name) is initial.
            lv_error = abap_true.

            case ls_component-name.
              when 'FISCALPERIOD'.
                lv_description = text-002.
              when 'POSTINGDATE'.
                lv_description = text-004.
              when 'DOCUMENTDATE'.
                lv_description = text-003.
              when others.
                lv_description = ls_component-name.
            endcase.

            append initial line to reported-zfi_i_xrdh reference into lo_reported_xrdh.
            lo_reported_xrdh->* = corresponding #( ls_xrdh ).
            lo_reported_xrdh->%element-(ls_component-name) = if_abap_behv=>mk-on.
            lo_reported_xrdh->%state_area = 'MANDANT'.
            lo_reported_xrdh->%msg = new_message(
              id       = zcl_fi_xr_diff=>co_msgcl
              number   = '001'
              severity = if_abap_behv_message=>severity-error
              v1       = |{ lv_description }|
            ).
          endif.
        endif.
      endloop.

      if lv_error eq abap_true.
        append initial line to failed-zfi_i_xrdh reference into data(lo_failed_xrdh).
        lo_failed_xrdh->* = corresponding #( ls_xrdh ).
        lo_failed_xrdh->%fail-cause = if_abap_behv=>cause-unspecific.
      endif.
    endloop.
  endmethod.

  method currencyclearing.
    data(lo_buffer) = lcl_buffer=>get_instance(  ).
    lo_buffer->set_currency_clearing_keys( keys ).

    read entities of zfi_i_xrdh in local mode
      entity zfi_i_xrdh
        all fields with corresponding #( keys )
        result data(lt_xrdh)
      reported data(ls_reported)
      failed data(ls_failed).

    loop at lt_xrdh into data(ls_xrdh).
      read table keys into data(ls_key)
        using key entity from corresponding #( ls_xrdh ).

      select single count(*) from zfi_i_xrdh
        where companycode                eq @ls_key-%param-companycode
          and clearingfiscalyear         eq @ls_key-%param-fiscalyear
          and clearingaccountingdocument eq @ls_key-%param-accountingdocument
          and disabled                   eq @space.
      if sy-subrc eq 0.
        append initial line to reported-zfi_i_xrdh reference into data(lo_reported_xrdh).
        lo_reported_xrdh->%key = ls_xrdh-%key.
        lo_reported_xrdh->%op-%action-currencyclearing = if_abap_behv=>mk-on.
        lo_reported_xrdh->%element-accountingdocument = if_abap_behv=>mk-on.
        lo_reported_xrdh->%msg = new_message(
          id       = zcl_fi_xr_diff=>co_msgcl
          number   = '005'
          severity = if_abap_behv_message=>severity-error
        ).
      endif.

      if reported-zfi_i_xrdh is not initial.
        append initial line to failed-zfi_i_xrdh reference into data(lo_failed_xrdh).
        lo_failed_xrdh->%key        = ls_xrdh-%key.
        lo_failed_xrdh->%op-%action-currencyclearing = if_abap_behv=>mk-on.
        lo_failed_xrdh->%fail-cause = if_abap_behv=>cause-unspecific.
      endif.

      read table failed-zfi_i_xrdh transporting no fields
        using key entity from corresponding #( ls_xrdh ).
      if sy-subrc ne 0.
        append initial line to result reference into data(lo_result).
        lo_result->%key   = ls_xrdh-%key.
        lo_result->%param = corresponding #( ls_xrdh ).

        append initial line to mapped-zfi_i_xrdh reference into data(lo_mapped_xrdh).
        lo_mapped_xrdh->%key = ls_xrdh-%key.
      endif.
    endloop.
  endmethod.

  method getdefaultsforcurrencyclearing.
    read entities of zfi_i_xrdh in local mode
      entity zfi_i_xrdh
        all fields with corresponding #( keys )
        result final(lt_xrdh)
      by \_item
        all fields with corresponding #( keys )
        result final(lt_xrdi)
      failed final(ls_failed)
      reported final(ls_reported).

    check ls_failed-zfi_i_xrdh is initial.

    loop at lt_xrdh into data(ls_xrdh).
      append initial line to result reference into data(lo_result).
      lo_result->%key = ls_xrdh-%key.
      lo_result->%param-companycode = ls_xrdh-companycode.
      lo_result->%param-fiscalyear  = ls_xrdh-fiscalyear.

      loop at lt_xrdi into data(ls_xrdi) using key entity
        where transactionuuid eq ls_xrdh-transactionuuid.

        if ls_xrdi-customer is not initial.
          lo_result->%param-customer = ls_xrdi-customer.
        elseif ls_xrdi-supplier is not initial.
          lo_result->%param-supplier = ls_xrdi-supplier.
        endif.
      endloop.
    endloop.
  endmethod.

  method reversexrdifference.
    data(lo_buffer) = lcl_buffer=>get_instance(  ).
    lo_buffer->set_reverse_xr_difference_keys( keys ).

    read entities of zfi_i_xrdh in local mode
      entity zfi_i_xrdh
        all fields with corresponding #( keys )
        result data(lt_xrdh)
      reported data(ls_reported)
      failed data(ls_failed).

    loop at lt_xrdh into data(ls_xrdh).
      if ls_xrdh-disabled eq abap_true.
        append initial line to reported-zfi_i_xrdh reference into data(lo_reported_xrdh).
        lo_reported_xrdh->%key = ls_xrdh-%key.
        lo_reported_xrdh->%op-%action-reversexrdifference = if_abap_behv=>mk-on.
        lo_reported_xrdh->%msg = new_message(
          id       = zcl_fi_xr_diff=>co_msgcl
          number   = '010'
          severity = if_abap_behv_message=>severity-error
        ).
      endif.

      if reported-zfi_i_xrdh is not initial.
        append initial line to failed-zfi_i_xrdh reference into data(lo_failed_xrdh).
        lo_failed_xrdh->%key        = ls_xrdh-%key.
        lo_failed_xrdh->%op-%action-reversexrdifference = if_abap_behv=>mk-on.
        lo_failed_xrdh->%fail-cause = if_abap_behv=>cause-unspecific.
      endif.

      read table failed-zfi_i_xrdh transporting no fields
        using key entity from corresponding #( ls_xrdh ).
      if sy-subrc ne 0.
        append initial line to result reference into data(lo_result).
        lo_result->%key   = ls_xrdh-%key.
        lo_result->%param = corresponding #( ls_xrdh ).

        append initial line to mapped-zfi_i_xrdh reference into data(lo_mapped_xrdh).
        lo_mapped_xrdh->%key = ls_xrdh-%key.
      endif.
    endloop.
  endmethod.

  method reversecurrencyclearing.
    data(lo_buffer) = lcl_buffer=>get_instance(  ).
    lo_buffer->set_reverse_curr_clearing_keys( keys ).

    read entities of zfi_i_xrdh in local mode
      entity zfi_i_xrdh
        all fields with corresponding #( keys )
        result data(lt_xrdh)
      reported data(ls_reported)
      failed data(ls_failed).

    loop at lt_xrdh into data(ls_xrdh).
      if ls_xrdh-transactionstatus ne lcl_buffer=>co_txstat_b.
        append initial line to reported-zfi_i_xrdh reference into data(lo_reported_xrdh).
        lo_reported_xrdh->%key = ls_xrdh-%key.
        lo_reported_xrdh->%op-%action-reversecurrencyclearing = if_abap_behv=>mk-on.
        lo_reported_xrdh->%msg = new_message(
          id       = zcl_fi_xr_diff=>co_msgcl
          number   = '009'
          severity = if_abap_behv_message=>severity-error
        ).
      endif.

      if reported-zfi_i_xrdh is not initial.
        append initial line to failed-zfi_i_xrdh reference into data(lo_failed_xrdh).
        lo_failed_xrdh->%key        = ls_xrdh-%key.
        lo_failed_xrdh->%op-%action-reversecurrencyclearing = if_abap_behv=>mk-on.
        lo_failed_xrdh->%fail-cause = if_abap_behv=>cause-unspecific.
      endif.

      read table failed-zfi_i_xrdh transporting no fields
        using key entity from corresponding #( ls_xrdh ).
      if sy-subrc ne 0.
        append initial line to result reference into data(lo_result).
        lo_result->%key   = ls_xrdh-%key.
        lo_result->%param = corresponding #( ls_xrdh ).

        append initial line to mapped-zfi_i_xrdh reference into data(lo_mapped_xrdh).
        lo_mapped_xrdh->%key = ls_xrdh-%key.
      endif.
    endloop.
  endmethod.
endclass.

class lhc_zfi_i_xrdi definition inheriting from cl_abap_behavior_handler.
  private section.
    methods get_instance_features for instance features
      importing keys request requested_features for zfi_i_xrdi result result.
    methods update for modify
      importing entities for update zfi_i_xrdi.
    methods delete for modify
      importing keys for delete zfi_i_xrdi.
    methods read for read
      importing keys for read zfi_i_xrdi result result.
    methods rba_header for read
      importing keys_rba for read zfi_i_xrdi\_header full result_requested result result link association_links.
    methods checkfieldsmandatoryonsave for validate on save
      importing keys for zfi_i_xrdi~checkfieldsmandatoryonsave.
    methods checkfieldvaluesonsave for validate on save
      importing keys for zfi_i_xrdi~checkfieldvaluesonsave.
endclass.

class lhc_zfi_i_xrdi implementation.
  method get_instance_features.
    read entities of zfi_i_xrdh in local mode
      entity zfi_i_xrdi
        all fields with corresponding #( keys )
        result data(lt_xrdi)
      failed data(ls_failed)
      reported data(ls_reported).

    loop at lt_xrdi into data(ls_xrdi).
      append initial line to result reference into data(lo_result).
      lo_result->%tky = ls_xrdi-%tky.
      lo_result->%features-%field-companycodecurrency1 = if_abap_behv=>fc-f-read_only.
      lo_result->%features-%field-currency             = if_abap_behv=>fc-f-read_only.
      lo_result->%features-%field-localcurrency1       = if_abap_behv=>fc-f-read_only.
      lo_result->%features-%field-localcurrency2       = if_abap_behv=>fc-f-read_only.

      if ls_xrdi-glaccount is not initial.
        lo_result->%features-%field-customer = if_abap_behv=>fc-f-read_only.
        lo_result->%features-%field-supplier = if_abap_behv=>fc-f-read_only.
      elseif ls_xrdi-customer is not initial.
        lo_result->%features-%field-glaccount = if_abap_behv=>fc-f-read_only.
        lo_result->%features-%field-supplier  = if_abap_behv=>fc-f-read_only.
      elseif ls_xrdi-supplier is not initial.
        lo_result->%features-%field-glaccount = if_abap_behv=>fc-f-read_only.
        lo_result->%features-%field-customer  = if_abap_behv=>fc-f-read_only.
      endif.
    endloop.
  endmethod.

  method update.
  endmethod.

  method delete.
  endmethod.

  method read.
    loop at keys into data(ls_key).
      select single * from zfi_i_xrdi
        where transactionuuid     eq @ls_key-transactionuuid
          and transactionitemuuid eq @ls_key-transactionitemuuid
        into @data(ls_xrdi).
      if sy-subrc eq 0.
        append corresponding #( ls_xrdi ) to result.
      else.
        append corresponding #( ls_key ) to failed-zfi_i_xrdi.
      endif.
    endloop.
  endmethod.

  method rba_header.
  endmethod.

  method checkfieldsmandatoryonsave.
    data:
      ls_request     type structure for permissions request zfi_i_xrdi,
      lv_error       type abap_boolean,
      lv_description type string.

    data(lo_structdescr) = cast cl_abap_structdescr( cl_abap_typedescr=>describe_by_data_ref( ref #( ls_request-%field ) ) ).
    data(lt_component) = lo_structdescr->get_components( ).

    read entities of zfi_i_xrdh in local mode
      entity zfi_i_xrdi
        all fields with corresponding #( keys )
        result data(lt_xrdi)
      failed data(ls_failed)
      reported data(ls_reported).

    check ls_failed-zfi_i_xrdi is initial.

    loop at lt_component into data(ls_component).
      ls_request-%field-(ls_component-name) = if_abap_behv=>mk-on.
    endloop.

    loop at lt_xrdi into data(ls_xrdi).
      clear lv_error.

      append initial line to reported-zfi_i_xrdi reference into data(lo_reported_xrdi).
      lo_reported_xrdi->%tky = ls_xrdi-%tky.
      lo_reported_xrdi->%state_area = 'MANDANT'.
      lo_reported_xrdi->%path-zfi_i_xrdh-%tky = corresponding #( ls_xrdi ).

      get permissions entity zfi_i_xrdi
        from value #( ( %key = ls_xrdi-%key ) )
        request ls_request
        result data(ls_permission)
        failed data(ls_failed_perm)
        reported data(ls_reported_perm).

      check ls_failed_perm-zfi_i_xrdi is initial.

      loop at lt_component into ls_component.
        if ls_permission-global-%field-(ls_component-name) eq if_abap_behv=>perm-f-mandatory.
          if ls_xrdi-(ls_component-name) is initial.
            lv_error = abap_true.

            case ls_component-name.
              when 'DEBITCREDITCODE'.
                lv_description = text-005.
              when 'TAXCODE'.
                lv_description = text-006.
              when others.
                lv_description = ls_component-name.
            endcase.

            append initial line to reported-zfi_i_xrdi reference into lo_reported_xrdi.
            lo_reported_xrdi->%tky = ls_xrdi-%tky.
            lo_reported_xrdi->%element-(ls_component-name) = if_abap_behv=>mk-on.
            lo_reported_xrdi->%state_area = 'MANDANT'.
            lo_reported_xrdi->%path-zfi_i_xrdh-%tky = corresponding #( ls_xrdi ).
            lo_reported_xrdi->%msg = new_message(
              id       = zcl_fi_xr_diff=>co_msgcl
              number   = '001'
              severity = if_abap_behv_message=>severity-error
              v1       = |{ lv_description }|
            ).
          endif.
        endif.
      endloop.

      if lv_error eq abap_true.
        append initial line to failed-zfi_i_xrdi reference into data(lo_failed_xrdi).
        lo_failed_xrdi->* = corresponding #( ls_xrdi ).
        lo_failed_xrdi->%fail-cause = if_abap_behv=>cause-unspecific.
      endif.
    endloop.
  endmethod.

  method checkfieldvaluesonsave.
    data:
      lv_mwskz type mwskz,
      lv_error type abap_boolean.

    read entities of zfi_i_xrdh in local mode
      entity zfi_i_xrdi
        all fields with corresponding #( keys )
        result data(lt_xrdi)
      failed data(ls_failed)
      reported data(ls_reported).

    check ls_failed-zfi_i_xrdi is initial.

    loop at lt_xrdi into data(ls_xrdi).
      clear lv_error.

      append initial line to reported-zfi_i_xrdi reference into data(lo_reported_xrdi).
      lo_reported_xrdi->%tky = ls_xrdi-%tky.
      lo_reported_xrdi->%state_area = 'VALUES'.
      lo_reported_xrdi->%path-zfi_i_xrdh-%tky = corresponding #( ls_xrdi ).

      if ls_xrdi-debitcreditcode eq lcl_journalentry=>co_shkzg_s and
         ls_xrdi-creditamount is not initial.
        lv_error = abap_true.

        append initial line to reported-zfi_i_xrdi reference into lo_reported_xrdi.
        lo_reported_xrdi->%tky = ls_xrdi-%tky.
        lo_reported_xrdi->%state_area = 'VALUES'.
        lo_reported_xrdi->%path-zfi_i_xrdh-%tky = corresponding #( ls_xrdi ).
        lo_reported_xrdi->%msg = new_message(
          id       = zcl_fi_xr_diff=>co_msgcl
          number   = '006'
          severity = if_abap_behv_message=>severity-error
        ).
      elseif ls_xrdi-debitcreditcode eq lcl_journalentry=>co_shkzg_h and
             ls_xrdi-debitamount is not initial.
        lv_error = abap_true.

        append initial line to reported-zfi_i_xrdi reference into lo_reported_xrdi.
        lo_reported_xrdi->%tky = ls_xrdi-%tky.
        lo_reported_xrdi->%state_area = 'VALUES'.
        lo_reported_xrdi->%path-zfi_i_xrdh-%tky = corresponding #( ls_xrdi ).
        lo_reported_xrdi->%msg = new_message(
          id       = zcl_fi_xr_diff=>co_msgcl
          number   = '007'
          severity = if_abap_behv_message=>severity-error
        ).
      endif.

      if ls_xrdi-taxcode is not initial.
        if lv_mwskz is not initial.
          if lv_mwskz ne ls_xrdi-taxcode.
            lv_error = abap_true.

            append initial line to reported-zfi_i_xrdi reference into lo_reported_xrdi.
            lo_reported_xrdi->%tky = ls_xrdi-%tky.
            lo_reported_xrdi->%state_area = 'VALUES'.
            lo_reported_xrdi->%path-zfi_i_xrdh-%tky = corresponding #( ls_xrdi ).
            lo_reported_xrdi->%msg = new_message(
              id       = zcl_fi_xr_diff=>co_msgcl
              number   = '008'
              severity = if_abap_behv_message=>severity-error
            ).
          endif.
        endif.

        lv_mwskz = ls_xrdi-taxcode.
      endif.

      if lv_error eq abap_true.
        append initial line to failed-zfi_i_xrdi reference into data(lo_failed_xrdi).
        lo_failed_xrdi->* = corresponding #( ls_xrdi ).
        lo_failed_xrdi->%fail-cause = if_abap_behv=>cause-unspecific.
      endif.
    endloop.
  endmethod.
endclass.

class lsc_zfi_i_xrdh definition inheriting from cl_abap_behavior_saver.
  protected section.
    methods finalize redefinition.
    methods check_before_save redefinition.
    methods save redefinition.
    methods cleanup redefinition.
    methods cleanup_finalize redefinition.
endclass.

class lsc_zfi_i_xrdh implementation.
  method finalize.
    data(lo_buffer) = lcl_buffer=>get_instance( ).
    lo_buffer->prepare_db_tables( ).

    lo_buffer->create_xr_diff_invoices(
      changing
        failed   = failed
        reported = reported
    ).

    lo_buffer->create_currency_clearing_docs(
      changing
        failed   = failed
        reported = reported
    ).

    lo_buffer->reverse_currency_clearing_docs(
      changing
        failed   = failed
        reported = reported
    ).

    lo_buffer->reverse_xr_difference_docs(
      changing
        failed   = failed
        reported = reported
    ).
  endmethod.

  method check_before_save.
  endmethod.

  method save.
    data(lo_buffer) = lcl_buffer=>get_instance( ).
    lo_buffer->create_accdoc_numbers( ).
    lo_buffer->save_db( ).
  endmethod.

  method cleanup.
  endmethod.

  method cleanup_finalize.
  endmethod.
endclass.
