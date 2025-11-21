namespace com.globaltalent.purchaseorders;

using {
    cuid,
    managed,
    sap.common.Languages,
    sap.common.Currencies,
    sap.common.CodeList
} from '@sap/cds/common';

//**
/* Remote Services
*/

using {API_COMPANYCODE_SRV as Company} from '../srv/external/API_COMPANYCODE_SRV';
using {CE_PURCHASINGORGANIZATION_0001 as PurchasingOrg} from '../srv/external/CE_PURCHASINGORGANIZATION_0001';
using {CE_PURCHASINGGROUP_0001 as Group} from '../srv/external/CE_PURCHASINGGROUP_0001';
using {ZPURCHASEORDERTYPE_READ as PurchaseOrderType} from '../srv/external/ZPURCHASEORDERTYPE_READ';
using {API_BUSINESS_PARTNER as BusinessPartner} from '../srv/external/API_BUSINESS_PARTNER';
using {API_PLANT_SRV as Plant} from '../srv/external/API_PLANT_SRV';
using {API_STORAGELOCATION_SRV as StorageLocation} from '../srv/external/API_STORAGELOCATION_SRV';
using {API_PRODUCT_SRV as Product} from '../srv/external/API_PRODUCT_SRV';

entity PurchaseOrderHeader : cuid, managed {
    key PurchaseOrder              : String(10) @Core.Computed;
        CompanyCode                : Association to Company.A_CompanyCode; //CompanyCode_CompanyCode
        CompanyCodeName            : String(25);
        PurchasingOrganization     : Association to PurchasingOrg.A_PurchasingOrganization; //PurchasingOrganization_PurchasingOrganization
        PurchasingOrganizationName : String(20);
        PurchasingGroup            : Association to Group.A_PurchasingGroup; //PurchasingGroup_PurchasingGroup
        PurchasingGroupName        : String(18);
        PurchaseOrderType          : Association to PurchaseOrderType.PurchaseOrderType; //PurchaseOrderType_DocumentType
        PurchaseOrderTypeName      : String(20);
        Supplier                   : Association to BusinessPartner.A_Supplier; //Supplier_Supplier
        PurchaseOrderDate          : Date not null;
        DocumentCurrency           : Association to Currencies default 'EUR'; //DocumentCurrency_code (ValueHelp - MatchCode)
        Language                   : Association to Languages default 'EN'; //Language_code (ValueHelp - MatchCode)
        PurchaseOrderStatus        : Association to Status default 'E'; //PurchaseOrderStatus_code
        to_PurchaseOrderItem       : Composition of many PurchaseOrderItem
                                         on to_PurchaseOrderItem.PurchaseOrder = $self;
}

entity PurchaseOrderItem : cuid {
    key PurchaseOrderItem         : String(5) @Core.Computed;
        PurchaseOrderItemText     : String(40);
        Plant                     : Association to Plant.A_Plant; //Plant_Plant
        PlantName                 : String(30);
        StorageLocation           : Association to StorageLocation.StorageLocation; //StorageLocation_StorageLocation
        StorageLocationName       : String(16);
        Material                  : Association to Product.A_Product;   //Material (Nav) / Material_Product
        MaterialName              : String(40);
        MaterialGroup             : String(9);
        ProductType               : String(4);
        OrderQuantity             : Decimal;
        OrderPriceUnit            : Association to UnitMeasures default 'PC'; //OrderPriceUnit_BaseUnit KG PC
        NetPriceAmount            : Decimal;
        DocumentCurrency          : Association to Currencies default 'EUR';
        NetPriceQuantity          : Decimal;
        PurchaseOrderQuantityUnit : Association to UnitMeasures default 'PC';
        TaxCode                   : String(2);
        PurchasingInfoRecord      : String(10);
        PurchaseOrder             : Association to PurchaseOrderHeader; //PurchaseOrder (NavTo) PurchaseOrder_ID && PurchaseOrder_PurchaseOrder
}

entity Status : CodeList {
    key code        : String enum {
            E = 'En espera';
            P = 'Pendiente';
            A = 'Aprobado';
            R = 'Rechazado';
        }
        criticality : Int16;
};

entity UnitMeasures {
    key BaseUnit : String(3);
        UnitName : String(30);
};
