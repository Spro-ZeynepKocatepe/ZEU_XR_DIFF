@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'İşlem durumu'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.dataCategory: #VALUE_HELP
define view entity ZFI_I_TXSTAT_VH
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name : 'ZFI_D_TXSTAT' )
{
      @Semantics.language: true
  key language,
      @ObjectModel.text.element: [ 'text' ]
  key value_low,
      @Semantics.text: true
      text
}
