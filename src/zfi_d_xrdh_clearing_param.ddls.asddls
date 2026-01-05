@EndUserText.label: 'Geri çekme parametreleri'
@UI.textArrangement: #TEXT_LAST
define root abstract entity ZFI_D_XRDH_CLEARING_PARAM
{
  @UI.facet          : [{
    id               : 'AccountingDocumentFilterFacet',
    purpose          : #FILTER,
    type             : #FIELDGROUP_REFERENCE,
    position         : 10,
    targetQualifier  : 'AccountingDocumentFilterFacet'
  }]
  @UI                : {
    fieldGroup       : [
      { qualifier    : 'AccountingDocumentFilterFacet', position: 10 }
    ]
  }
  @Consumption.valueHelpDefinition: [{
    entity           : { name:'ZFI_I_COMPANYCODE_VH', element: 'CompanyCode' }
  }]
  @UI.hidden: true
  CompanyCode        : bukrs;
  @UI                : {
    fieldGroup       : [
      { qualifier    : 'AccountingDocumentFilterFacet', position: 20 }
    ]
  }
  @Consumption.valueHelpDefinition: [{
    entity           : { name:'I_FiscalYearForCompanyCode', element: 'FiscalYear' },
    additionalBinding: [{localElement: 'CompanyCode', element: 'CompanyCode', usage: #FILTER_AND_RESULT }]
  }]
  FiscalYear         : gjahr;
  @EndUserText.label : 'Denkleştirme kaydı'
  @UI                : {
    fieldGroup       : [
      { qualifier    : 'AccountingDocumentFilterFacet', position: 30 }
    ]
  }
  @Consumption.valueHelpDefinition: [{
    entity           : { name:'ZFI_I_JOURNALENTRY_VH', element: 'AccountingDocument' },
    additionalBinding: [{localElement: 'CompanyCode', element: 'CompanyCode', usage: #FILTER_AND_RESULT },
                        {localElement: 'FiscalYear', element: 'FiscalYear', usage: #FILTER_AND_RESULT },
                        {localElement: 'Customer', element: 'Customer', usage: #FILTER },
                        {localElement: 'Supplier', element: 'Supplier', usage: #FILTER }]
  }]
  AccountingDocument : belnr_d;
  @Consumption.valueHelpDefinition: [{
    entity           : { name:'I_Customer', element: 'Customer' }
  }]
  @UI.hidden: true
  Customer           : kunnr;
  @Consumption.valueHelpDefinition: [{
    entity           : { name:'I_Supplier', element: 'Supplier' }
  }]
  @UI.hidden: true
  Supplier           : lifnr;
}
