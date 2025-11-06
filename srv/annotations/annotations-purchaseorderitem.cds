using {PurchaseOrder as service} from '../services';

annotate service.PurchaseOrderItem with {
    PurchaseOrderItem          @title: 'Purchase Otrder Item';
    PurchaseOrderItemText      @title: 'Purchase Order Item Text';
    Plant                      @title: 'Plant';
    StorageLocation            @title: 'Storage Location';
    Material                   @title: 'Material';
    MaterialGroup              @title: 'Material Group';
    ProductType                @title: 'Product Type';
    OrderQuantity              @title: 'Order Quantity'                @Measures.Unit       : PurchaseOrderQuantityUnit;
    NetPriceAmount             @title: 'Net Price Amount'              @Measures.ISOCurrency: DocumentCurrency;
    NetPriceQuantity           @title: 'Net Price Quantity'            @Measures.Unit       : PurchaseOrderQuantityUnit;
    DocumentCurrency           @title: 'Currency'                      @Common.IsCurrency;
    PurchaseOrderQuantityUnit  @title: 'Purchase Order Quantity Unit'  @Common.IsUnit;
    TaxCode                    @title: 'Tax Code';
    PurchasingInfoRecord       @title: 'Purchasing Info Record';
};


annotate service.PurchaseOrderItem with @(
    UI.HeaderInfo                   : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Item',
        TypeNamePlural: 'Items',
        Title         : {
            $Type: 'UI.DataField',
            Value: Material
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: PurchaseOrder.PurchaseOrder
        }
    },
    UI.LineItem                     : [
        {
            $Type             : 'UI.DataField',
            Value             : PurchaseOrderItem,
            @HTML5.CssDefaults: {
                $Type: 'HTML5.CssDefaultsType',
                width: '10rem'
            },
        },
        {
            $Type: 'UI.DataField',
            Value: Plant
        },
        {
            $Type             : 'UI.DataField',
            Value             : StorageLocation,
            @HTML5.CssDefaults: {
                $Type: 'HTML5.CssDefaultsType',
                width: '10rem'
            },
        },
        {
            $Type: 'UI.DataField',
            Value: Material
        },
        {
            $Type: 'UI.DataField',
            Value: OrderQuantity
        },
        {
            $Type: 'UI.DataField',
            Value: NetPriceAmount
        },
        {
            $Type: 'UI.DataField',
            Value: NetPriceQuantity
        }
    ],
    UI.FieldGroup #PurchaseOrderItem: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: PurchaseOrderItem
            },
            {
                $Type: 'UI.DataField',
                Value: PurchaseOrderItemText
            }
        ]
    },
    UI.Facets                       : [{
        $Type : 'UI.ReferenceFacet',
        Target: '@UI.FieldGroup#PurchaseOrderItem',
        Label : 'Purchase Order Item Information'
    }],
);
