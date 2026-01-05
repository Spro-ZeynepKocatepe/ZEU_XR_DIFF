@EndUserText.label: 'Kur farkı vergi kodları'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@UI.textArrangement: #TEXT_LAST
@UI.presentationVariant: [{
    sortOrder: [{ by: 'Mwskz', direction: #ASC }]
}]
define view entity ZFI_I_TaxCode
  as select from zfi_t_taxcode
  association        to parent ZFI_I_TAXCODE_S as _TaxCodeS      on $projection.TaxCodeSingleID = _TaxCodeS.TaxCodeSingleID

  association [0..1] to I_TaxCode              as _TaxCode       on $projection.Mwskz = _TaxCode.TaxCode
  association [0..1] to I_ConditionType        as _ConditionType on $projection.Kschl = _ConditionType.ConditionType
{
      @UI.hidden: true
      @Semantics.uuid: true
  key taxuuid  as Taxuuid,
      @Consumption.valueHelpDefinition: [{
        entity: { name:'I_TaxCodeValueHelp', element: 'TaxCode' }
      }]
      @ObjectModel.foreignKey.association: '_TaxCode'
      mwskz    as Mwskz,
      @Consumption.valueHelpDefinition: [{
        entity: { name:'I_ConditionTypeText', element: 'ConditionType' }
      }]
      @ObjectModel.foreignKey.association: '_ConditionType'
      kschl    as Kschl,
      ktosl    as Ktosl,
      taxrate  as Taxrate,
      @Consumption.hidden: true
      'VALUES' as TaxCodeSingleID,
      _TaxCodeS,
      _TaxCode,
      _ConditionType

}
