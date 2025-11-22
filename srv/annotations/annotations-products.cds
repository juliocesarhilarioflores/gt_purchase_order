using {PurchaseOrder as service} from '../services';

annotate service.VH_Product with {
    Plant        @title: 'Plant';
    Product      @title: 'Product';
    ProductName  @title: 'Product Name';
    ProductType  @title: 'Product Type';
    ProductGroup @title: 'Product Group';
    BaseUnit     @title: 'Base Unit';
};

annotate service.VH_Product with @(UI.SelectionFields: [Plant]);
