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
using {API_BUSINESS_PARTNER as BusinessPartner } from '../srv/external/API_BUSINESS_PARTNER';

entity PurchaseOrderHeader : cuid, managed {
    key PurchaseOrder              : String(10) not null;
        CompanyCode                : Association to Company.A_CompanyCode; //CompanyCode_CompanyCode
        CompanyCodeName            : String(25);
        PurchasingOrganization     : Association to PurchasingOrg.A_PurchasingOrganization; //PurchasingOrganization_PurchasingOrganization
        PurchasingOrganizationName : String(20);
        PurchasingGroup            : Association to Group.A_PurchasingGroup; //PurchasingGroup_PurchasingGroup
        PurchasingGroupName        : String(18);
        PurchaseOrderType          : Association to PurchaseOrderType.PurchaseOrderType;    //PurchaseOrderType_DocumentType
        PurchaseOrderTypeName      : String(20);
        Supplier                   : Association to BusinessPartner.A_Supplier; //Supplier_Supplier
        PurchaseOrderDate          : Date not null;
        DocumentCurrency           : Association to Currencies; //DocumentCurrency_code (ValueHelp - MatchCode)
        Language                   : Association to Languages; //Language_code (ValueHelp - MatchCode)
        PurchaseOrderStatus        : Association to Status; //PurchaseOrderStatus_code
        to_PurchaseOrderItem       : Composition of many PurchaseOrderItem
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

entity Status : CodeList {
    key code : String enum {
            E = 'En espera';
            P = 'Pendiente';
            A = 'Aprobado';
            R = 'Rechazado';
        }
}
