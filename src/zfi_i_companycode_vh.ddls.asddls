@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Şirket kodu arama yardımı'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
define view entity ZFI_I_COMPANYCODE_VH
  as select from I_CompanyCode

  association [0..1] to I_Currency as _Currency on $projection.Currency = _Currency.Currency
  association [0..1] to I_Country  as _Country  on $projection.Country = _Country.Country

{
      @ObjectModel.text.element: ['CompanyCodeName']
      @Search: { defaultSearchElement: true, ranking: #HIGH }
      @Search.fuzzinessThreshold: 0.8
  key CompanyCode,
      @Search: { defaultSearchElement: true, ranking: #LOW }
      CompanyCodeName,
      @Search: { defaultSearchElement: true, ranking: #LOW }
      CityName,
      @Search: { defaultSearchElement: true, ranking: #LOW }
      Country,
      @Search: { defaultSearchElement: true, ranking: #LOW }
      Currency,
      @Consumption.hidden: true  
      _Currency,
      @Consumption.hidden: true  
      _Country
}
