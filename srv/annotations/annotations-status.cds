using {PurchaseOrder as service} from '../services';

annotate service.Status with {
    code @title : 'Status' @Common: {
        Text : name,
        TextArrangement : #TextOnly
    }
};
