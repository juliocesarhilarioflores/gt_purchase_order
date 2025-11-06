namespace com.globaltalent.purchaseorders;

using {
    cuid,
    managed,
    sap.common.Languages,
    sap.common.Currencies
} from '@sap/cds/common';

entity PurchaseOrderHeader : cuid, managed {
    key PurchaseOrder          : String(10) not null;
        CompanyCode            : String(4) not null;
        PurchasingOrganization : String(4) not null;
        PurchasingGroup        : String(4) not null;
        PurchaseOrderType      : String(4) not null;
        Supplier               : String(10) not null;
        PurchaseOrderDate      : Date not null;
        DocumentCurrency       : Association to Currencies; //DocumentCurrency_code (ValueHelp - MatchCode)
        Language               : Association to Languages;  //Language_code (ValueHelp - MatchCode)
        to_PurchaseOrderItem   : Composition of many PurchaseOrderItem
                                     on to_PurchaseOrderItem.PurchaseOrder = $self;
}

entity PurchaseOrderItem : cuid {
    key PurchaseOrderItem         : String(5);
        PurchaseOrderItemText     : String(40);
        Plant                     : String(4);
        StorageLocation           : String(4);
        Material                  : String(40);
        MaterialGroup             : String(9);
        ProductType               : String(2);
        OrderQuantity             : Decimal;
        OrderPriceUnit            : String(3);
        NetPriceAmount            : Decimal;
        DocumentCurrency          : String(5);
        NetPriceQuantity          : Decimal;
        PurchaseOrderQuantityUnit : String(3);
        TaxCode                   : String(2);
        PurchasingInfoRecord      : String(10);
        PurchaseOrder             : Association to PurchaseOrderHeader;
}
