using {com.globaltalent.purchaseorders as entities} from '../db/schema';

/**
 * Remote Services
 */

 using {API_COMPANYCODE_SRV as Company} from './external/API_COMPANYCODE_SRV';
 using {CE_PURCHASINGORGANIZATION_0001 as Organization} from './external/CE_PURCHASINGORGANIZATION_0001';
 using {CE_PURCHASINGGROUP_0001 as Group} from './external/CE_PURCHASINGGROUP_0001';
 using {ZPURCHASEORDERTYPE_READ as PurchaseOrderType} from './external/ZPURCHASEORDERTYPE_READ';
 using {API_BUSINESS_PARTNER as BusinessPartner} from './external/API_BUSINESS_PARTNER';

service PurchaseOrder {

    entity PurchaseOrder as projection on entities.PurchaseOrderHeader;
    entity PurchaseOrderItem as projection on entities.PurchaseOrderItem;

    /**
     * Value Help - VH_
     */
     @readonly
     @cds.persistence.exists
     @cds.persistence.skip
     entity VH_Company as projection on Company.A_CompanyCode {
        key CompanyCode,
            CompanyCodeName
     };

     @readonly
     @cds.persistence.exists
     @cds.persistence.skip
     entity VH_PurchasingOrg as projection on Organization.A_PurchasingOrganization {
        key PurchasingOrganization,
            PurchasingOrganizationName,
            CompanyCode
     };

     @readonly
     @cds.persistence.exists
     @cds.persistence.skip
     entity VH_PurchasingGroup as projection on Group.A_PurchasingGroup{
        key PurchasingGroup,
            PurchasingGroupName
     };

    @readonly
     @cds.persistence.exists
     @cds.persistence.skip
     entity VH_PurchaseOrderType as projection on PurchaseOrderType.PurchaseOrderType{
        key DocumentType,
            Description
     };

     @readonly
     @cds.persistence.exists
     @cds.persistence.skip
     entity VH_Supplier as projection on BusinessPartner.A_Supplier {
        key Supplier,
            SupplierName,
            to_SupplierPurchasingOrg.PurchasingOrganization as PurchasingOrganization
     };
}