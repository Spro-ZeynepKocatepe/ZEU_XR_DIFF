@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Kur farkı fatura başlık verileri'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZFI_I_XRDH
  as select from    zfi_t_xrdh as XRDH
    left outer join zfi_t_xrdi as XRDI on XRDH.txuuid = XRDI.txuuid

  association [0..1] to I_AccountingDocumentType as _AccountingDocumentType on $projection.AccountingDocumentType = _AccountingDocumentType.AccountingDocumentType
  association [0..1] to I_CompanyCode            as _CompanyCode            on $projection.CompanyCode = _CompanyCode.CompanyCode
  association [0..1] to I_Currency               as _Currency               on $projection.TransactionCurrency = _Currency.Currency
  association [0..1] to I_Customer               as _Customer               on $projection.Customer = _Customer.Customer
  association [0..1] to I_Supplier               as _Supplier               on $projection.Supplier = _Supplier.Supplier
  association [0..1] to ZFI_I_TXSTAT_VH          as _TransactionStatusVH    on $projection.TransactionStatus = _TransactionStatusVH.value_low

  composition [1..*] of ZFI_I_XRDI               as _Item
{
      @ObjectModel.filter.enabled: false
      @Semantics.uuid: true
  key XRDH.txuuid                                                         as TransactionUUID,
      @ObjectModel.filter.enabled: false
      @Semantics.user.createdBy: true
      XRDH.createdby                                                      as CreatedBy,
      @ObjectModel.filter.enabled: false
      @Semantics.systemDateTime.createdAt: true
      XRDH.createdat                                                      as CreatedAt,
      @ObjectModel.filter.enabled: false
      @Semantics.user.lastChangedBy: true
      XRDH.lastchangedby                                                  as LastChangedBy,
      @ObjectModel.filter.enabled: false
      @Semantics.systemDateTime.lastChangedAt: true
      XRDH.lastchangedat                                                  as LastChangedAt,
      @ObjectModel.filter.enabled: false
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      XRDH.locallastchangedat                                             as LocalLastChangedAt,
      @ObjectModel.foreignKey.association: '_AccountingDocumentType'
      @ObjectModel.text.control: #ASSOCIATED_TEXT_UI_HIDDEN
      XRDH.blart                                                          as AccountingDocumentType,
      XRDH.bldat                                                          as DocumentDate,
      XRDH.budat                                                          as PostingDate,
      @ObjectModel.filter.enabled: false
      XRDH.monat                                                          as FiscalPeriod,
      @ObjectModel.foreignKey.association: '_CompanyCode'
      @ObjectModel.text.control: #ASSOCIATED_TEXT_UI_HIDDEN
      XRDH.bukrs                                                          as CompanyCode,
      @ObjectModel.foreignKey.association: '_Currency'
      @ObjectModel.text.control: #ASSOCIATED_TEXT_UI_HIDDEN
      XRDH.waers                                                          as TransactionCurrency,
      @ObjectModel.filter.enabled: false
      XRDH.xblnr                                                          as DocumentReferenceID,
      @ObjectModel.filter.enabled: false
      XRDH.bktxt                                                          as AccountingDocumentHeaderText,
      XRDH.gjahr                                                          as FiscalYear,
      @Consumption: {
        semanticObject: 'AccountingDocument',
        semanticObjectMapping.additionalBinding: [{ localElement: 'AccountingDocument', element: 'AccountingDocument' },
                                                  { localElement: 'FiscalYear', element: 'FiscalYear' },
                                                  { localElement: 'CompanyCode', element: 'CompanyCode' }]
      }
      XRDH.belnr                                                          as AccountingDocument,
      @EndUserText.label: 'Denkleştirme belgesi mali yıl'
      XRDH.auggj                                                          as ClearingFiscalYear,
      @Consumption: {
        semanticObject: 'AccountingDocument',
        semanticObjectMapping.additionalBinding: [{ localElement: 'ClearingAccountingDocument', element: 'AccountingDocument' },
                                                  { localElement: 'ClearingFiscalYear', element: 'FiscalYear' },
                                                  { localElement: 'CompanyCode', element: 'CompanyCode' }]
      }
      XRDH.augbl                                                          as ClearingAccountingDocument,
      @EndUserText.label: 'GÇ mali yıl'
      XRDH.gjahr_c                                                        as CurrencyClearingFiscalYear,
      @EndUserText.label: 'Geri çekme belgesi'
      @Consumption: {
        semanticObject: 'AccountingDocument',
        semanticObjectMapping.additionalBinding: [{ localElement: 'CurrencyClearingDocument', element: 'AccountingDocument' },
                                                  { localElement: 'CurrencyClearingFiscalYear', element: 'FiscalYear' },
                                                  { localElement: 'CompanyCode', element: 'CompanyCode' }]
      }
      XRDH.belnr_c                                                        as CurrencyClearingDocument,
      cast( case when XRDH.belnr = '' then 'X'
                 else ''
            end as abap_boolean preserving type )                         as NoAccountingDocument,
      cast( case when XRDH.belnr_c = '' then 'X'
                 else ''
            end as abap_boolean preserving type )                         as NoCurrencyClearingDocument,
      @ObjectModel.filter.enabled: false
      concat( $projection.CompanyCode,
              concat( '/',
                      concat( $projection.AccountingDocument,
                              concat( '/', $projection.FiscalYear ) ) ) ) as AccountingDocumentFormatted,
      @ObjectModel.foreignKey.association: '_Customer'
      @ObjectModel.text.control: #ASSOCIATED_TEXT_UI_HIDDEN
      XRDI.kunnr                                                          as Customer,
      @ObjectModel.foreignKey.association: '_Supplier'
      @ObjectModel.text.control: #ASSOCIATED_TEXT_UI_HIDDEN
      XRDI.lifnr                                                          as Supplier,
      @ObjectModel.foreignKey.association: '_TransactionStatusVH'
      @ObjectModel.text.control: #ASSOCIATED_TEXT_UI_HIDDEN
      XRDH.txstat                                                         as TransactionStatus,
      cast( case when XRDH.txstat = 'A' then '3'
                 when XRDH.txstat = 'B' then '5'
                 else '1'
            end as abap.char(1) )                                         as TransactionStatusCriticality,
      XRDH.disabled                                                       as Disabled,
      @ObjectModel.filter.enabled: false
      _AccountingDocumentType,
      @ObjectModel.filter.enabled: false
      _CompanyCode,
      @ObjectModel.filter.enabled: false
      _Currency,
      _Customer,
      _Supplier,
      _Item,
      _TransactionStatusVH
}
where
     XRDI.kunnr != ''
  or XRDI.lifnr != ''
