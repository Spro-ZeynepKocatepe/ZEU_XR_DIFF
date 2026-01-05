@EndUserText.label: 'Kur Farkı Vergi Kodları'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'TaxCodeSingleID' ]
@UI: {
  headerInfo: {
    title.value: 'TaxCodeSingleID'
  }
}
define root view entity ZFI_I_TAXCODE_S
  as select from I_Language
    left outer join I_CstmBizConfignLastChgd on I_CstmBizConfignLastChgd.ViewEntityName = 'ZFI_I_TAXCODE'
  composition [1..*] of ZFI_I_TaxCode as _TaxCode
{
  @UI.facet: [ {
    id: 'ZFI_I_TaxCode', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'Vergi Kodları', 
    position: 1 , 
    targetElement: '_TaxCode'
  } ]
  @UI.lineItem: [ {
    position: 1, label: 'Vergi Kodları ID'
  } ]
  key 'VALUES' as TaxCodeSingleID,
  _TaxCode,
  @UI.hidden: true
  I_CstmBizConfignLastChgd.LastChangedDateTime as LastChangedAtMax
  
}
where I_Language.Language = $session.system_language
