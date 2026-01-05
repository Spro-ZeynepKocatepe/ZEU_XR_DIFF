@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Belge türü arama yardımı'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
define view entity ZFI_I_ACCDOCTYPE_VH
  as select from I_AccountingDocumentType

  association [0..*] to I_AccountingDocumentTypeText as _Text on $projection.AccountingDocumentType = _Text.AccountingDocumentType
{
      @ObjectModel.text.association: '_Text'
      @Search: { defaultSearchElement: true, ranking: #HIGH }
      @Search.fuzzinessThreshold: 0.8
  key AccountingDocumentType,
      @Consumption.hidden: true
      _Text
}
