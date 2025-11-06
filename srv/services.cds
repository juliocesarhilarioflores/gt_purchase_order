using {com.globaltalent.purchaseorders as entities} from '../db/schema';

service PurchaseOrder {
    entity PurchaseOrder as projection on entities.PurchaseOrderHeader;
    entity PurchaseOrderItem as projection on entities.PurchaseOrderItem;
}