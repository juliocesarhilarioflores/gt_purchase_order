using {PurchaseOrder as service} from '../services';

annotate service.VH_Supplier with {
    Supplier @title: 'Suppliers' @Common: {
        Text : SupplierName,
        TextArrangement : #TextFirst
    }
};
