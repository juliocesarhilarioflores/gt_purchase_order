using {PurchaseOrder as service} from '../services';

using from './annotations-purchaseorderitem';

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
};


annotate service.PurchaseOrder with @(
    UI.SelectionFields          : [
        PurchaseOrder,
        CompanyCode,
        PurchasingOrganization,
        PurchasingGroup,
        PurchaseOrderType,
        Language_code,
        DocumentCurrency_code
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
            Value             : CompanyCode,
            @HTML5.CssDefaults: {
                $Type: 'HTML5.CssDefaultsType',
                width: '8rem'
            }
        },
        {
            $Type             : 'UI.DataField',
            Value             : PurchasingOrganization,
            @HTML5.CssDefaults: {
                $Type: 'HTML5.CssDefaultsType',
                width: '12rem'
            },
        },
        {
            $Type             : 'UI.DataField',
            Value             : PurchasingGroup,
            @HTML5.CssDefaults: {
                $Type: 'HTML5.CssDefaultsType',
                width: '10rem'
            },
        },
        {
            $Type: 'UI.DataField',
            Value: Supplier
        },
        {
            $Type             : 'UI.DataField',
            Value             : PurchaseOrderDate,
            @HTML5.CssDefaults: {
                $Type: 'HTML5.CssDefaultsType',
                width: '12rem'
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
            }
        ]
    },
    UI.FieldGroup #Organization : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: CompanyCode
            },
            {
                $Type: 'UI.DataField',
                Value: PurchasingOrganization
            },
            {
                $Type: 'UI.DataField',
                Value: Supplier
            },
            {
                $Type: 'UI.DataField',
                Value: PurchasingGroup
            },
            {
                $Type: 'UI.DataField',
                Value: PurchaseOrderType
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
