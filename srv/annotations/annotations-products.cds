using {PurchaseOrder as service} from '../services';

annotate service.VH_Product with {
    Plant @title : 'Plant';
    Product @title : 'Product';
    ProductName @title : 'Product Name';
};
