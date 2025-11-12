using {PurchaseOrder as service} from '../services';

using from './annotations-purchaseorderitem';

annotate service.PurchaseOrder with @odata.draft.enabled;

annotate service.PurchaseOrder with {
    PurchaseOrder          @title: 'Purchase Order';
    CompanyCode            @title: 'Company Code';
    PurchasingOrganization @title: 'Purchasing Organization';
    PurchasingGroup        @title: 'Purchasing Group';
    PurchaseOrderType      @title: 'Purchase Order Type';
    PurchaseOrderDate      @title: 'Purchase Order Date';
    Supplier               @title: 'Supplier';
    Language               @title: 'Language';
    DocumentCurrency       @title: 'Currency';
    PurchaseOrderStatus    @title: 'Purchase Order Status';// @Common.FieldControl : #ReadOnly;
};

annotate service.PurchaseOrder with {
    PurchaseOrderStatus    @Common: {
        Text           : PurchaseOrderStatus.name,
        TextArrangement: #TextOnly
    };
    CompanyCode            @Common: {
        Text           : CompanyCodeName,
        TextArrangement: #TextOnly,
        ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'VH_Company',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: CompanyCode_CompanyCode,
                    ValueListProperty: 'CompanyCode'
                },
                {
                    $Type            : 'Common.ValueListParameterOut',
                    LocalDataProperty: CompanyCodeName,
                    ValueListProperty: 'CompanyCodeName'
                }
            ]
        }
    };
    PurchasingOrganization @Common: {
        Text           : PurchasingOrganizationName,
        TextArrangement: #TextFirst,
        ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'VH_PurchasingOrg',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterIn',
                    LocalDataProperty: CompanyCode_CompanyCode,
                    ValueListProperty: 'CompanyCode',
                },
                {
                    $Type            : 'Common.ValueListParameterOut',
                    LocalDataProperty: PurchasingOrganization_PurchasingOrganization,
                    ValueListProperty: 'PurchasingOrganization'
                },
                {
                    $Type            : 'Common.ValueListParameterOut',
                    LocalDataProperty: PurchasingOrganizationName,
                    ValueListProperty: 'PurchasingOrganizationName'
                }
            ]
        }
    };
    PurchasingGroup        @Common: {
        Text           : PurchasingGroupName,
        TextArrangement: #TextFirst,
        ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'VH_PurchasingGroup',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: PurchasingGroup_PurchasingGroup,
                    ValueListProperty: 'PurchasingGroup'
                },
                {
                    $Type            : 'Common.ValueListParameterOut',
                    LocalDataProperty: PurchasingGroupName,
                    ValueListProperty: 'PurchasingGroupName'
                }
            ]
        },
    };
    PurchaseOrderType      @Common: {ValueList: {
        $Type         : 'Common.ValueListType',
        CollectionPath: 'VH_PurchaseOrderType',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: PurchaseOrderType_DocumentType,
                ValueListProperty: 'DocumentType'
            },
            {
                $Type            : 'Common.ValueListParameterOut',
                LocalDataProperty: PurchaseOrderTypeName,
                ValueListProperty: 'Description'
            }
        ]
    }, };
    Supplier               @Common: {ValueList: {
        $Type         : 'Common.ValueListType',
        CollectionPath: 'VH_Supplier',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterIn',
                LocalDataProperty: PurchasingOrganization_PurchasingOrganization,
                ValueListProperty: 'PurchasingOrganization'
            },
            {
                $Type            : 'Common.ValueListParameterOut',
                LocalDataProperty: Supplier_Supplier,
                ValueListProperty: 'Supplier'
            }
        ]
    }};
};


annotate service.PurchaseOrder with @(
    UI.SelectionFields          : [
        PurchaseOrder,
        CompanyCode_CompanyCode,
        PurchasingOrganization_PurchasingOrganization,
        Supplier_Supplier,
        PurchasingGroup_PurchasingGroup,
        PurchaseOrderType_DocumentType,
        Language_code,
        DocumentCurrency_code,
        PurchaseOrderStatus_code
    ],
    UI.HeaderInfo               : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Purchase Order',
        TypeNamePlural: 'Purchase Orders',
        Title         : {
            $Type: 'UI.DataField',
            Value: PurchaseOrder
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: PurchaseOrderDate
        }
    },
    UI.LineItem                 : [
        {
            $Type: 'UI.DataField',
            Value: PurchaseOrder
        },
        {
            $Type             : 'UI.DataField',
            Value             : CompanyCode_CompanyCode,
            @HTML5.CssDefaults: {
                $Type: 'HTML5.CssDefaultsType',
                width: '8rem'
            }
        },
        {
            $Type             : 'UI.DataField',
            Value             : PurchasingOrganization_PurchasingOrganization,
            @HTML5.CssDefaults: {
                $Type: 'HTML5.CssDefaultsType',
                width: '12rem'
            },
        },
        {
            $Type             : 'UI.DataField',
            Value             : PurchasingGroup_PurchasingGroup,
            @HTML5.CssDefaults: {
                $Type: 'HTML5.CssDefaultsType',
                width: '10rem'
            },
        },
        {
            $Type: 'UI.DataField',
            Value: Supplier_Supplier
        },
        {
            $Type             : 'UI.DataField',
            Value             : PurchaseOrderDate,
            @HTML5.CssDefaults: {
                $Type: 'HTML5.CssDefaultsType',
                width: '12rem'
            }
        },
        {
            $Type             : 'UI.DataField',
            Value             : PurchaseOrderStatus_code,
            Criticality : PurchaseOrderStatus.criticality,
            @HTML5.CssDefaults: {
                $Type: 'HTML5.CssDefaultsType',
                width: '10rem'
            }
        }
    ],
    UI.FieldGroup #PurchaseOrder: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: PurchaseOrder
            },
            {
                $Type: 'UI.DataField',
                Value: PurchaseOrderDate,
                Label: 'Order Date'
            },
            {
                $Type: 'UI.DataField',
                Value: PurchaseOrderStatus_code,
                @Common.FieldControl : {
                    $edmJson : {
                        $If: [
                            {
                                $Eq: [
                                    {
                                        $Path: 'IsActiveEntity'
                                    },
                                    false
                                ]
                            },
                            1,
                            3
                        ]
                    }
                }
            }
        ]
    },
    UI.FieldGroup #Organization : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: CompanyCode_CompanyCode
            },
            {
                $Type: 'UI.DataField',
                Value: PurchasingOrganization_PurchasingOrganization
            },
            {
                $Type: 'UI.DataField',
                Value: Supplier_Supplier
            },
            {
                $Type: 'UI.DataField',
                Value: PurchasingGroup_PurchasingGroup
            },
            {
                $Type: 'UI.DataField',
                Value: PurchaseOrderType_DocumentType
            }
        ]
    },
    UI.FieldGroup #Other        : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: DocumentCurrency_code
            },
            {
                $Type: 'UI.DataField',
                Value: Language_code
            }
        ]
    },
    UI.Facets                   : [
        {
            $Type : 'UI.CollectionFacet',
            Facets: [
                {
                    $Type : 'UI.ReferenceFacet',
                    Target: '@UI.FieldGroup#PurchaseOrder',
                    Label : 'Purchase Order Information'
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Target: '@UI.FieldGroup#Organization',
                    Label : 'Organization Information'
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Target: '@UI.FieldGroup#Other',
                    Label : 'Currency and Language'
                }
            ],
            Label : 'General Information'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: 'to_PurchaseOrderItem/@UI.LineItem',
            Label : 'Purchase Order Items'
        }
    ]
);
