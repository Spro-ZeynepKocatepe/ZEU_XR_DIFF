@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ana hesap arama yardımı'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
define view entity ZFI_I_GLACCOUNT_VH
  as select from I_GLAccount
  association [0..1] to I_CompanyCode as _CompanyCode on $projection.CompanyCode = _CompanyCode.CompanyCode
{
      @Search.defaultSearchElement:true
      @Search.fuzzinessThreshold:0.8
      @Search.ranking: #HIGH
      @ObjectModel.text.association: '_Text'
  key GLAccount,
      @ObjectModel.foreignKey.association: '_CompanyCode'
  key CompanyCode,

      @Search.defaultSearchElement:true
      @Search.fuzzinessThreshold:0.8
      @Search.ranking: #HIGH
  key GLAccountExternal,

      _Text[1:Language = $session.system_language].GLAccountLongName,

      AlternativeGLAccount,
      ChartOfAccounts,

      _Text,
      @Consumption.hidden: true
      _CompanyCode
}
where
      AccountIsBlockedForPosting                         = ''
  and _GLAccountInCompanyCode.AccountIsBlockedForPosting = ''
  and IsAutomaticallyPosted                              = ''
  and _GLAccountInCompanyCode.ReconciliationAccountType  = ''
  and ChartOfAccounts                                    = 'YCOA'
