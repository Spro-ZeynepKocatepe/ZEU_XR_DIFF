@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Yevmiye kaydı arama yardımı'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XXL,
    dataClass: #MIXED
}
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
define view entity ZFI_I_JOURNALENTRY_VH
  as select distinct from I_JournalEntry     as JournalEntry
    inner join            I_JournalEntryItem as JournalEntryItem     on  JournalEntryItem.CompanyCode        = JournalEntry.CompanyCode
                                                                     and JournalEntryItem.FiscalYear         = JournalEntry.FiscalYear
                                                                     and JournalEntryItem.AccountingDocument = JournalEntry.AccountingDocument
    inner join            I_JournalEntryItem as ClearingJournalEntry on  ClearingJournalEntry.SourceLedger       = JournalEntryItem.SourceLedger
                                                                     and ClearingJournalEntry.CompanyCode        = JournalEntryItem.CompanyCode
                                                                     and ClearingJournalEntry.FiscalYear         = JournalEntryItem.ClearingJournalEntryFiscalYear
                                                                     and ClearingJournalEntry.AccountingDocument = JournalEntryItem.ClearingJournalEntry
                                                                     and ClearingJournalEntry.Ledger             = JournalEntryItem.Ledger

  association [0..1] to I_CompanyCode as _CompanyCode on $projection.CompanyCode = _CompanyCode.CompanyCode
  association [0..1] to I_Customer    as _Customer    on $projection.Customer = _Customer.Customer
  association [0..1] to I_Supplier    as _Supplier    on $projection.Supplier = _Supplier.Supplier
  association [0..1] to I_Currency    as _Currency    on $projection.CompanyCodeCurrency = _Currency.Currency
{
      @Search.defaultSearchElement:true
      @Search.fuzzinessThreshold:0.8
      @Search.ranking: #LOW
      @ObjectModel.foreignKey.association: '_CompanyCode'
  key ClearingJournalEntry.CompanyCode,
      @Search.defaultSearchElement:true
      @Search.fuzzinessThreshold:0.8
      @Search.ranking: #LOW
  key ClearingJournalEntry.FiscalYear,
      @Search.defaultSearchElement:true
      @Search.fuzzinessThreshold:0.8
      @Search.ranking: #HIGH
  key ClearingJournalEntry.AccountingDocument,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @ObjectModel.filter.enabled: false
      ClearingJournalEntry.AmountInCompanyCodeCurrency,
      @ObjectModel.filter.enabled: false
      ClearingJournalEntry.CompanyCodeCurrency,
      @ObjectModel.foreignKey.association: '_Customer'
      JournalEntryItem.Customer,
      @ObjectModel.foreignKey.association: '_Supplier'
      JournalEntryItem.Supplier,
      @Consumption.hidden: true
      _CompanyCode,
      @Consumption.hidden: true
      _Customer,
      @Consumption.hidden: true
      _Supplier,
      @Consumption.hidden: true
      _Currency
}
where
       JournalEntry.ReverseDocument                      =  ''

  and  JournalEntryItem.SourceLedger                     =  '0L'
  and  JournalEntryItem.Ledger                           =  '0L'
  and  JournalEntryItem.ClearingJournalEntry             != ''
  and(
       JournalEntryItem.Customer                         != ''
    or JournalEntryItem.Supplier                         != ''
  )
  and  ClearingJournalEntry.TransactionTypeDetermination =  'KDF'
  and  ClearingJournalEntry.AmountInCompanyCodeCurrency  != 0
  and  ClearingJournalEntry.Customer                     =  ''
  and  ClearingJournalEntry.Supplier                     =  ''
