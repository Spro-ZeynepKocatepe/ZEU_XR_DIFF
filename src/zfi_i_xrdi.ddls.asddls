@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Kur farkı fatura kalem verileri'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_XRDI
  as select from zfi_t_xrdi
  association [0..1] to ZFI_I_GLACCOUNT_VH as _GLAccount            on $projection.GLAccount = _GLAccount.GLAccount
  association [0..1] to I_Customer         as _Customer             on $projection.Customer = _Customer.Customer
  association [0..1] to I_Supplier         as _Supplier             on $projection.Supplier = _Supplier.Supplier
  association [0..1] to I_DebitCreditCode  as _DebitCreditCode      on $projection.DebitCreditCode = _DebitCreditCode.DebitCreditCode
  association [0..1] to I_Currency         as _Currency             on $projection.Currency = _Currency.Currency
  association [0..1] to I_Currency         as _CompanyCodeCurrency1 on $projection.CompanyCodeCurrency1 = _CompanyCodeCurrency1.Currency
  association [0..1] to I_Currency         as _LocalCurrency1       on $projection.LocalCurrency1 = _LocalCurrency1.Currency
  association [0..1] to I_Currency         as _LocalCurrency2       on $projection.LocalCurrency2 = _LocalCurrency2.Currency
  association [0..1] to I_TaxCode          as _TaxCode              on $projection.TaxCode = _TaxCode.TaxCode
  association [0..1] to I_CostCenter       as _CostCenter           on $projection.CostCenter = _CostCenter.CostCenter
  association [0..1] to I_ProfitCenter     as _ProfitCenter         on $projection.ProfitCenter = _ProfitCenter.ProfitCenter
  association [0..1] to I_Segment          as _Segment              on $projection.Segment = _Segment.Segment

  association        to parent ZFI_I_XRDH  as _Header               on $projection.TransactionUUID = _Header.TransactionUUID
{
      @Semantics.uuid: true
  key txuuid     as TransactionUUID,
      @Semantics.uuid: true
  key tiuuid     as TransactionItemUUID,
      @ObjectModel.foreignKey.association: '_GLAccount'
      hkont      as GLAccount,
      @ObjectModel.foreignKey.association: '_Customer'
      kunnr      as Customer,
      @ObjectModel.foreignKey.association: '_Supplier'
      lifnr      as Supplier,
      sgtxt      as DocumentItemText,
      @ObjectModel.foreignKey.association: '_DebitCreditCode'
      shkzg      as DebitCreditCode,
      @Semantics.amount.currencyCode: 'Currency'
      creda      as CreditAmount,
      @Semantics.amount.currencyCode: 'Currency'
      debia      as DebitAmount,
      @ObjectModel.foreignKey.association: '_Currency'
      @ObjectModel.text.control: #ASSOCIATED_TEXT_UI_HIDDEN
      waers      as Currency,
      zuonr      as AssignmentReference,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency1'
      coma1      as AmountInCompanyCode1,
      @ObjectModel.foreignKey.association: '_CompanyCodeCurrency1'
      @ObjectModel.text.control: #ASSOCIATED_TEXT_UI_HIDDEN
      hwae1      as CompanyCodeCurrency1,
      @Semantics.amount.currencyCode: 'LocalCurrency1'
      loca1      as AmountInLocalCurrency1,
      @ObjectModel.foreignKey.association: '_LocalCurrency1'
      @ObjectModel.text.control: #ASSOCIATED_TEXT_UI_HIDDEN
      waer1      as LocalCurrency1,
      @Semantics.amount.currencyCode: 'LocalCurrency2'
      loca2      as AmountInLocalCurrency2,
      @ObjectModel.foreignKey.association: '_LocalCurrency2'
      @ObjectModel.text.control: #ASSOCIATED_TEXT_UI_HIDDEN
      waer2      as LocalCurrency2,
      @ObjectModel.foreignKey.association: '_TaxCode'
      mwskz      as TaxCode,
      @ObjectModel.foreignKey.association: '_CostCenter'
      kostl      as CostCenter,
      @ObjectModel.foreignKey.association: '_ProfitCenter'
      prctr      as ProfitCenter,
      @ObjectModel.foreignKey.association: '_Segment'
      fb_segment as Segment,
      ps_posid   as WBSElement,
      _GLAccount,
      _Customer,
      _Supplier,
      _DebitCreditCode,
      _Currency,
      _CompanyCodeCurrency1,
      _LocalCurrency1,
      _LocalCurrency2,
      _TaxCode,
      _CostCenter,
      _ProfitCenter,
      _Segment,
      _Header
}
